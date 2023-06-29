//
//  PhotoPicker.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import SwiftUI
import PhotosUI
import Combine

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @ObservedObject var mediaItems: PickedMediaItems
    var selectionLimit = 0
    var didFinishPicking: (_ didSelectItems: Bool) -> Void
    var didLoadChosenItems: (()->Void)?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos, .livePhotos])
        config.selectionLimit = selectionLimit
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        var photoPicker: PhotoPicker
        let group = DispatchGroup()
        var checker = true
        
        init(with photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            photoPicker.didFinishPicking(!results.isEmpty)
        
            guard !results.isEmpty else {
                return
            }
            
            for result in results {
                let itemProvider = result.itemProvider
                
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                      let utType = UTType(typeIdentifier)
                else { continue }
                
                if utType.conforms(to: .image) {
                    self.getPhoto(from: itemProvider, isLivePhoto: false)
                }
            }
            
        }
        
        
        private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool) {
            let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
            
            
            if itemProvider.canLoadObject(ofClass: objectType) {
                itemProvider.loadObject(ofClass: objectType) { object, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if let image = object as? UIImage {
//                        DispatchQueue.main.async {
//                            self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image))
//                        }
                        self.group.enter()
                        self.addItem(model: PhotoPickerModel(with: image), group: self.group)
                    }
                    
                    if self.checker {
                        self.checker = false
                        self.group.notify(queue: .main, execute: {
                            print("finished")
                            self.photoPicker.didLoadChosenItems?()
                        })
                    }
                }
            }
        }
        
        private func addItem(model: PhotoPickerModel, group: DispatchGroup) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.photoPicker.mediaItems.append(item: model)
                group.leave()
                print("leaving: \(model.id)")
            }
        }
    }
}
