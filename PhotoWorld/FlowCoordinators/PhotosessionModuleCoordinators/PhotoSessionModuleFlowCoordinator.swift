//
//  PhotoSessionModuleFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 02.05.2023.
//

import UIKit
import SwiftUI
import SendbirdUIKit

protocol PhotoSessionModuleFlowCoordintorIO: ErrorPresenter {
    func openPhotosessionCreation(passCreatedPhotosession: @escaping (String)->Void)
    func openPhotosession(info: PhotosessionFullInfo)
    func addParticipants(inviteParticipant: @escaping (SearchProfileInfo)->Void)
    func openChat(url: String)
    func hideTabBar()
    func showTabBar()
    func finishPhotosession(id: String, participants: [ParticipantInfo])
    func openImagesViewer(urls: [URL])
    func openAccount(account: Account)
}

class PhotoSessionModuleFlowCoordinator: PhotoSessionModuleFlowCoordintorIO,
                                         FlowCoordinator, SearchCoordinator {
    func openSearchFilter(filter: SearchFilter) {
        let hosting = UIHostingController(rootView: SearchFiltersView(searchFilter: filter,
                                                              saveFilter: { self.navigationController.popViewController(animated: true)
        }))
        hosting.navigationItem.titleView = createTitleLabel(title: "Фильтр")
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(hosting, animated: true)
    }
    
    internal init(navigationController: UINavigationController,
                  imageService: ImagesService,
                  photosessionService: PhotosessionService,
                  accountService: AccountService,
                  searchService: SearchService) {
        self.navigationController = navigationController
        self.imageService = imageService
        self.photosessionService = photosessionService
        self.accountService = accountService
        self.searchService = searchService
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [FlowCoordinator] = []
    var imageService: ImagesService
    var photosessionService: PhotosessionService
    var accountService: AccountService
    var searchService: SearchService
    var changePhotosessionFinishTag: ((String)->Void)?
    
    
    func start() {
        let photosessionViewModel = PhotosessionListViewModel(output: self, photoService: photosessionService)
        changePhotosessionFinishTag = photosessionViewModel.finishPhotosession
        let photosessionHosting = UIHostingController(rootView: PhotoSessionListView(viewModel: photosessionViewModel))
        navigationController.setViewControllers([photosessionHosting], animated: false)
        photosessionHosting.tabBarItem = UITabBarItem(title: "Фотосессии", image: UIImage(named: "photosession"), tag: 2)
    }
    
    func hideTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.navigationBar.isHidden = false
    }
    
    func showTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.navigationBar.isHidden = true
    }
    
    func finish() {
        
    }
    
    func openPhotosessionCreation(passCreatedPhotosession: @escaping (String)->Void) {
        hideTabBar()
        let coordinator = PhotosessionCreationFlowCoordinator(navigationController: navigationController,
                                                              imageService: imageService,
                                                              photosessionService: photosessionService,
                                                              accountService: accountService,
                                                              passCreatedPhotosession: passCreatedPhotosession)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func openPhotosession(info: PhotosessionFullInfo) {
        let viewModel = PhotosessionViewModel(moduleOutput: self, accountService: accountService,
                                              photosessionService: photosessionService, photosession: info)
        let view = PhotosessionView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: info.name)
        hideTabBar()
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func finishPhotosession(id: String, participants: [ParticipantInfo]) {
        navigationController.navigationBar.isHidden = false
        changePhotosessionFinishTag!(id)
        let coordinator = PhotosessionFinishFlowCoordinator(navigationController: navigationController,
                                                            imageService: imageService,
                                                            photoService: photosessionService,
                                                            accountService: accountService,
                                                            photosessionID: id, participants: participants)
        coordinator.start()
    }
    
    func addParticipants(inviteParticipant: @escaping (SearchProfileInfo)->Void ) {
        let searchViewModel = HomePageViewModel(output: self,
                                                accountService: accountService,
                                                searchService: searchService)
        searchViewModel.searchCellButtonInfo = SearchCellButtonInfo(title: "Пригласить", buttonAction: inviteParticipant)
        let view = HomePageView(viewModel: searchViewModel)
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: "Поиск")
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func openAccount(account: Account) {
        let view = OtherAccountView(account: account, openChat: {})
        let hosting = UIHostingController(rootView: view)
        hosting.navigationItem.titleView = createTitleLabel(title: account.name)
        navigationController.pushViewController(hosting, animated: true)
    }
    
    func openChat(url: String) {
        //hideTabBar()
        navigationController.navigationBar.isHidden = false
        navigationController.tabBarController?.tabBar.isHidden = false
        let vc = SBUGroupChannelViewController(channelURL: url)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openImagesViewer(urls: [URL]) {
        
        let view = ImagesViewer(imageURLS: urls)
        let hosting = UIHostingController(rootView: view)
        navigationController.pushViewController(hosting, animated: true)
    }
}
