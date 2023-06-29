//
//  PhotographerSpecialization.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 21.04.2023.
//

import Foundation

protocol AccountSpecialization {
    var title: String { get }
}

enum PhotographerSpecialization: CaseIterable {
    case Teacher
    case Portrait
    case Nature
    case Family
    case Wedding
}
 
extension PhotographerSpecialization: AccountSpecialization {
    var title: String {
        switch self {
        case .Teacher:
            return "Обучение"
        case .Portrait:
            return "Портретная съемка"
        case .Nature:
            return "Съемка на природе"
        case .Family:
            return "Семейная съемка"
        case .Wedding:
            return "Свадебная фотосессия"
        }
    }
}
