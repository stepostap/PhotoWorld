//
//  RegInfo.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 03.05.2023.
//

import Foundation

struct RegInfo: Codable {
    let name: String
    let email: String
    let password: String
}

struct AuthInfo: Codable {
    let email: String
    let password: String
    
    static var currentUserEmail = ""
}


struct VerificationInfo: Codable {
    let email: String
    let activation_code: String
}

struct Email: Codable {
    let email: String
}
