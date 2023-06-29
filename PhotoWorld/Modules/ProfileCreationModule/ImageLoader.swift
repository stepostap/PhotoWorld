//
//  ImageLoader.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 08.05.2023.
//

import Foundation
import Combine
import Moya

class ImageLoader {
    internal init(imageService: ImagesService, passImageURLs: @escaping ([URL]) -> Void) {
        self.imageService = imageService
        self.passImageURLs = passImageURLs
    }
    
    var imageService: ImagesService
    var pickedItems = PickedMediaItems()
    var passImageURLs: ([URL])->Void
    var urls: [URL] = []
    var bag: [AnyCancellable] = []
    var publishers: [AnyPublisher<Response, MoyaError>] = []
    var sentItems = PickedMediaItems()
    
    func uploadImages() {
        urls.removeAll()
        publishers.removeAll()
        
        for item in pickedItems.items {
            if let photo = item.photo, !sentItems.items.contains(where: {temp in temp.id.elementsEqual(item.id)}) {
                publishers.append(imageService.getUploadImagePublisher(image: photo))
                sentItems.append(item: item)
            }
        }
        
        publishers.publisher.flatMap({$0}).collect().sink(receiveCompletion: { res in
//            switch res {
//            case .failure(_): break
//            case .finished:
//                self.passImageURLs(self.urls)
//            }
        }, receiveValue: { responces in
            print(responces)
            for responce in responces {
                if responce.statusCode < 300 {
                    do {
                        let url = try JSONDecoder().decode(DownloadImageURL.self, from: responce.data)
                        self.urls.append(url.imageUrl)
                    } catch { }
                } else {
                    do {
                        let error = try JSONDecoder().decode(ServerError.self, from: responce.data)
                        print(error)
                    } catch {}
                }
            }
            print(self.publishers.count)
            self.passImageURLs(self.urls)
        }).store(in: &bag)
    }
}
