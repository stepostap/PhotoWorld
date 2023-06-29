//
//  SpecializationChoiceViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import Foundation
import Moya
import Combine
import SwiftUI

protocol SpecializationChoiceViewModelIO: ObservableObject {
    var specializations: [(specialization: String, present: Bool)] {get set}
    var specsChosen: Bool {get}
    func passChosenSpecs()
}

class SpecializationChoiceViewModel<coordinator: ErrorPresenter>: SpecializationChoiceViewModelIO, ViewModelProtocol {
    
    internal init(specializationsChosen: @escaping (Account)->Void,
                  accountService: AccountService,
                  account: Account,
                  moduleOutput: coordinator) {
        self.accountService = accountService
        self.account = account
        self.specializationsChosen = specializationsChosen
        self.moduleOutput = moduleOutput
        self.specializations = []
        
        if let tags = ProfileTypeTags.getTags(forType: account.type) {
            for tag in tags {
                specializations.append((specialization: tag,
                             present: self.account.tags?.contains(tag) ?? false))
            }
        } else {
            loadTags()
        }
    }
    
    typealias errorPresenter = coordinator
    @Published var specializations: [(specialization: String, present: Bool)]
    private let accountService: AccountService
    var cancellable: AnyCancellable?
    let account: Account
    let specializationsChosen: (Account)->Void
    var moduleOutput: coordinator
    
    func loadTags() {
        var spec: [String] = []
        cancellable = accountService.getTagsPublisher(forType: account.type).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let tags = try JSONDecoder().decode(Tags.self, from: response.data)
                    for tag in tags.tags {
                        spec.append(tag)
                        self.specializations.append((specialization: tag,
                                     present: self.account.tags?.contains(tag) ?? false))
                    }
                    ProfileTypeTags.setTags(forType: self.account.type, tags: spec)
                    
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        })
    }
    
    var specsChosen: Bool {
        for temp in specializations {
            if temp.present {
                return true
            }
        }
        return false
    }
    
    func passChosenSpecs() {
        var specs: [String] = []
        for temp in specializations {
            if temp.present {
                specs.append(temp.specialization)
            }
        }
        account.tags = specs
        specializationsChosen(account)
    }
}
