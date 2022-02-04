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
    
    // MARK: - Init
    
    /// **OTCore:**
    /// Set max concurrent operation count.
    public init(type operationQueueType: OperationQueueType) {
        
        self.operationQueueType = operationQueueType
        
        super.init()
        
        updateFromOperationQueueType()
        
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
        
        lastAddedOperation = ops.last
        
        super.addOperations(ops, waitUntilFinished: wait)
        
    }
    
}

#endif
