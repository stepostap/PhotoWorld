//
//  PhotosessionDateViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.05.2023.
//

import Foundation
import SwiftUICalendar
import Combine
import Moya
import CloudKit

protocol PhotosessionDateViewModelIO: ObservableObject {
    var chosenDate: YearMonthDay {get set}
    var time: String {get set}
    var duration: Double? {get set}
    
    func infoFilled() -> Bool
    func createPhotosession()
}

class PhotosessionDateViewModel<coordinator: PhotosessionCreationIO>: ViewModelProtocol, PhotosessionDateViewModelIO {
    internal init(tags: [String],
                  shortInfo: PhotosessionShortInfo,
                  urls: [URL],
                  moduleOutput: coordinator,
                  photosessionService: PhotosessionService) {
        self.tags = tags
        self.shortInfo = shortInfo
        self.urls = urls
        self.moduleOutput = moduleOutput
        self.photosessionService = photosessionService
    }
    
    typealias errorPresenter = coordinator
    
    var tags: [String]
    var shortInfo: PhotosessionShortInfo
    var urls: [URL]
    
    var moduleOutput: coordinator
    let photosessionService: PhotosessionService
    var bag: [AnyCancellable] = []
    
    @Published var chosenDate = YearMonthDay.current
    @Published var time = ""
    @Published var duration: Double?
    
    func formatDate() -> Int64 {
        var dateComponents = DateComponents()
        dateComponents.year = chosenDate.year
        dateComponents.month = chosenDate.month
        dateComponents.day = chosenDate.day
        let split = time.split(separator: ":")
        dateComponents.hour = Int.init(split[0])!
        dateComponents.minute = Int.init(split[1])!
        let userCalendar = Calendar(identifier: .gregorian)
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime!.millisecondsSince1970
    }
    
    func createPhotosession() {
        guard let type = ProfileType.currentUserType else { return }
        
        let info = PhotosessionCreationInfo(profileType: type.rawValue,
                                            photosession_name: shortInfo.name,
                                            description: shortInfo.description,
                                            duration: duration!, address: shortInfo.location,
                                            start_date_and_time: formatDate(), photos: urls, tags: tags)
        
        photosessionService.createPhotosessionPublisher(photosession: info).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let id = try JSONDecoder().decode(PhotosessionID.self, from: response.data)
                    self.moduleOutput.photosessionCreated(id: id.photosessionId)
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
        
    func infoFilled() -> Bool {
        return !(time.isEmpty || duration == nil)
    }
}
