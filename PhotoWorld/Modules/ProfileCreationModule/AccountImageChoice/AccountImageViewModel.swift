//
//  AccountImageViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 08.05.2023.
//

import Foundation
import UIKit
import Combine

protocol AccountImageViewModelIO: ObservableObject {
    var mediaItems: PickedMediaItems {get set}
    func uploadImage()
}

class AccountImageViewModel<coordinator: ProfileChoiceFlowCoordinatorIO> : ViewModelProtocol, AccountImageViewModelIO {
    internal init(account: Account,
                  moduleOutput: coordinator,
                  imageService: ImagesService,
                  accountService:  AccountService) {
        self.moduleOutput = moduleOutput
        self.imageService = imageService
        self.accountService = accountService
        self.account = account
    }
    
    typealias errorPresenter = coordinator
    
    let moduleOutput: coordinator
    let imageService: ImagesService
    let accountService: AccountService
    var mediaItems = PickedMediaItems()
    let account: Account
    var bag: [AnyCancellable] = []
    
    func uploadImage() {
        if let image = mediaItems.items.first?.photo {
            imageService.getUploadImagePublisher(image: image).sink(receiveCompletion: { res in
                self.checkComplition(res: res, completion: { self.moduleOutput.createProfile(account: self.account) })
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        let url = try JSONDecoder().decode(DownloadImageURL.self, from: response.data)
                        self.account.profileImageURL = url.imageUrl
                        self.createProfile()
                    } catch {
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            }).store(in: &bag)
        } else {
            self.createProfile()
        }
    }
    
    func createProfile() {
        accountService.getProfileCreationPublisher(account: account).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            print(response)
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                self.moduleOutput.createProfile(account: self.account)
            }
        }).store(in: &bag)
    }
}
