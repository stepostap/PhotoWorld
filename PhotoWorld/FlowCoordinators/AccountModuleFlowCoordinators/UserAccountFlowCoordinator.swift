//
//  UserAccountFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 23.04.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol UserAccountFlowCoordinatorIO: ErrorPresenter {
    func openAlbumCreaton(account: Account)
    func openAddAllPhotos(account: Account)
    func openAlbum(albumName: String)
    func newPhotosAdded()
    func openEditing(account: Account)
    func openImagesViewer(urls: [URL])
    func hideTabBar()
    func showTabBar() 
}

class UserAccountFlowCoordinator: UserAccountFlowCoordinatorIO, FlowCoordinator {
    
    internal init(navigationController: UINavigationController,
                  accountService: AccountService,
                  imagesService: ImagesService,
                  exit: @escaping ()->Void) {
        self.navigationController = navigationController
        self.accountService = accountService
        self.imageService = imagesService
        self.exit = exit
    }
    
    var childCoordinators: [FlowCoordinator] = []
    var accountService: AccountService
    var imageService: ImagesService
    var navigationController: UINavigationController
    var exit: ()->Void
    
    func openAlbumCreaton(account: Account) {
        hideTabBar()
        let coordinator = AlbumCreationFlowCoordinator(navigationController: navigationController, imageService: imageService, accountService: accountService, account: account)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func openAddAllPhotos(account: Account) {
        hideTabBar()
        let viewModel = AllPhotosUploadingViewModel(account: account,
                                                    accountService: accountService,
                                                    imageService: imageService,
                                                    moduleOutput: self)
        let imageLoader = viewModel.imageLoader
        let view = PhotoChoiceView(mediaItems: imageLoader.pickedItems,
                                   sendData: imageLoader.uploadImages, progress: 1)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Добавить фотографии")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func openEditing(account: Account) {
        hideTabBar()
        let coordinator = AccountEditingFlowCoordinator(navigationController: navigationController,
                                                        imageService: imageService,
                                                        accountService: accountService,
                                                        account: account, exit: exit)
        coordinator.start()
    }
    
    func openImagesViewer(urls: [URL]) {
        
        let view = ImagesViewer(imageURLS: urls)
        let hosting = UIHostingController(rootView: view)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func newPhotosAdded() {
        navigationController.popViewController(animated: true)
    }
    
    func finish() {
        
    }
    
    func hideTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = false
    }
    
    func openAlbum(albumName: String) {
        hideTabBar()
        let viewModel = ViewAlbumViewModel(moduleOutput: self, accountService: accountService, imagesService: imageService, albumName: albumName)
        let view = ViewAlbumView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: albumName)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func start(account: Account) {
        let userAccountHosting = UIHostingController(rootView: UserAccountView(viewModel: UserAccountViewModel(account: account, output: self)))
        // let userAccountHosting = UIHostingController(rootView: OtherAccountView(account: account))
        navigationController.setViewControllers([userAccountHosting], animated: false)
        userAccountHosting.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "account"), tag: 4)
    }
    
    func start() {}
}
