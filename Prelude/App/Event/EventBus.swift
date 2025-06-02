//
//  EventBus.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


actor EventBus {
    private var continuation: AsyncStream<GlobalEvent>.Continuation?
    
    private lazy var stream: AsyncStream<GlobalEvent> = {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }()
    
    func send(_ event: GlobalEvent) {
        continuation?.yield(event)
    }
    
    func events() -> AsyncStream<GlobalEvent> {
        stream
    }
}