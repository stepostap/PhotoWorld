//
//  PhotosesionListItem.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import SwiftUI
import SwiftUICalendar

struct ParticipantShortInfo: Codable {
    var name: String
    var avatarUrl: String
}

struct InvitationInfo: Codable {
    var email: String
    var profile_type: ProfileType
}

enum PhotosessionStatus: String, Codable {
    case expectation = "EXPECTATION"
    case refusal = "NONE"
    case ready = "RECEPTION_COMPLETED"
}

extension PhotosessionStatus {
    var title: String {
        switch self {
        case .expectation:
            return "Ожидание"
        case .refusal:
            return "Завершена"
        case .ready:
            return "Набор завершен"
        }
    }
    
    @ViewBuilder func statusTag() -> some View {
        switch self {
        case .ready:
            TagView(text: self.title, color: ColorConstants.AcceptBackground,
                           textColor: ColorConstants.AcceptText)
        case .expectation:
            TagView(text: self.title, color: ColorConstants.PendingBackground, textColor:
                            ColorConstants.PendingTextColor)
        case .refusal:
            TagView(text: self.title, color: ColorConstants.DeclineBackground, textColor:
                            ColorConstants.DeclineTextColor)
        }
    }
}

struct PhotosessionListItem: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var start_time: Int64
    var end_time: Int64
    var participants_avatars: [ParticipantShortInfo]
    var photosessionStatus: PhotosessionStatus
    var chat_url: String
    
    func formatTime() -> String {
        let startDate = Date(milliseconds: start_time)
        let endDate = Date(milliseconds: end_time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timestr = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        return timestr
    }
    
    func formatDate() -> String {
        let startDate = Date(milliseconds: start_time)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        let daystr = formatter.string(from: startDate)
        return daystr
    }
    
    func getDate() -> YearMonthDay {
        let date = Date(milliseconds: start_time)
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return YearMonthDay(year: comps.year!, month: comps.month!, day: comps.day!)
    }
}

struct AllPhotosessionsUserInfo: Codable {
    var photosessions: [PhotosessionListItem]
}
