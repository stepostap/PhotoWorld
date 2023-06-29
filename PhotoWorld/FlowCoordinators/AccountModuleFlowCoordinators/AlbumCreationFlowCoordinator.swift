//
//  AlbumCreationFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import UIKit
import SwiftUI

protocol AlbumCreationFlowCoordinatorIO: ErrorPresenter {
    func photosChosen()
    func albumCreated(info: (name: String, visibility: AlbumVisibility))
}

class AlbumCreationFlowCoordinator: FlowCoordinator, AlbumCreationFlowCoordinatorIO {
    internal init(navigationController: UINavigationController,
                  imageService: ImagesService,
                  accountService: AccountService,
                  account: Account) {
        self.navigationController = navigationController
        self.imageService = imageService
        self.accountService = accountService
        self.account = account
    }
    
    var navigationController: UINavigationController
    let imageService: ImagesService
    let accountService: AccountService
    let account: Account
//    var name: String?
//    var visibility: AlbumVisibility?
//    var mediaItems: PickedMediaItems = PickedMediaItems()
    
    func albumCreated(info: (name: String, visibility: AlbumVisibility)) {
        let viewModel = AlbumcreationViewModel(account: account,
                                               accountService: accountService,
                                               imageService: imageService,
                                               info: info, moduleOutput: self)
        let imageLoader = viewModel.imageLoader
        let view = PhotoChoiceView(mediaItems: imageLoader.pickedItems,
                                   sendData: imageLoader.uploadImages, progress: 1)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Добавить альбом")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func start() {
        let view = AddAlbumView(passInfo: albumCreated)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Добавить альбом")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func photosChosen() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func finish() {
        
    }
}
