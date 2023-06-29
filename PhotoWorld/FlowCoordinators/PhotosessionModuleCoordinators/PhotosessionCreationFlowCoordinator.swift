//
//  PhotosessionCreationFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import UIKit
import SwiftUI

protocol PhotosessionCreationIO: ErrorPresenter  {
    func passChosenTags(tags: [String])
    func shortInfoFilled(shortInfo: PhotosessionShortInfo)
    func photosChosen(urls: [URL])
    func photosessionCreated(id: String)
}

class PhotosessionCreationFlowCoordinator: PhotosessionCreationIO, FlowCoordinator {
   
    
    internal init(navigationController: UINavigationController,
                  imageService: ImagesService,
                  photosessionService: PhotosessionService,
                  accountService: AccountService,
                  passCreatedPhotosession: @escaping (String)->Void) {
        self.navigationController = navigationController
        self.imageService = imageService
        self.photosessionService = photosessionService
        self.accountService = accountService
        self.passCreatedPhotosession = passCreatedPhotosession
    }
    
    var navigationController: UINavigationController
    var passCreatedPhotosession: (String)->Void
    let imageService: ImagesService
    let photosessionService: PhotosessionService
    let accountService: AccountService
    
    var tags: [String]?
    var shortInfo: PhotosessionShortInfo?
    
    func start() {
        let viewModel = PhotosessionTagsViewModel(moduleOutput: self, photosessionService: photosessionService)
        let view = PhotosessionTagsView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Создание фотосессии")
        
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func photosessionCreated(id: String) {
        navigationController.popToRootViewController(animated: true)
        passCreatedPhotosession(id)
//        let viewModel = PhotosessionViewModel(moduleOutput: self, photosession: info)
//        let view = PhotosessionView(viewModel: viewModel)
//        let hosting = UIHostingController(rootView: view)
//        hosting.navigationItem.titleView = createTitleLabel(title: info.name)
//        navigationController.popToRootViewController(animated: true)
//
//        navigationController.tabBarController?.tabBar.isHidden = true
//        navigationController.pushViewController(hosting, animated: true)
    }
    
//    func finishPhotosession(id: String, participants: [ParticipantInfo]) {
//        let coordinator = PhotosessionFinishFlowCoordinator(navigationController: navigationController, imageService: imageService, photoService: photosessionService, accountService: accountService, photosessionID: id, participants: participants)
//        coordinator.start()
//    }
    
    func photosChosen(urls: [URL]) {
        if let tags = tags, let shortInfo = shortInfo {
            let viewModel = PhotosessionDateViewModel(tags: tags,
                                                      shortInfo: shortInfo,
                                                      urls: urls,
                                                      moduleOutput: self,
                                                      photosessionService: photosessionService)
            let view = PhotosessionDateView(viewModel: viewModel)
            let hosting = UIHostingController(rootView: view)
            hosting.navigationItem.titleView = createTitleLabel(title: "Создание фотосессии")
            navigationController.pushViewController(hosting, animated: true)
        }
    }
    
    func shortInfoFilled(shortInfo: PhotosessionShortInfo) {
        let imageLoader = ImageLoader(imageService: imageService, passImageURLs: { urls in
            self.photosChosen(urls: urls)
        })
        let photoChoiceView = PhotoChoiceView(mediaItems: imageLoader.pickedItems,
                                              sendData: imageLoader.uploadImages,
                                              progress: 0.75)
        self.shortInfo = shortInfo
        //let view = PhotoChoiceView(mediaItems: mediaItems, sendData: photosChosen, progress: 0.75)
        let hosting = UIHostingController(rootView: photoChoiceView)
        hosting.navigationItem.titleView = createTitleLabel(title: "Создание фотосессии")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func passChosenTags(tags: [String]) {
        self.tags = tags
        let view = PhotosessionInfoView(passInfo: shortInfoFilled)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Создание фотосессии")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func finish() {
        
    }
}
