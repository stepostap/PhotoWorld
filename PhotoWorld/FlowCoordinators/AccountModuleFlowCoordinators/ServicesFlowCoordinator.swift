//
//  ServicesFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol ServicesFlowCoordinatorIO: ErrorPresenter {
    func chooseNewServices(servicesList: ServiceNames, selectedServices: UserServices )
    func editPrice(service: UserServiceInfo)
    func saveServices(services: UserServices)
    func servicesChosen()
}

class ServicesFlowCoordinator: ServicesFlowCoordinatorIO, FlowCoordinator {

    internal init(navigationController: UINavigationController,
                  accountService: AccountService,
                  type: ProfileType,
                  passChosenServices: @escaping (UserServices)->Void) {
        self.navigationController = navigationController
        self.accountService = accountService
        self.type = type
        self.passChosenServices = passChosenServices
    }
    let accountService: AccountService
    var navigationController: UINavigationController
    let type: ProfileType
    let passChosenServices: (UserServices)->Void
    
    func chooseNewServices(servicesList: ServiceNames, selectedServices: UserServices) {
        let chooseNewServicesViewModel = ServicesChoiceViewModel(servicesPresent: servicesList, moduleOutput: self, chosenServiceInfo: selectedServices)
        let serviceChoiceView = ServicesChoiceView(viewModel: chooseNewServicesViewModel)
        let hosting = UIHostingController(rootView: serviceChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: "Добавить услугу")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func editPrice(service: UserServiceInfo) {
        let view = ServicePaymentView(service: service, saveChanges: { self.navigationController.popViewController(animated: true) })
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: service.serviceName)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func servicesChosen() {
        navigationController.popViewController(animated: true)
    }
    
    func saveServices(services: UserServices) {
        passChosenServices(services)
    }
    
    func start(services: UserServices) {
        let servicesViewModel = ServicesViewModel(output: self, services: services, accountService: accountService, type: type)
        let view = ServicesView(viewModel: servicesViewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Услуги и цены")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func start() {
        let servicesViewModel = ServicesViewModel(output: self, accountService: accountService, type: type)
        let view = ServicesView(viewModel: servicesViewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Услуги и цены")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func finish() {
        
    }
}
