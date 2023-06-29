//
//  UserAccountViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI
import Combine

protocol UserAccountViewModelIO: ObservableObject {
    func openAlbumCreation()
    func openAddPhotos()
    func openEditing()
    func showTabbar()
    func openAlbum(name: String)
    var account: Account {get set}
}

class UserAccountViewModel<coordinator: UserAccountFlowCoordinatorIO>: ViewModelProtocol, UserAccountViewModelIO {
    typealias errorPresenter = coordinator
    
    internal init(account: Account, output: coordinator) {
        self.account = account
        self.moduleOutput = output
    }
    
    let moduleOutput: coordinator
    @Published var account: Account
    @Published var refresh = false
    var cancellable: AnyCancellable?
    
    func openAlbumCreation() {
        cancellable = account.$albums.sink(receiveValue: { _  in
            self.refresh.toggle()
        })
        
        moduleOutput.openAlbumCreaton(account: account)
    }
    
    func openAddPhotos() {
        moduleOutput.openAddAllPhotos(account: account)
    }
    
    func openEditing() {
        moduleOutput.openEditing(account: account)
    }
    
    func showTabbar() {
        moduleOutput.showTabBar()
    }
    
    func openAlbum(name: String) {
        moduleOutput.openAlbum(albumName: name)
    }
}
