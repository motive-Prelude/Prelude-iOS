//
//  UserInfo.swift
//  Junction
//
//  Created by 송지혁 on 10/9/24.
//

import SwiftData
import Foundation

@Model
final class UserInfo {
    var id: String
    var remainingTimes: UInt = 0
    var healthInfo: HealthInfo?
    var lastModified: Date
    var didAgreeToTermsAndConditions: Bool
    var didReceiveGift: Bool
    
    init(id: String, remainingTimes: UInt, healthInfo: HealthInfo? = nil, lastModified: Date = Date(), didAgreeToTermsAndConditions: Bool = false, didReceiveGift: Bool = false) {
        self.id = id
        self.remainingTimes = remainingTimes
        self.healthInfo = healthInfo
        self.lastModified = lastModified
        self.didAgreeToTermsAndConditions = didAgreeToTermsAndConditions
        self.didReceiveGift = didReceiveGift
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.remainingTimes = try container.decode(UInt.self, forKey: .remainingTimes)
        self.healthInfo = try container.decodeIfPresent(HealthInfo.self, forKey: .healthInfo)
        self.lastModified = try container.decode(Date.self, forKey: .lastModified)
        self.didAgreeToTermsAndConditions = try container.decode(Bool.self, forKey: .didAgreeToTermsAndConditions)
        self.didReceiveGift = try container.decode(Bool.self, forKey: .didReceiveGift)
    }
}

// MARK: Codable
extension UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case id, remainingTimes, healthInfo, lastModified, didAgreeToTermsAndConditions, didReceiveGift
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(remainingTimes, forKey: .remainingTimes)
        try container.encode(healthInfo, forKey: .healthInfo)
        try container.encode(lastModified, forKey: .lastModified)
        try container.encode(didAgreeToTermsAndConditions, forKey: .didAgreeToTermsAndConditions)
        try container.encode(didReceiveGift, forKey: .didReceiveGift)
    }
}
