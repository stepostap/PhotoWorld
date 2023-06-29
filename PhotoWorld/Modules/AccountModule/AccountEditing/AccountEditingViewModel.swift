//
//  AccountEditingViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 11.05.2023.
//

import Foundation
import Combine

protocol AccountEditingViewModelIO: ObservableObject {
    var account: Account { get }
    func openInfoEditing()
    func openTagsEditing()
    func editServices()
    func exit()
}

class AccountEditingViewModel<coordinator: AccountEditingFlowCoordinatorIO>: ViewModelProtocol,
                                                                             AccountEditingViewModelIO {
    internal init(moduleOutput: coordinator,
                  account: Account,
                  accountService: AccountService) {
        self.moduleOutput = moduleOutput
        self.account = account
        self.accountService = accountService
    }
    
    typealias errorPresenter = coordinator
    let moduleOutput: coordinator
    let account: Account
    let accountService: AccountService
    var cancellable: AnyCancellable?
    
    func openInfoEditing() {
        moduleOutput.editShortInfo()
    }
    
    func openTagsEditing() {
        self.moduleOutput.editTags(account: account)
    }
    
    func editServices() {
        moduleOutput.editServices(account: account)
    }
    
    func exit() {
        moduleOutput.exitAccount()
    }
}
