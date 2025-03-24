//
//  EventBus.swift
//  Junction
//
//  Created by 송지혁 on 1/3/25.
//

import Combine
import Foundation

class EventBus {
    static let shared = EventBus()
    
    private init() { }
    
    let errorPublisher = PassthroughSubject<DomainError, Never>()
    let toastPublisher = PassthroughSubject<ToastEvent, Never>()
}
