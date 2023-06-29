//
//  WelcomeModuleFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol WelcomeModuleFlowCoordinatorOutput: ErrorPresenter {
    func openAccountVerification(name: String, email: String)
    func openLogin()
    func openRegistration()
    func openResetPasswordFlow()
    func loggedIn(account: Account)
}

class WelcomeModuleFlowCoordinator: WelcomeModuleFlowCoordinatorOutput, CodeVerificationSuccessProtocol, FlowCoordinator {
    func finish() {
        
    }
    
    func CodeVerificationSuccess() {
        let factory = resolver.resolve(type: NetworkServicesFactory.self) as! NetworkServicesFactory
        let profileCreationCoordinator = ProfileChoiceFlowCoordinator(username: name, navigationController: navigationController,
                                                                      accountService: factory.getAccountService(),
                                                                      imageService: factory.getImagesService(),
                                                                      finishHandler: finishHandler)
        profileCreationCoordinator.start()
    }
    
    var childCoordinators: [FlowCoordinator] = []
    var navigationController: UINavigationController
    var resolver: Resolver
    var finishHandler: (Account) -> Void
    var name = ""
    
    public init(navigationController: UINavigationController,
                resolver: Resolver,
                finishHandler: @escaping (Account)->Void) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.finishHandler = finishHandler
    }
    
    func start() {
        let loginVM = LoginViewModel(moduleOutput: self, authService: AuthService(), resolver: resolver)
        let hostingVC = UIHostingController(rootView: LoginView(viewModel: loginVM))
        navigationController.setViewControllers([hostingVC], animated: false)
    }
    
    func openAccountVerification(name: String, email: String) {
        self.name = name
        let verificationVM = VerificationViewModel(codeVerificationSuccess: self, email: email, resolver: resolver)
        let hostingVC = UIHostingController(rootView: AccountVerificationView(viewModel: verificationVM))
        hostingVC.navigationItem.titleView = createTitleLabel(title: "Код подтверждения")
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    func openLogin() {
        navigationController.popViewController(animated: true)
    }
    
    func openRegistration() {
        let regView = RegistrationView(viewModel: RegViewModel(moduleOutput: self))
    
        let hostingVC = UIHostingController(rootView: regView.navigationBarBackButtonHidden(true))
        hostingVC.navigationItem.setHidesBackButton(true, animated: false)
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    func openResetPasswordFlow() {
        let resetPasswordFlow = ResetPasswordFlowCoordinator(navigationController: navigationController)
        childCoordinators.append(resetPasswordFlow)
        resetPasswordFlow.start()
    }
    
    func loggedIn(account: Account) {
        finishHandler(account)
    }
    
    deinit {
        print("flow coordinator released")
    }
}
