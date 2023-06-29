//
//  Tags.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation

struct Tags: Codable {
    var tags: [String]
}

struct ServiceNames: Codable {
    var services: [String]
}

struct ImageURL: Codable {
    let image_url: String
}

struct DownloadImageURL: Codable {
    let imageUrl: URL
}
