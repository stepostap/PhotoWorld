//
//  ProfileTypeTags.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.05.2023.
//

import Foundation

class ProfileTypeTags {
    static var tags: [ProfileType:[String]?] = [.photographer:nil, .stylist:nil, .model:nil]
    
    static func getTags(forType: ProfileType) -> [String]? {
        return tags[forType]!
    }
    
    static func setTags(forType: ProfileType, tags: [String]) {
        self.tags[forType] = tags
    }
}
