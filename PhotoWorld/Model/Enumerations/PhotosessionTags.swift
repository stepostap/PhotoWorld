//
//  PhotosessionTags.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import Foundation

enum PhotosessionTags: CaseIterable {
    case wedding
    case portrait
    case nude
    case studio
    case outdoors
    case goAwaySession
}

extension PhotosessionTags {
    var title : String {
        switch self {
        case .wedding:
            return "Свадебная съемка"
        case .portrait:
            return "Портретная съемка"
        case .nude:
            return "Ню фотография"
        case .studio:
            return "Студийная съемка"
        case .outdoors:
            return "Съемка на улице"
        case .goAwaySession:
            return "Выездная фотосессия"
        }
    }
}
