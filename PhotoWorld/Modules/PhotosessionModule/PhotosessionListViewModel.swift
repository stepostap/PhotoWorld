//
//  PhotosessionListViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 02.05.2023.
//

import Foundation
import Combine

protocol PhotosessionListViewModelIO: ObservableObject {
    func showTabBar()
    func openPhotosessionCreation()
    var shownPhotosessions: [PhotosessionListItem] { get }
    var photosessionList: [PhotosessionListItem] { get }
    var searchQueue: String { get set }
    var photoSessionTypeSelection: Int {get set}
    var refresh: Bool {get}
    func openChat(url: String)
    func openPhotosession(id: String)
    func acceptInvite(id: String)
    func declineInvite(id: String)
}

class PhotosessionListViewModel<coordinator: PhotoSessionModuleFlowCoordintorIO>: ViewModelProtocol, PhotosessionListViewModelIO {
    
    internal init(output: coordinator, photoService: PhotosessionService) {
        self.moduleOutput = output
        self.photoService = photoService
        self.loadPhotosessions()
    }
    
    let moduleOutput: coordinator
    let photoService: PhotosessionService
    var photosessionList: [PhotosessionListItem] = []
    
    var shownPhotosessions: [PhotosessionListItem] {
        if photoSessionTypeSelection == 0 {
            return filterPhotosession(status: nil)
        }
        if photoSessionTypeSelection == 1 {
            return filterPhotosession(status: .ready)
        }
        if photoSessionTypeSelection == 2 {
            return filterPhotosession(status: .refusal)
        }
        else {
            return filterPhotosession(status: .expectation)
        }
    }
    
    @Published var searchQueue: String = ""
    @Published var photoSessionTypeSelection = 0
    @Published var refresh = false
    var bag: [AnyCancellable] = []
    
    func finishPhotosession(id: String) {
        if let index = photosessionList.firstIndex(where: {item in item.id.elementsEqual(id)}) {
            photosessionList[index].photosessionStatus = .refusal
            refresh.toggle()
        }
    }
    
    func filterPhotosession(status: PhotosessionStatus?) -> [PhotosessionListItem]  {
        if let status = status {
            if !searchQueue.isEmpty {
                return photosessionList.filter({ item in item.photosessionStatus == status && item.name.contains(searchQueue)})
            } else {
                return photosessionList.filter({ item in item.photosessionStatus == status })
            }
        } else {
            if !searchQueue.isEmpty {
                return photosessionList.filter({ item in item.name.contains(searchQueue)})
            } else {
                return photosessionList
            }
        }
        
    }
    
    func loadPhotosessions() {
        photoService.getAllPhotosessionsPublisher().sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let photosessions = try JSONDecoder().decode(AllPhotosessionsUserInfo.self, from: response.data)
                    self.photosessionList = photosessions.photosessions
                } catch {
                    print(error)
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    func openPhotosessionCreation() {
        moduleOutput.openPhotosessionCreation(passCreatedPhotosession: openPhotosession)
    }
    
    func openPhotosession(id: String) {
        photoService.getPhotosesionPublisher(id: id).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let info = try JSONDecoder().decode(PhotosessionFullInfo.self, from: response.data)
                    if self.photosessionList.contains(where: {item in item.id.elementsEqual(id) && item.photosessionStatus == .refusal}) {
                        self.moduleOutput.finishPhotosession(id: id, participants: info.participants ?? [])
                    } else {
                        self.addPhotosession(info: info)
                        self.moduleOutput.openPhotosession(info: info)
                    }
                } catch {
                    print(error)
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    func addPhotosession(info: PhotosessionFullInfo) {
        if !photosessionList.contains(where: { item in item.id.elementsEqual(info.id)}) {
            self.photosessionList.append( (PhotosessionListItem(id: info.id, name: info.name,
                                                                address: info.address,
                                                                start_time: info.start_date_and_time,
                                                                end_time: info.end_date_and_time,
                                                                participants_avatars: [],
                                                                photosessionStatus: .ready,
                                                                chat_url: info.chat_url)))
        }
    }
    
    func acceptInvite(id: String) {
        photoService.acceptInvite(photosesionId: id, type: ProfileType.currentUserType!)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { [self] response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    let index = photosessionList.firstIndex(where: {item in item.id == id})
                    photosessionList[index!].photosessionStatus = .ready
                    refresh.toggle()
                }
            }).store(in: &bag)
    }
    
    func declineInvite(id: String) {
        
        photoService.declineInvite(photosesionId: id, type: ProfileType.currentUserType!)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { [self] response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    let index = photosessionList.firstIndex(where: {item in item.id == id})
                    photosessionList.remove(at: index!)
                    refresh.toggle()
                }
            }).store(in: &bag)
    }
    
    func showTabBar() {
        moduleOutput.showTabBar()
    }
    
    func openChat(url: String) {
        moduleOutput.openChat(url: url)
    }
}
