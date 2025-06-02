//
//  ToastEvent.swift
//  Prelude
//
//  Created by 송지혁 on 1/5/25.
//

import SwiftUI

enum ToastEvent {
    case intent(ToastIntent)
    case error(DomainError)
}

extension ToastEvent {
    var icon: Image? {
        switch self {
            case .error:
                return Image(.errorLight)
                
            case .intent(let intent):
                switch intent {
                    case .deleteAccountCompleted, .loggedOut, .purchaseCompleted, .saveCompleted:
                        return Image(.checkSmall)
                        
                    case .saveFailed:
                        return Image(.errorLight)
                }
        }
    }
    
    var message: String {
        switch self {
            case .error(let error):
                switch error {
                    case .authenticationFailed:
                        return Localization.Error.toastAuthenticationError
                        
                    case .networkUnavailable:
                        return Localization.Error.toastNetworkError
                        
                    case .unknown:
                        return Localization.Error.toastUnknownError
                        
                    default: return Localization.Error.toastUnknownError
                        
                }
                
                
            case .intent(let intent):
                switch intent {
                    case .deleteAccountCompleted:
                        return Localization.Label.completeDeleteAccountToastMessage
                        
                    case .loggedOut:
                        return Localization.Label.logoutToastMessage
                        
                    case .purchaseCompleted(let count):
                        return Localization.Label.paySuccessToastMessage(count)
                        
                    case .saveCompleted:
                        return Localization.Label.saveCompleteToastMessage
                        
                    case .saveFailed:
                        return Localization.Label.saveFailedToastMessageDueToNetwokError
                }
        }
    }
}
