//
//  BasicOperationQueue.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation
import OTAtomics

/// **OTCore:**
/// An `OperationQueue` subclass with useful additions.
open class BasicOperationQueue: OperationQueue {
    
    /// **OTCore:**
    /// Any time the queue completes all of its operations and returns to an empty queue, reset the progress object's total unit count to 0.
    public final var resetProgressWhenFinished: Bool
    
    /// **OTCore:**
    /// A reference to the `Operation` that was last added to the queue. Returns `nil` if the operation finished and no longer exists.
    public final weak var lastAddedOperation: Operation?
    
    /// **OTCore:**
    /// Operation queue type. Determines max concurrent operation count.
    public final var operationQueueType: OperationQueueType {
        didSet {
            updateFromOperationQueueType()
        }
    }
    
    private func updateFromOperationQueueType() {
        
        switch operationQueueType {
        case .serialFIFO:
            maxConcurrentOperationCount = 1
            
        case .concurrentAutomatic:
            maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
            
        case .concurrent(let maxConcurrentOperations):
            maxConcurrentOperationCount = maxConcurrentOperations
        }
        
    }
    
    private var done = true
    
    // MARK: - Status
    
    @OTAtomicsThreadSafe private var _status: OperationQueueStatus = .idle
    /// **OTCore:**
    /// Operation queue status.
    /// To observe changes to this value, supply a closure to the `statusHandler` property.
    public internal(set) var status: OperationQueueStatus {
        get {
            _status
        }
        set {
            let oldValue = _status
            _status = newValue
            
            if newValue != oldValue {
                DispatchQueue.main.async {
                    self.statusHandler?(newValue, oldValue)
                }
            }
        }
    }
    
    public typealias StatusHandler = (_ newStatus: OperationQueueStatus,
                                      _ oldStatus: OperationQueueStatus) -> Void
    
    /// **OTCore:**
    /// Handler called any time the `status` property changes.
    /// Handler is called async on the main thread.
    public final var statusHandler: StatusHandler?
    
    // MARK: - Progress Back-Porting
    
    private var _progress: Progress = .init()
    
    @available(macOS 10.9, iOS 7.0, tvOS 9.0, watchOS 2.0, *)
    @objc dynamic
    public override final var progress: Progress { _progress }
    
    // MARK: - Init
    
    /// **OTCore:**
    /// Set max concurrent operation count.
    /// Status handler is called async on the main thread.
    public init(type operationQueueType: OperationQueueType,
                resetProgressWhenFinished: Bool = false,
                statusHandler: StatusHandler? = nil) {
        
        self.operationQueueType = operationQueueType
        self.resetProgressWhenFinished = resetProgressWhenFinished
        self.statusHandler = statusHandler
        
        super.init()
        
        updateFromOperationQueueType()
        
        addObservers()
        
    }
    
    // MARK: - Overrides
    
    /// **OTCore:**
    /// Add an operation to the operation queue.
    public final override func addOperation(
        _ op: Operation
    ) {
        
        switch operationQueueType {
        case .serialFIFO:
            // to enforce a serial queue, we add the previous operation as a dependency to the new one if it still exists
            if let lastOp = lastAddedOperation {
                op.addDependency(lastOp)
            }
        default:
            break
        }
        
        // update progress
        if let basicOp = op as? BasicOperation {
            progress.totalUnitCount += 100
            // give 100 units of progress in case child progress reports fractional progress
            progress.addChild(basicOp.progress,
                              withPendingUnitCount: 100)
        } else {
            progress.totalUnitCount += 1
        }
        
        lastAddedOperation = op
        
        done = false
        super.addOperation(op)
        
    }
    
    /// **OTCore:**
    /// Add an operation block.
    public final override func addOperation(
        _ block: @escaping () -> Void
    ) {
        
        // wrap in an actual operation object so we can track it
        let op = ClosureOperation {
            block()
        }
        addOperation(op)
        
    }
    
    /// **OTCore:**
    /// Add operation blocks.
    /// If queue type is Serial FIFO, operations will be added in array order.
    public final override func addOperations(
        _ ops: [Operation],
        waitUntilFinished wait: Bool
    ) {
        guard !ops.isEmpty else { return }
        
        switch operationQueueType {
        case .serialFIFO:
            // to enforce a serial queue, we add the previous operation as a dependency to the new one if it still exists
            var parentOperation: Operation? = lastAddedOperation
            ops.forEach {
                if let parentOperation = parentOperation {
                    $0.addDependency(parentOperation)
                }
                parentOperation = $0
            }
            
        default:
            break
        }
        
        // update progress
        for op in ops {
            if let basicOp = op as? BasicOperation {
                progress.totalUnitCount += 100
                // give 100 units of progress in case child progress reports fractional progress
                progress.addChild(basicOp.progress,
                                  withPendingUnitCount: 100)
            } else {
                progress.totalUnitCount += 1
            }
        }
        
        lastAddedOperation = ops.last
        
        done = false
        super.addOperations(ops, waitUntilFinished: wait)
        
    }
    
    // MARK: - KVO Observers
    
    /// **OTCore:**
    /// Retain property observers. For safety, this array must be emptied on class deinit.
    private var observers: [NSKeyValueObservation] = []
    
    private func addObservers() {
        
        // self.isSuspended
        
        observers.append(
            observe(\.isSuspended, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if isSuspended {
                    status = .paused
                } else {
                    if done {
                        setStatusIdle(resetProgress: resetProgressWhenFinished)
                    } else {
                        status = .inProgress(
                            fractionCompleted: progress.fractionCompleted,
                            message: progress.localizedDescription
                        )
                        
                    }
                }
            }
        )
        
        // self.operationCount
        
        observers.append(
            observe(\.operationCount, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                guard !isSuspended else { return }
                
                if !done,
                   !progress.isFinished,
                   operationCount > 0
                {
                    status = .inProgress(fractionCompleted: progress.fractionCompleted,
                                         message: progress.localizedDescription)
                } else {
                    setStatusIdle(resetProgress: resetProgressWhenFinished)
                }
            }
        )
        
        // self.progress.fractionCompleted
        // (NSProgress docs state that fractionCompleted is KVO-observable)
        
        observers.append(
            progress.observe(\.fractionCompleted, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                guard !isSuspended else { return }
                
                if done ||
                    progress.isFinished ||
                    progress.completedUnitCount == progress.totalUnitCount ||
                    operationCount == 0
                {
                    setStatusIdle(resetProgress: resetProgressWhenFinished)
                } else {
                    status = .inProgress(fractionCompleted: progress.fractionCompleted,
                                         message: progress.localizedDescription)
                }
            }
        )
        
        // self.progress.isFinished
        // (NSProgress docs state that isFinished is KVO-observable)
        
        observers.append(
            progress.observe(\.isFinished, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if progress.isFinished {
                    setStatusIdle(resetProgress: resetProgressWhenFinished)
                }
            }
        )
        
    }
    
    private func removeObservers() {
        
        observers.forEach { $0.invalidate() } // for extra safety, invalidate them first
        observers.removeAll()
        
    }
    
    /// Only call as a result of the queue emptying
    private func setStatusIdle(resetProgress: Bool) {
        if resetProgress,
           progress.totalUnitCount != 0,
           progress.completedUnitCount != 0
        {
            progress.totalUnitCount = 0
            progress.completedUnitCount = 0
        }
        
        done = true
        status = .idle
    }
    
    deinit {
        
        // this is very important or it may result in random crashes if the KVO observers aren't nuked at the appropriate time
        removeObservers()
        
    }
    
}

#endif
