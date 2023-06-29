//
//  ServicesChoiceViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import Foundation

protocol ServicesChoiceViewModelIO: ObservableObject {
    func servicesWereChosen() -> Bool
    func passChosenServices()
    var servicesPresent: [(serviceName: String, present: Bool)] {get set}
}

class ServicesChoiceViewModel<coordinator: ServicesFlowCoordinatorIO>: ViewModelProtocol, ServicesChoiceViewModelIO {
    
    typealias errorPresenter = coordinator
    
    @Published var servicesPresent: [(serviceName: String, present: Bool)] = []
    let moduleOutput: coordinator
    var chosenServiceInfo: UserServices
   
    internal init(servicesPresent: ServiceNames, moduleOutput: coordinator, chosenServiceInfo: UserServices) {
        self.moduleOutput = moduleOutput
        self.chosenServiceInfo = chosenServiceInfo
        
        for service in servicesPresent.services {
            self.servicesPresent.append((serviceName: service,
                                         present: chosenServiceInfo.userServices.contains(where: { temp in
                temp.serviceName == service
            })))
        }
    }
    
    func passChosenServices() {
        for temp in servicesPresent {
            if temp.present && !chosenServiceInfo.userServices.contains(where: { a in a.serviceName == temp.serviceName }) {
                chosenServiceInfo.userServices.append(UserServiceInfo(service: temp.serviceName, paymentType: .fixed))
            } else if !temp.present && chosenServiceInfo.userServices.contains(where: { a in a.serviceName == temp.serviceName }) {
                let index = chosenServiceInfo.userServices.firstIndex(where: {a in a.serviceName == temp.serviceName})
                chosenServiceInfo.userServices.remove(at: index!)
            }
        }
        moduleOutput.servicesChosen()
    }
    
    func servicesWereChosen() -> Bool {
        for temp in servicesPresent {
            if temp.present {
                return true
            }
        }
        return false
    }
}
