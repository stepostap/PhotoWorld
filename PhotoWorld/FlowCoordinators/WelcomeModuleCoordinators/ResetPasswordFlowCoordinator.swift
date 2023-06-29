//
//  ResetPasswordFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol ResetPasswordModuleOutput: FlowCoordinator {
    func commmitEmail(email: String)
    func changePasswordSuccess()
    func goToLogin()
}

class ResetPasswordFlowCoordinator: ResetPasswordModuleOutput, CodeVerificationSuccessProtocol {
    func finish() {
        
    }
    
    func commmitEmail(email: String) {
        let accountVerificationVM = VerificationViewModel(codeVerificationSuccess: self, email: email)
        let accountVerificationView = AccountVerificationView(viewModel: accountVerificationVM)
        let hostingVC = UIHostingController(rootView: accountVerificationView)
        hostingVC.navigationItem.titleView = createTitleLabel(title: "Введите код из письма")
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    func changePasswordSuccess() {
        let changePasswordSuccesView = ResetPasswordSuccessView(successButtonPressed: goToLogin).navigationBarBackButtonHidden()
        let hostingVC = UIHostingController(rootView: changePasswordSuccesView)
        hostingVC.navigationItem.setHidesBackButton(true, animated: false)
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    func goToLogin() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func CodeVerificationSuccess() {
        let enterNewPasswordVM = EnterNewPasswordViewModel(resetPasswordModuleOutput: self)
        let enterNewPasswordView = ResetPasswordNewPasswordView(viewModel: enterNewPasswordVM)
        let hostingVC = UIHostingController(rootView: enterNewPasswordView)
        hostingVC.navigationItem.titleView = createTitleLabel(title: "Новый пароль")
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    internal init(childCoordinators: [FlowCoordinator] = [], navigationController: UINavigationController) {
        self.childCoordinators = childCoordinators
        self.navigationController = navigationController
    }
    
    var childCoordinators: [FlowCoordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        let enterEmailVM = EnterEmailViewModel(resetPasswordModuleOutput: self)
        let enterEmailHostingVC = UIHostingController(rootView: ResetPasswordEmailView(viewModel: enterEmailVM))
        enterEmailHostingVC.navigationItem.titleView = createTitleLabel(title: "Введите email")
        navigationController.pushViewController(enterEmailHostingVC, animated: true)
    }
}
