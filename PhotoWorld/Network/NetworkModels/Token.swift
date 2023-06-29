//
//  Token.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation

struct Token: Codable {
    let session_token: String
    let chat_access_token: String
    let chat_user_id: String
    let chat_app_id: String
    let username: String
}
