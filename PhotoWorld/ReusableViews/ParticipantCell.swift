//
//  ParticipantCell.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher
 
struct ParticipantCellView: View {
    var participant: ParticipantInfo
    var openParticipantView: ()->Void
    
    var body: some View {
        HStack {
            ProfileImageView(imageURL: URL(string: participant.avatar_url))
                .scaledToFill()
                .clipped()
                .frame(width: getRelativeWidth(75.0),
                       height: getRelativeWidth(75.0), alignment: .center)
                .cornerRadius(10)
                .padding()
                
            VStack {
                
                HStack {
                    Text(participant.name)
                        .foregroundColor(ColorConstants.WhiteA700)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    
                    participant.invite_status.statusTag()
                }.frame(alignment: .leading)
                
                HStack {
                    Image("ratingStar")
                        .resizable()
                        .frame(width: getRelativeWidth(15.0),
                               height: getRelativeHeight(15), alignment: .center)
                        .scaledToFit()
                        .clipped()
                    
                    Text("\(participant.rating, specifier: "%.1f")")
                        .foregroundColor(ColorConstants.Bluegray700)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    
                    Spacer()
                    
                    Text("\(participant.comments_number.description) отзывов")
                        .foregroundColor(ColorConstants.Bluegray700)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                }.frame(width: getRelativeWidth(120), height: getRelativeHeight(20), alignment: .leading)
                    .padding(.trailing, getRelativeWidth(60))
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }.frame(width:  getRelativeWidth(343))
            .onTapGesture {
                openParticipantView()
            }
    }
}
