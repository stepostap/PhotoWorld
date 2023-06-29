//
//  ProfileType.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation

enum ProfileType: String, Codable {
    case photographer = "PHOTOGRAPHER"
    case model = "MODEL"
    case stylist = "VISAGIST"
    
    static var currentUserType: Self?
}

extension ProfileType {
    var profileCreationtitle: String {
        switch self {
        case .photographer:
            return "Создание профиля фотографа"
        case .model:
            return "Создание профиля модели"
        case .stylist:
            return "Создание профиля визажиста"
        }
    }
    
    var title: String {
        switch self {
        case .photographer:
            return "Фотограф"
        case .model:
            return "Модель"
        case .stylist:
            return "Стилист"
        }
    }
    
    var networkTitle: String {
        switch self {
        case .photographer:
            return "photographer"
        case .model:
            return "model"
        case .stylist:
            return "visagist"
        }
    }
}

struct UserProfiles: Codable {
    var name: String
    var profiles: [String:DisplayProfileInfo]
    
    var profileTypes: [ProfileType: DisplayProfileInfo] {
        var res: [ProfileType: DisplayProfileInfo] = [:]
        for temp in profiles {
            if temp.key == ProfileType.photographer.networkTitle {
                res[.photographer] = temp.value
            }
            if temp.key == ProfileType.stylist.networkTitle {
                res[.stylist] = temp.value
            }
            if temp.key == ProfileType.model.networkTitle {
                res[.model] = temp.value
            }
        }
        return res
    }
}

struct DisplayProfileInfo: Codable {
    var rating: Double
    var avatar_url: String
}
