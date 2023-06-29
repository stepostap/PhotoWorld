//
//  Participants.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import SwiftUI

enum InviteStatus: String, Codable {
    case ready = "READY"
    case pending = "PENDING"
    case declined = "DECLINED"
}

extension InviteStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .ready:
            return "Готов"
        case .pending:
            return "Ожидание"
        case .declined:
            return "Отказ"
        }
    }
    
    @ViewBuilder func statusTag() -> some View {
        switch self {
        case .ready:
            TagView(text: self.description, color: ColorConstants.AcceptBackground,
                           textColor: ColorConstants.AcceptText)
        case .pending:
            TagView(text: self.description, color: ColorConstants.PendingBackground, textColor:
                            ColorConstants.PendingTextColor)
        case .declined:
            TagView(text: self.description, color: ColorConstants.DeclineBackground, textColor:
                            ColorConstants.DeclineTextColor)
        }
    }
}

struct ParticipantInfo: Codable, Identifiable {
    var id: String {
        return email
    }

    var name: String
    var email: String
    var avatar_url: String
    var profile_type: ProfileType
    var rating: Double
    var comments_number: Int
    var invite_status: InviteStatus
}
