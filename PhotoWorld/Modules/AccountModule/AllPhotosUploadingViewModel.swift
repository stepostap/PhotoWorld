//
//  AllPhotosUploadingViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 10.05.2023.
//

import Foundation
import Combine

class AllPhotosUploadingViewModel<coordinator: UserAccountFlowCoordinatorIO>: ViewModelProtocol {
    typealias errorPresenter = coordinator
    
    internal init(account: Account,
                  accountService: AccountService,
                  imageService: ImagesService,
                  moduleOutput: coordinator) {
        self.account = account
        self.accountService = accountService
        self.imageService = imageService
        self.moduleOutput = moduleOutput
    }
    
    let moduleOutput: coordinator
    let account: Account
    let accountService: AccountService
    let imageService: ImagesService
    var cancellable: AnyCancellable?
    var imageLoader: ImageLoader {
        return ImageLoader(imageService: imageService, passImageURLs: createAlbum)
    }
    
    func createAlbum(urls: [URL]) {
       
        account.allPhotos?.append(contentsOf: urls)
        moduleOutput.newPhotosAdded()
//            cancellable = accountService.getCreateAlbumPublsiher(forType: account.type, album: album)
//                .sink(receiveCompletion: { res in
//                    self.checkComplition(res: res, completion: {
//                        if let _ = self.account.albums {
//                            self.account.albums?.append(album)
//                        } else {
//                            self.account.albums = [album]
//                        }
//                    })
//                }, receiveValue: { respose in
//                    if respose.statusCode > 299 {
//                        self.showResponseError(response: respose)
//                    }
//                })
        
    }
}

