//
//  ServicesViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import Foundation
import Combine

protocol ServicesViewModelIO:ObservableObject {
    func getServices()
    func editPrice(service: UserServiceInfo)
    func saveServices()
    var services: UserServices {get set}
}

class ServicesViewModel<coordinator: ServicesFlowCoordinatorIO>: ViewModelProtocol, ServicesViewModelIO {
    typealias errorPresenter = coordinator
    
    internal init(output: coordinator,
                  services: UserServices = UserServices(userServeices: []),
                  accountService: AccountService,
                  type: ProfileType) {
        self.moduleOutput = output
        self.services = services
        self.accountService = accountService
        self.type = type
        
        services.$userServices.sink(receiveValue: { servicesInfo in
            for info in servicesInfo {
                info.$endPrice.sink(receiveValue: {_ in self.refresh.toggle()}).store(in: &self.bag)
                info.$startPrice.sink(receiveValue: {_ in self.refresh.toggle()}).store(in: &self.bag)
                info.$paymentType.sink(receiveValue: {_ in self.refresh.toggle()}).store(in: &self.bag)
            }
        }).store(in: &bag)
    }
    
    let moduleOutput: coordinator
    var services: UserServices
    var accountService: AccountService
    var type: ProfileType
    private var cancellable: AnyCancellable?
    var bag: [AnyCancellable] = []
    @Published var refresh = false
    
    func editPrice(service: UserServiceInfo) {
        moduleOutput.editPrice(service: service)
    }
    
    func getServices() {
        cancellable = accountService.getServicesPublisher(forType: type)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { respose in
                if respose.statusCode > 299 {
                    self.showResponseError(response: respose)
                } else {
                    do {
                        let serviceList = try JSONDecoder().decode(ServiceNames.self, from: respose.data)
                        self.moduleOutput.chooseNewServices(servicesList: serviceList, selectedServices: self.services)
                    } catch {
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            })
    }
    
    func saveServices() {
        moduleOutput.saveServices(services: services)
    }
}
