//
//  RunStepResponse.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct RunStepResponse: Codable {
    let data: [RunStep]
    
    struct RunStep: Codable {
        let stepDetails: StepDetails
        
        struct StepDetails: Codable {
            let messageCreation: MessageCreation?
            
            struct MessageCreation: Codable {
                let messageId: String
                
                enum CodingKeys: String, CodingKey {
                    case messageId = "message_id"
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case messageCreation = "message_creation"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case stepDetails = "step_details"
        }
    }
}
