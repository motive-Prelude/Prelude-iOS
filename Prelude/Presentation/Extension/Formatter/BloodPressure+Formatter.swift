//
//  File.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


extension BloodPressure {
    var localized: String {
        switch self {
            case .none: return Localization.Label.noneLabel
            case .hypotension: return Localization.BloodPressure.hypoTensionOption
            case .hypertension: return Localization.BloodPressure.hyperTensionOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
}