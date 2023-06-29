//
//  NetworkServicesFactory.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation

class NetworkServicesFactory {
    internal init(token: String) {
        self.token = token
    }
    
    private let token: String
    
    func getAccountService() -> AccountService {
        return AccountService(token: token)
    }
    
    func getImagesService() -> ImagesService {
        return ImagesService(token: token)
    }
    
    func getSearchService() -> SearchService {
        return SearchService(token: token)
    }
    
    func getPhotosessionService() -> PhotosessionService {
        return PhotosessionService(token: token)
    }
}

