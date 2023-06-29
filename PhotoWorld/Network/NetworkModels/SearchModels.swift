//
//  SearchModels.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation

struct SearchProfileInfo: Codable, Identifiable {
    var id: String {
        return email
    }
    
    var name: String
    var email: String
    var avatar_url: String
    var photos: [URL]?
    var services: [ServiceRKO]
    var rating: Double
    var comments_number: Int
    var profile_type: ProfileType
}

struct SearchInfo: Codable {
    var search_query: String
    var tags: [String]?
    var start_work_experience: Int?
    var end_work_experience: Int?
    var services: [ServiceRKO]?
    var profile_type: String?
}

struct SearchResult: Codable {
    let profiles: [SearchProfileInfo]
}

struct PhotosessionID: Codable {
    let photosessionId: String
}

struct ChatURL: Codable {
    let chat_url: String
}
