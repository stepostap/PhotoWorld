//
//  AccountEditingFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 11.05.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol AccountEditingFlowCoordinatorIO: ErrorPresenter {
    func editShortInfo()
    func editTags(account: Account)
    func editServices(account: Account)
    func exitAccount()
}

class AccountEditingFlowCoordinator: FlowCoordinator, AccountEditingFlowCoordinatorIO {
    internal init(navigationController: UINavigationController,
                  imageService: ImagesService,
                  accountService: AccountService,
                  account: Account,
                  exit: @escaping ()->Void) {
        self.navigationController = navigationController
        self.imageService = imageService
        self.accountService = accountService
        self.account = account
        self.exit = exit
    }
    
    var navigationController: UINavigationController
    let imageService: ImagesService
    let accountService: AccountService
    let account: Account
    var exit: ()->Void
    
    func start() {
        let vm = AccountEditingViewModel(moduleOutput: self, account: account, accountService: accountService)
        let view = AccountEditingView(viewModel: vm)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Редактирование")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func editShortInfo() {
        let shortInfoVM = ShortInfoViewModel(account: account,
                                             passInfo: {_ in self.navigationController.popViewController(animated: true)})
        let shortInfoView = ShortInfoView(viewModel: shortInfoVM)
        let hosting = UIHostingController(rootView: shortInfoView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func editTags(account: Account) {
        let specChoiceVM = SpecializationChoiceViewModel(specializationsChosen: { _ in self.navigationController.popViewController(animated: true)
        },
                                                         accountService: accountService,
                                                         account: account, moduleOutput: self)
        
        let specChoiceView = SpecializationChoiceView(viewModel: specChoiceVM)
        let hosting = UIHostingController(rootView: specChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func editServices(account: Account) {
        let serviceChoiceFlowCoordinator = ServicesFlowCoordinator(navigationController: navigationController,
                                                                   accountService: accountService, type: account.type, passChosenServices: { services in
            account.services = services
            self.navigationController.popViewController(animated: true)
        })
        
        if let services = account.services {
            serviceChoiceFlowCoordinator.start(services: services)
        } else {
            serviceChoiceFlowCoordinator.start()
        }
    }
    
    func exitAccount() {
        exit()
    }
    
    func finish() {
        
    }
    
    
    
}
