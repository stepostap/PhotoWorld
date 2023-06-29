//
//  FinaImagesViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation
import Moya
import Combine
import Kingfisher
import SwiftUI

protocol FinalImagesViewModelIO: ObservableObject {
    var urls: [URL] { get }
    var imageLoader: ImageLoader { get }
    var photoPicker: PhotoPicker { get }
    var showSheet: Bool { get set }
    var refresh: Bool {get}
//    var imageViews: [any View] { get }
    func goToCommentView()
}

class FinalImagesViewModel<coordinator: PhotosessionFinishFlowCoordinatorIO>: ViewModelProtocol, FinalImagesViewModelIO {
    internal init(moduleOutput: coordinator,
                  photosessionID: String,
                  photosessionService: PhotosessionService,
                  imagesService: ImagesService) {
        self.moduleOutput = moduleOutput
        self.photosessionService = photosessionService
        self.imagesService = imagesService
        self.photosessionID = photosessionID
        //sinkWithPicker()
        loadResultPhotos()
    }
    
    let moduleOutput: coordinator
    let photosessionService: PhotosessionService
    let imagesService: ImagesService
    lazy var imageLoader: ImageLoader = ImageLoader(imageService: imagesService, passImageURLs: self.photosLoaded)
    lazy var photoPicker = PhotoPicker(mediaItems: imageLoader.pickedItems,
                                       didFinishPicking: {_ in self.showSheet = false },
                                       didLoadChosenItems: { self.imageLoader.uploadImages() })
    @Published var urls: [URL] = []
    @Published var refresh = false
    @Published var showSheet = false
    let photosessionID: String
    var bag: [AnyCancellable] = []
        
    func loadResultPhotos() {
        refresh.toggle()
        photosessionService.getResultPhotosPublisher(id: photosessionID).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let photos = try JSONDecoder().decode(PhotosessionPhotos.self, from: response.data)
                    self.urls.append(contentsOf: photos.photos)
                    self.refresh.toggle()
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    func photosLoaded(urls: [URL]) {
        self.urls.append(contentsOf: urls)
        photosessionService.addResultsPhotosPublisher(id: photosessionID, photos: urls)
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
    
    func goToCommentView() {
        self.moduleOutput.openParticipantsCommentsView()
    }
}
