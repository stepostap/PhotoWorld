//
//  UserProfile.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import Foundation
import UIKit
import Kingfisher

struct UserProfile {
    var mediaItems: PickedMediaItems = PickedMediaItems()
    var accountImage: UIImage
    var profileType: ProfileType?
    var specialiazations: [String]?
    var shortInfo: ProfileShortInfo?
}

struct Album {
    internal init(name: String,
                  imageURLs: [URL],
                  firstImageURL: URL,
                  imagesCount: Int,
                  visibility: AlbumVisibility? = nil) {
        self.name = name
        self.imageURLs = imageURLs
        self.firstImageURL = firstImageURL
        self.imagesCount = imagesCount
        self.visibility = visibility
    }
    
    init(rko: AlbumRKO) {
        name = rko.name
        firstImageURL = URL(string: rko.first_image_url)!
        imageURLs = []
        imagesCount = rko.photo_number
        visibility = rko.is_private ? .closed : .open
    }
    
    var name: String
    var imageURLs: [URL]
    var firstImageURL: URL
    var imagesCount: Int
    var visibility: AlbumVisibility?
}

class Account {
    public init(name: String, type: ProfileType) {
        self.type = type
        self.name = name
    }
    
    public init(avaURL: String?, accountRKO: AccountRKO, type: ProfileType) {
        if let avaURL = avaURL {
            self.profileImageURL = URL(string: avaURL)
        }
        self.type = type
        self.tags = accountRKO.tags
        self.name = accountRKO.name
        var serviceInfo: [UserServiceInfo] = []
        for service in accountRKO.services {
            serviceInfo.append(UserServiceInfo(rko: service))
        }
        
        var albums: [Album] = []
        for rko in accountRKO.albums {
            albums.append(Album(rko: rko))
        }
        self.albums = albums
        
        self.services = UserServices(userServeices: serviceInfo)
        self.profileInfo = ProfileShortInfo(about: accountRKO.about_me,
                                            experience: accountRKO.work_experience,
                                            additionalInfo: accountRKO.extra_info)
        self.comments = accountRKO.comments
        self.allPhotos = accountRKO.all_photos
    }
    
    let name: String
    let type: ProfileType
    var tags: [String]?
    var services: UserServices?
    var profileInfo: ProfileShortInfo?
    @Published var albums: [Album]?
    var profileImageURL: URL?
    var allPhotos: [URL]?
    var comments: [CommentInfo]?
    
    func getAvRating() -> Double {
        var a = 0.0
        if let comments = comments, !comments.isEmpty {
            for comment in comments {
                a += Double(comment.grade)
            }
            return a / Double(comments.count)
        }
        return 0.0
    }
}

struct AccountRKO: Codable {
    var name: String
    var comments_number: Int
    var rating: Double
    var albums: [AlbumRKO]
    var all_photos: [URL]
    var about_me: String
    var tags: [String]
    var services: [ServiceRKO]
    var work_experience: Int
    var comments: [CommentInfo]
    var extra_info: String
}

struct AlbumRKO: Codable {
    var name: String
    var first_image_url: String
    var photo_number: Int
    var is_private: Bool
}
