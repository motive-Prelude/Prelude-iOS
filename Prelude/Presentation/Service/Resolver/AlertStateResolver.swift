//
//  AlertStateResolver.swift
//  Prelude
//
//  Created by 송지혁 on 5/24/25.
//

import Foundation

struct AlertStateResolver {
    func resolve<Action>(_ event: AlertEvent, primaryAction: Action, secondaryAction: Action) -> AlertState<Action> {
        switch event {
            case .error(let error):
                switch error {
                    case .networkUnavailable:
                        return AlertState(title: Localization.Dialog.dialogNetworkErrorTitle,
                                          message: Localization.Dialog.dialogNetworkErrorDescription,
                                          primaryButton: .init(label: Localization.Button.retryButtonTitle,
                                                               action: primaryAction,
                                                               role: .primary),
                                          secondaryButton: .init(label: Localization.Button.cancelButtonTitle,
                                                                 action: secondaryAction,
                                                                 role: .secondary))
                        
                    case .serverError:
                        return AlertState(title: Localization.Dialog.dialogServerErrorTitle,
                                          message: Localization.Dialog.dialogServerErrorDescription,
                                          primaryButton: .init(label: Localization.Button.retryButtonTitle,
                                                               action: primaryAction,
                                                               role: .primary),
                                          secondaryButton: .init(label: Localization.Button.cancelButtonTitle,
                                                                 action: secondaryAction,
                                                                 role: .secondary))
                        
                    case .timeout:
                        return AlertState(title: Localization.Dialog.dialogTimeOutTitle,
                                          message: Localization.Dialog.dialogTimeOutDescription,
                                          primaryButton: .init(label: Localization.Button.retryButtonTitle,
                                                               action: primaryAction,
                                                               role: .primary),
                                          secondaryButton: .init(label: Localization.Button.cancelButtonTitle,
                                                                 action: secondaryAction,
                                                                 role: .secondary))
                        
                        
                    default:
                        return AlertState(title: Localization.Dialog.dialogUnknownErrorTitle,
                                          message: Localization.Dialog.dialogUnknownErrorDescription,
                                          primaryButton: .init(label: Localization.Button.retryButtonTitle,
                                                               action: primaryAction,
                                                               role: .primary),
                                          secondaryButton: .init(label: Localization.Button.cancelButtonTitle,
                                                                 action: secondaryAction,
                                                                 role: .secondary))
                        
                }
                
            case .intent(let intent):
                switch intent {
                    case .confirmDeleteAccount:
                        return AlertState(title: Localization.Dialog.dialogDeleteAccountTitle,
                                          message: Localization.Dialog.dialogDeleteAccountDescription,
                                          primaryButton: .init(label: Localization.Button.deleteButtonTitle,
                                                               action: primaryAction,
                                                               role: .destructive),
                                          secondaryButton: .init(label: Localization.Button.cancelButtonTitle,
                                                                 action: secondaryAction,
                                                                 role: .secondary))
                }
                
            
                
                
        }
    }
}
