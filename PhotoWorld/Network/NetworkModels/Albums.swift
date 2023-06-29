//
//  Albums.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 10.05.2023.
//

import Foundation

struct AlbumbCreationRKO: Codable {
    var album_name: String
    var photos: [URL]
    var is_private: Bool
    
    init (album: Album) {
        self.album_name = album.name
        self.photos = album.imageURLs
        self.is_private = album.visibility == .closed
    }
}

struct AlbumPhotosUploadiingRKO: Codable {
    var photos: [URL]
}
