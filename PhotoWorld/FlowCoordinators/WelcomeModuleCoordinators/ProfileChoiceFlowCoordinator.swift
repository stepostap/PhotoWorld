//
//  ProfileChoiceFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 21.04.2023.
//

import UIKit
import SwiftUI

protocol ProfileChoiceFlowCoordinatorIO: ErrorPresenter {
    func profileTypeChosen(account: Account)
    func specializationsChosen(account: Account)
    func shortInfoFilled(account: Account)
    func servicesChosen(account: Account)
    func createProfile(account: Account) 
}

protocol ErrorPresenter {
    func showAlert(error: NetworkError)
}

class ProfileChoiceFlowCoordinator: ProfileChoiceFlowCoordinatorIO, FlowCoordinator {
    func finish() {
        
    }
    
    var navigationController: UINavigationController
    var finishHandler: (Account) -> Void
    let accountService: AccountService
    let imageService: ImagesService
    let userName: String
    
    func start() {
        let profileChoiceViewModel = ProfileChoiceViewModel(name: userName, output: self, accountService: accountService)
        let profileChoiceView = ProfileChoiceView(viewModel: profileChoiceViewModel).navigationBarBackButtonHidden(true)
        let hosting = UIHostingController(rootView: profileChoiceView)
        hosting.navigationItem.hidesBackButton = true
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func profileTypeChosen(account: Account) {
        let specChoiceVM = SpecializationChoiceViewModel(specializationsChosen: specializationsChosen,
                                                         accountService: accountService,
                                                         account: account, moduleOutput: self)
        let specChoiceView = SpecializationChoiceView(viewModel: specChoiceVM, progress: 0.2)
        let hosting = UIHostingController(rootView: specChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
        
    }
    
    func specializationsChosen(account: Account) {
        let shortInfoVM = ShortInfoViewModel(account: account, passInfo: shortInfoFilled)
        let shortInfoView = ShortInfoView(viewModel: shortInfoVM)
        let hosting = UIHostingController(rootView: shortInfoView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func shortInfoFilled(account: Account) {
        let serviceChoiceFlowCoordinator = ServicesFlowCoordinator(navigationController: navigationController, accountService: accountService, type: account.type, passChosenServices: { services in
            account.services = services
            self.servicesChosen(account: account)
        })
        serviceChoiceFlowCoordinator.start()
    }
    
    func servicesChosen(account: Account) {
        let imageLoader = ImageLoader(imageService: imageService, passImageURLs: { urls in
            account.allPhotos = urls
            self.photosChosen(account: account)
        })
        let photoChoiceView = PhotoChoiceView(mediaItems: imageLoader.pickedItems,
                                              sendData: imageLoader.uploadImages,
                                              progress: 0.75)
        let hosting = UIHostingController(rootView: photoChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    
    func photosChosen(account: Account) {
        let viewModel = AccountImageViewModel(account: account,
                                              moduleOutput: self,
                                              imageService: imageService,
                                              accountService: accountService)
        let photoChoiceView = AccountImageView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: photoChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: account.type.profileCreationtitle)
        navigationController.pushViewController(hosting, animated: true)
        
    }
    
    func createProfile(account: Account) {
        finishHandler(account)
    }
    
    internal init(
        username: String,
        navigationController: UINavigationController,
        accountService: AccountService,
        imageService: ImagesService,
        finishHandler: @escaping (Account)->Void) {
            self.navigationController = navigationController
            self.finishHandler = finishHandler
            self.accountService = accountService
            self.imageService = imageService
            self.userName = username
        }
}
