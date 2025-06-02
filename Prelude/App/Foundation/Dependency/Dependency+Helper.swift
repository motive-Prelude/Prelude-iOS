//
//  Dependency+Helper.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture

private enum AlertStateResolverKey: DependencyKey {
    static let liveValue = AlertStateResolver()
}

private enum PromptGeneratorKey: DependencyKey {
    static let liveValue: PromptGenerator = {
        return PromptGenerator()
    }()
}

private enum EventBusKey: DependencyKey {
    static let liveValue = EventBus()
}

extension DependencyValues {
    var promptGenerator: PromptGenerator {
        get { self[PromptGeneratorKey.self] }
        set { self[PromptGeneratorKey.self] = newValue }
    }
    
    var alertStateResolver: AlertStateResolver {
        get { self[AlertStateResolverKey.self] }
        set { self[AlertStateResolverKey.self] = newValue }
    }
    
    var eventBus: EventBus {
        get { self[EventBusKey.self] }
        set { self[EventBusKey.self] = newValue }
    }
}
