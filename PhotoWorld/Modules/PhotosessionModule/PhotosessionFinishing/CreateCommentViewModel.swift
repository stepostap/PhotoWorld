//
//  CreateCommentViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation
import Combine
import Moya

protocol CreateCommentViewModelIO: ObservableObject {
    var profile: ParticipantInfo {get}
    var chosenRating: Int {get set}
    var comment: String {get set}
    var anonymus: Bool {get set}
    var imageLoader: ImageLoader {get}
    var loadingPhotos: Bool {get set}
    func createComment()
}

class CreateCommentViewModel<coordinator: PhotosessionFinishFlowCoordinatorIO>: ViewModelProtocol, CreateCommentViewModelIO {
    internal init(moduleOutput: coordinator,
                  imageService: ImagesService,
                  photoService: PhotosessionService,
                  profile: ParticipantInfo,
                  accountService: AccountService) {
        self.moduleOutput = moduleOutput
        self.imageService = imageService
        self.photoService = photoService
        self.accountService = accountService
        self.profile = profile
    }
    
    let moduleOutput: coordinator
    let imageService: ImagesService
    let photoService: PhotosessionService
    let accountService: AccountService
    let profile: ParticipantInfo
    lazy var imageLoader: ImageLoader = ImageLoader(imageService: imageService, passImageURLs: urlsLoaded)
    var cancellable: AnyCancellable?
    
    @Published var chosenRating = 0
    @Published var comment = ""
    @Published var anonymus = false
    @Published var loadingPhotos = false
    var urls: [URL] = []
    
    func urlsLoaded(urls: [URL]) {
        self.urls.append(contentsOf: urls)
        loadingPhotos = false
    }
    
    func createComment() {
        let comment = CommentCretionInfo(text: comment, grade: chosenRating,
                                         is_anonymous: anonymus, photos: urls,
                                         writer_profile_type: ProfileType.currentUserType!)
        cancellable = accountService.createCommentPublisher(comment: comment,
                                                            receiverEmail: profile.email,
                                                            receiverType: profile.profile_type)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    self.moduleOutput.commentCreated()
                }
            })
    }
}


