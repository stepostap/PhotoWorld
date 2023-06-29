//
//  PhotosessionFullInfo.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation

struct PhotosessionFullInfo: Codable {
    var id: String
    var name: String
    var description: String
    var address: String
    var start_date_and_time: Int64
    var end_date_and_time: Int64
    var duration: Double
    var organizer: ParticipantInfo
    var participants: [ParticipantInfo]?
    var photos: [URL]?
    var result_photos: [URL]?
    var tags: [String]
    var chat_url: String
}
