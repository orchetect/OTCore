//
//  BasicOperationQueue.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

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
    
    // MARK: - Status
    
    /// Operation queue status.
    /// To observe changes to this value, supply a closure to the `statusHandler` property.
    @Atomic public internal(set) var status: OperationQueueStatus = .idle {
        didSet {
            if status != oldValue {
                statusHandler?(status, oldValue)
            }
        }
    }
    
    public typealias StatusHandler = (_ newStatus: OperationQueueStatus,
                                      _ oldStatus: OperationQueueStatus) -> Void
    
    /// **OTCore:**
    /// Handler called any time the `status` property changes.
    public final var statusHandler: StatusHandler?
    
    // MARK: - Progress Back-Porting
    
    @Atomic private var _progress: Progress = .init()
    
    @available(macOS 10.9, iOS 7.0, tvOS 9.0, watchOS 2.0, *)
    @objc dynamic
    public override final var progress: Progress { _progress }
    
    // MARK: - Init
    
    /// **OTCore:**
    /// Set max concurrent operation count.
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
        progress.totalUnitCount += 1
        if let basicOp = op as? BasicOperation {
            // OperationQueue considers each operation to be 1 unit of progress in the overall queue progress, regardless of how the child operation progress decides to set up its total unit count
            progress.addChild(basicOp.progress,
                              withPendingUnitCount: 1)
        }
        
        lastAddedOperation = op
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
        progress.totalUnitCount += Int64(ops.count)
        for op in ops {
            if let basicOp = op as? BasicOperation {
                // OperationQueue considers each operation to be 1 unit of progress in the overall queue progress, regardless of how the child operation progress decides to set up its total unit count
                progress.addChild(basicOp.progress,
                                  withPendingUnitCount: 1)
            }
        }
        
        lastAddedOperation = ops.last
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
                
                if self.isSuspended {
                    self.status = .paused
                } else {
                    if self.operationCount > 0 {
                        self.status = .inProgress(
                            fractionCompleted: progress.fractionCompleted,
                            message: progress.localizedDescription
                        )
                    } else {
                        self.status = .idle
                    }
                }
            }
        )
        
        // self.operationCount
        
        observers.append(
            observe(\.operationCount, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                guard !self.isSuspended else { return }
                guard !progress.isFinished else { return }
                if self.operationCount > 0 {
                    self.status = .inProgress(fractionCompleted: progress.fractionCompleted,
                                              message: progress.localizedDescription)
                } else {
                    self.status = .idle
                }
            }
        )
        
        // self.progress.fractionCompleted
        // (NSProgress docs state that fractionCompleted is KVO-observable)
        
        observers.append(
            progress.observe(\.fractionCompleted, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                guard !self.isSuspended else { return }
                guard !progress.isFinished,
                      self.operationCount > 0 else {
                          self.status = .idle
                          return
                      }
                self.status = .inProgress(fractionCompleted: progress.fractionCompleted,
                                          message: progress.localizedDescription)
            }
        )
        
        // self.progress.isFinished
        // (NSProgress docs state that isFinished is KVO-observable)
        
        observers.append(
            progress.observe(\.isFinished, options: [.new])
            { [self, progress] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if progress.isFinished {
                    if self.resetProgressWhenFinished {
                        progress.totalUnitCount = 0
                    }
                    self.status = .idle
                }
            }
        )
        
    }
    
    private func removeObservers() {
        
        observers.forEach { $0.invalidate() } // for extra safety, invalidate them first
        observers.removeAll()
        
    }
    
    deinit {
        
        // this is very important or it may result in random crashes if the KVO observers aren't nuked at the appropriate time
        removeObservers()
        
    }
    
}

#endif
