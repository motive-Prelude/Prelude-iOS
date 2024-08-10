//
//  AssistantInteractionFacade.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import Combine
import Foundation

protocol AssistantInteractionFacade {
    func interact(with message: String) -> AnyPublisher<String, Error>
}
