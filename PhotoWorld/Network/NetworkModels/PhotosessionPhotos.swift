//
//  PhotosessionPhotos.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation

struct PhotosessionPhotos: Codable {
    var photos: [URL]
}

struct AlbumAllPhotos: Codable {
    var all_photos: [URL]
}
