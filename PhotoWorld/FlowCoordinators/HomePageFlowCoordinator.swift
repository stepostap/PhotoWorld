//
//  HomePageFlowCoordinator.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 02.05.2023.
//

import Foundation
import UIKit
import SwiftUI
import SendbirdUIKit

protocol SearchCoordinator: ErrorPresenter {
    func openSearchFilter(filter: SearchFilter)
    func openChat(url: String)
    func openAccount(account: Account) 
    func showTabBar()
}

class SmallTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: 1)
        return newSize
    }
}

class HomePageFlowCoordinator: SearchCoordinator, FlowCoordinator {
    internal init(accountService: AccountService, searchService: SearchService, navigationController: UINavigationController) {
        self.accountService = accountService
        self.searchService = searchService
        self.navigationController = navigationController
    }
    
    func finish() {
        
    }
    
    var childCoordinators: [FlowCoordinator] = []
    var accountService: AccountService
    var searchService: SearchService
    var navigationController: UINavigationController
    
    func openSearchFilter(filter: SearchFilter) {
        let hosting = UIHostingController(rootView: SearchFiltersView(searchFilter: filter, saveFilter: saveFilter))
        hosting.navigationItem.titleView = createTitleLabel(title: "Фильтр")
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(hosting, animated: true)
    }
   
    func showTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = false
    }
    
    func saveFilter() {
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.popViewController(animated: true)
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
    
    func start() {
        let viewModel = HomePageViewModel(output: self,
                                          accountService: accountService,
                                          searchService: searchService)
        viewModel.searchCellButtonInfo =  SearchCellButtonInfo(title: "Написать", buttonAction: {profile in viewModel.openChat(info: profile)})
        let homepageHosting = UIHostingController(rootView:
                    HomePageView(viewModel: viewModel))
        homepageHosting.navigationItem.titleView = createTitleLabel(title: "Поиск")
        navigationController.setViewControllers([homepageHosting], animated: false)
        navigationController.navigationBar.backgroundColor = .clear
        homepageHosting.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "homepage"), tag: 1)
    }
}
