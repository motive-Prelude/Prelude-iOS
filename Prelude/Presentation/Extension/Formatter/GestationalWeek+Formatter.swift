//
//  Gestatinal.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

extension GestationalWeek {
    var localized: String {
        switch self {
            case .early: return Localization.GestationalWeek.firstTrimsterOption
            case .mid: return Localization.GestationalWeek.secondTrimsterOption
            case .late: return Localization.GestationalWeek.thirdTrimsterOption
            case .postpartum: return Localization.GestationalWeek.postpartumOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
    
    var weeks: String {
        let weekLocalized = Localization.Label.weekLabel
        
        switch self {
            case .early: return "1-13 \(weekLocalized)"
            case .mid: return "14-27 \(weekLocalized)"
            case .late: return "28-40 \(weekLocalized)"
            case .postpartum: return Localization.GestationalWeek.postpartumDescription
            default: return ""
        }
    }
}
