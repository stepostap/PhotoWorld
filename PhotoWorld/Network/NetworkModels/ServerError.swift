//
//  ServerError.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 03.05.2023.
//

import Foundation

struct ServerError: Codable {
    let message: String
    let errorName: String
    let httpStatus: String
    let zonedDateTime: String
}
