//
//  Diabetes+Formatter.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

extension Diabetes {
    var localized: String {
        switch self {
            case .none: return Localization.Label.noneLabel
            case .type1: return Localization.Diabetes.type1Option
            case .type2: return Localization.Diabetes.type2Option
            case .gestational: return Localization.Diabetes.gestationalOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
}
