//
//  PhotoPickerModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import SwiftUI

struct PhotoPickerModel:  Identifiable, Hashable {
    
    var id: String
    var photo: UIImage?
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
    }
    
    mutating func delete() {
        photo = nil
    }
}


class PickedMediaItems: ObservableObject {
    @Published var items = [PhotoPickerModel]()
    
    public init() {}
    public init(items: [PhotoPickerModel]) {
        self.items = items
    }
    
    func append(item: PhotoPickerModel) {
        items.append(item)
    }
    
    func deleteAll() {
        for (index, _) in items.enumerated() {
            items[index].delete()
        }
        
        items.removeAll()
    }
}
