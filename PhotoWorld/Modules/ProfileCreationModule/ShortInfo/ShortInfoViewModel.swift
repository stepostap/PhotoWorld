//
//  ShortInfoViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 23.04.2023.
//

import Foundation

protocol ShortInfoViewModelIO: ObservableObject {
    var shortInfo: ProfileShortInfo {get set}
    func passShortInfo()
    func infoEmpty() ->  Bool
}

class ShortInfoViewModel: ShortInfoViewModelIO {
    
    @Published var shortInfo = ProfileShortInfo(about: "", experience: nil, additionalInfo: "")
    private let account: Account
    private let passInfo: (Account)->Void
    
    public init(account: Account,
                passInfo: @escaping (Account)->Void,
                shortInfo: ProfileShortInfo = ProfileShortInfo(about: "", experience: nil, additionalInfo: "")) {
        self.account = account
        self.passInfo = passInfo
        self.shortInfo = shortInfo
    }
    
    func passShortInfo() {
        account.profileInfo = shortInfo
        passInfo(account)
    }
    
    func infoEmpty() ->  Bool {
        return shortInfo.about.isEmpty && shortInfo.experience == nil && shortInfo.additionalInfo.isEmpty
    }
}
