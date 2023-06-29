//
//  PhotosessionTagsViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import Foundation
import Combine

protocol PhotosessionTagsViewModelIO: ObservableObject {
    var sessionTags: [(tag: String, present: Bool)] {get set}
    var tagsChosen: Bool {get}
    func passChosenSpecs()
}

class PhotosessionTagsViewModel<coordinator: PhotosessionCreationIO>: ViewModelProtocol, PhotosessionTagsViewModelIO {
    internal init(moduleOutput: coordinator, photosessionService: PhotosessionService) {
        self.moduleOutput = moduleOutput
        self.photosessionService = photosessionService
        
        cancellable = photosessionService.getTagsPublisher().sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            }
            do {
                let tags = try JSONDecoder().decode(Tags.self, from: response.data)
                
                let tempTags = ["Портретная съемка", "Модельные тесты", "Ню съемка", "Семейная съемка",
                                "Репортажная съемка", "Выездная фотосессия", "Студийная съемка", "Съемка в городе",
                                "Съемка на улице", "Предметная съемка", "Интерьерная съемка", "Съемка еды", "Ночная фотосессия"]
                
                for tag in tempTags {
                    self.sessionTags.append((tag, false))
                }
            } catch {
                self.moduleOutput.showAlert(error: .decodingError)
            }
        })
    }

    
    
    @Published var sessionTags: [(tag: String, present: Bool)] = []
    internal let moduleOutput: coordinator
    private let photosessionService: PhotosessionService
    var cancellable: AnyCancellable?
    
    var tagsChosen: Bool {
        for temp in sessionTags {
            if temp.present {
                return true
            }
        }
        return false
    }
    
    func passChosenSpecs() {
        var tags: [String] = []
        for temp in sessionTags {
            if temp.present {
                tags.append(temp.tag)
            }
        }
        moduleOutput.passChosenTags(tags: tags)
    }
}
