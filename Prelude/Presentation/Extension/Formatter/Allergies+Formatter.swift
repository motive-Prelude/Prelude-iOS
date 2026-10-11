//
//  File.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

extension Allergies {
    var localized: String {
        switch self {
            case .diary: return Localization.Allergy.dairyOption
            case .eggs: return Localization.Allergy.eggsOption
            case .fish: return Localization.Allergy.fishOption
            case .shellfish: return Localization.Allergy.shellfishOption
            case .treeNuts: return Localization.Allergy.treeNutsOption
            case .peanuts: return Localization.Allergy.peanutsOption
            case .wheat: return Localization.Allergy.wheatOption
            case .soy: return Localization.Allergy.soyOption
            case .gluten: return Localization.Allergy.glutenOption
        }
    }
}
