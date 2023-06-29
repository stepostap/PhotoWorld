//
//  AlbumCreationViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 10.05.2023.
//

import Foundation
import Combine

class AlbumcreationViewModel<coordinator: AlbumCreationFlowCoordinatorIO>: ViewModelProtocol {
    typealias errorPresenter = coordinator
    
    internal init(account: Account,
                  accountService: AccountService,
                  imageService: ImagesService,
                  info: (name: String, visibility: AlbumVisibility),
                  moduleOutput: coordinator) {
        self.account = account
        self.accountService = accountService
        self.imageService = imageService
        self.info = info
        self.moduleOutput = moduleOutput
    }
    
    let moduleOutput: coordinator
    let account: Account
    let accountService: AccountService
    let imageService: ImagesService
    let info: (name: String, visibility: AlbumVisibility)
    var cancellable: AnyCancellable?
    var imageLoader: ImageLoader {
        return ImageLoader(imageService: imageService, passImageURLs: createAlbum)
    }
    
    func createAlbum(urls: [URL]) {
        if let first = urls.first {
            let album = Album(name: info.name, imageURLs: urls,
                              firstImageURL: first, imagesCount: urls.count,
                              visibility: info.visibility)
            
            cancellable = accountService.getCreateAlbumPublsiher(forType: account.type, album: album)
                .sink(receiveCompletion: { res in
                    self.checkComplition(res: res, completion: {
                        if let _ = self.account.albums {
                            self.account.albums?.append(album)
                        } else {
                            self.account.albums = [album]
                        }
                        self.moduleOutput.photosChosen()
                    })
                }, receiveValue: { respose in
                    if respose.statusCode > 299 {
                        self.showResponseError(response: respose)
                    }
                })
        }
    }
}
