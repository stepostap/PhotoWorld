//
//  ProfileChoiceViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 07.05.2023.
//

import Foundation
import Combine

class ProfileChoiceViewModel<output: ProfileChoiceFlowCoordinatorIO>: ViewModelProtocol {
    internal init(
        name: String,
        output: output,
        accountService: AccountService) {
            self.moduleOutput = output
            self.accountService = accountService
            self.name = name
        }
    
    typealias errorPresenter = output
    var cancellable: AnyCancellable?
    var moduleOutput: output
    var accountService: AccountService
    let name: String
    
    func chooseProfile(type: ProfileType) {
        ProfileType.currentUserType = type
        var spec: [String] = []
        cancellable = accountService.getTagsPublisher(forType: type).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let tags = try JSONDecoder().decode(Tags.self, from: response.data)
                    for tag in tags.tags {
                        spec.append(tag)
                    }
                    ProfileTypeTags.setTags(forType: type, tags: spec)
                    let account = Account(name: self.name, type: type)
                    self.moduleOutput.profileTypeChosen(account: account)
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        })
        
    }
}
