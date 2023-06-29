//
//  MainFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI
import UIKit
import SendbirdUIKit
import SendbirdChatSDK

class MainFlowCoordinator: FlowCoordinator {
    internal init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        resolver = Resolver()
    }
    
    private let resolver: Resolver
    var childCoordinators: [FlowCoordinator] = []
    private let window:  UIWindow
    var navigationController: UINavigationController
    
    func start() {
        let welcomeModuleFlowCoordinator = WelcomeModuleFlowCoordinator(navigationController: navigationController, resolver: resolver, finishHandler: logIn)
        childCoordinators.append(welcomeModuleFlowCoordinator)
        welcomeModuleFlowCoordinator.start()
    }
    
    func exit() {
        childCoordinators.removeAll()
        resolver.clear()
        navigationController.setViewControllers([], animated: true)
        let welcomeModuleFlowCoordinator = WelcomeModuleFlowCoordinator(navigationController: navigationController, resolver: resolver, finishHandler: logIn)
        childCoordinators.append(welcomeModuleFlowCoordinator)
        welcomeModuleFlowCoordinator.start()
        window.rootViewController = navigationController
    }
    
    func finish() {
    
    }
    
    func logIn(account: Account) {
        childCoordinators.removeAll()
        window.rootViewController = createTabBar(account: account)
    }
    
    func createAccountNC(account: Account) -> UINavigationController {
        let accountNavigation = UINavigationController()
        let networkFactory = resolver.resolve(type: NetworkServicesFactory.self) as! NetworkServicesFactory
        let userAccountCoordinator = UserAccountFlowCoordinator(navigationController: accountNavigation, accountService: networkFactory.getAccountService(), imagesService: networkFactory.getImagesService(), exit: exit)
        childCoordinators.append(userAccountCoordinator)
        userAccountCoordinator.start(account: account)
        return accountNavigation
    }
    
    func createPhotosessionNC() -> UINavigationController {
        let photosessionNavigation = UINavigationController()
        let networkFactory = resolver.resolve(type: NetworkServicesFactory.self) as! NetworkServicesFactory
        let photosessionCoordinator = PhotoSessionModuleFlowCoordinator(navigationController: photosessionNavigation,
                                                                        imageService: networkFactory.getImagesService(),
                                                                        photosessionService: networkFactory.getPhotosessionService(),
                                                                        accountService: networkFactory.getAccountService(),
                                                                        searchService: networkFactory.getSearchService())
        childCoordinators.append(photosessionCoordinator)
        photosessionCoordinator.start()
        return photosessionNavigation
    }
    
    func createMessangerNC() -> UINavigationController {
        SBUTheme.set(theme: Themes.mainTheme)
        let temp1 = asd()
        
        let navTemp1 = UINavigationController(rootViewController: temp1)
        temp1.tabBarItem = UITabBarItem(title: "Мессенджер", image: UIImage(named: "messanger"), tag: 3)
        return navTemp1
    }
    
    func createHomePageNC() -> UINavigationController {
        let homePageNavigation = UINavigationController()
        let networkFactory = resolver.resolve(type: NetworkServicesFactory.self) as! NetworkServicesFactory
        let coordinator = HomePageFlowCoordinator(accountService: networkFactory.getAccountService(),
                                                  searchService: networkFactory.getSearchService(),
                                                  navigationController: homePageNavigation)
        childCoordinators.append(coordinator)
        coordinator.start()
        return homePageNavigation
    }
    
    func createTabBar(account: Account) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [createAccountNC(account: account),
                                            createMessangerNC(),
                                            createHomePageNC(),
                                            createPhotosessionNC()]
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(ColorConstants.Bluegray800)
        appearance.selectionIndicatorTintColor = UIColor(ColorConstants.Blue800)
        appearance.shadowColor = UIColor(Color.gray)
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = UIColor(ColorConstants.Bluegray800)
        return tabBarController
    }
}
