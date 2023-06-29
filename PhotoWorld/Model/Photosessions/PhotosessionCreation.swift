//
//  PhotosessionCreation.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation

struct PhotosessionCreationInfo: Codable {
    
    var profileType: String
    var photosession_name: String
    var description: String
    var duration: Double
    var address: String
    var start_date_and_time: Int64
    var photos: [URL]
    var tags: [String]
}
