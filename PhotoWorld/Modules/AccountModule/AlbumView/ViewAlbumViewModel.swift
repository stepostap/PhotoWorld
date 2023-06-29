//
//  ViewAlbumViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 27.05.2023.
//

import Foundation
import Moya
import Combine

protocol ViewAlbumViewModelIO: ObservableObject {
    var urls: [URL] { get }
    var imageLoader: ImageLoader { get }
    var photoPicker: PhotoPicker { get }
    var refresh: Bool {get}
    var showSheet: Bool { get set }
    func openPhotoView() 
}

class ViewAlbumViewModel<coordinator: UserAccountFlowCoordinatorIO>: ViewModelProtocol, ViewAlbumViewModelIO {
    internal init(moduleOutput: coordinator,
                  accountService: AccountService,
                  imagesService: ImagesService,
                  albumName: String) {
        self.moduleOutput = moduleOutput
        self.accountService = accountService
        self.imagesService = imagesService
        self.albumName = albumName
        loadResultPhotos()
    }
    
    let moduleOutput: coordinator
    let accountService: AccountService
    let imagesService: ImagesService
    let albumName: String
    lazy var imageLoader: ImageLoader = ImageLoader(imageService: imagesService, passImageURLs: self.photosLoaded)
    lazy var photoPicker = PhotoPicker(mediaItems: imageLoader.pickedItems,
                                       didFinishPicking: {_ in self.showSheet = false },
                                       didLoadChosenItems: { self.imageLoader.uploadImages() })
    @Published var urls: [URL] = []
    @Published var refresh = false
    @Published var showSheet = false
    var bag: [AnyCancellable] = []
        
    func loadResultPhotos() {
        refresh.toggle()
        accountService.getAlbumPhotosPublisher(albumName: albumName, type: ProfileType.currentUserType!).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let photos = try JSONDecoder().decode(AlbumAllPhotos.self, from: response.data)
                    self.urls.append(contentsOf: photos.all_photos)
                    self.refresh.toggle()
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    func photosLoaded(urls: [URL]) {
        self.urls.append(contentsOf: urls)
        accountService.uploadPhotosToAlbum(photos: urls, albumName: albumName, type: ProfileType.currentUserType!)
            .sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                
                self.refresh.toggle()
            }
        }).store(in: &bag)
    }
    
    func openPhotoView() {
        moduleOutput.openImagesViewer(urls: urls)
    }
}
