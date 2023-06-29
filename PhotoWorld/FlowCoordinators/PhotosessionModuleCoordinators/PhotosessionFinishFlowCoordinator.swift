//
//  PhotosessionFinishFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation
import UIKit
import SwiftUI
import Combine

protocol PhotosessionFinishFlowCoordinatorIO: ErrorPresenter {
    func openParticipantsCommentsView()
    func commentCreated() 
}

class PhotosessionFinishFlowCoordinator: PhotosessionFinishFlowCoordinatorIO, FlowCoordinator {
    internal init(navigationController: UINavigationController,
                  imageService: ImagesService,
                  photoService: PhotosessionService,
                  accountService: AccountService,
                  photosessionID: String,
                  participants: [ParticipantInfo]) {
        self.navigationController = navigationController
        self.imageService = imageService
        self.photoService = photoService
        self.accountService = accountService
        self.photosessionID = photosessionID
        self.participants = participants
    }
    
    var navigationController: UINavigationController
    var imageService: ImagesService
    var photoService: PhotosessionService
    let accountService: AccountService
    let photosessionID: String
    let participants: [ParticipantInfo]
    var cancellable: AnyCancellable?
    
    
    func start() {
        let viewModel = FinalImagesViewModel(moduleOutput: self,
                                                        photosessionID: photosessionID,
                                                        photosessionService: photoService,
                                                        imagesService: imageService)
        let view = FinalImagesView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Завершение")
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func openParticipantsCommentsView() {
        let view = ParticipantsCommentView(participants: participants,
                                           openParticipantComment: openParticipantComment,
                                           finish: finishPhotosession)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Завершение")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func openParticipantComment(participant: ParticipantInfo) {
        let viewModel = CreateCommentViewModel(moduleOutput: self,
                                               imageService: imageService,
                                               photoService: photoService,
                                               profile: participant,
                                               accountService: accountService)
        let createCommentView = CreateCommentView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: createCommentView)
        hosting.navigationItem.titleView = createTitleLabel(title: "Завершение")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func commentCreated() {
        navigationController.popViewController(animated: true)
    }
    
    func finishPhotosession() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func finish() {
        
    }
}
