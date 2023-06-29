//
//  ParticipantsCommentView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation
import SwiftUI

struct ParticipantsCommentView: View {
    var participants: [ParticipantInfo]
    var openParticipantComment: (ParticipantInfo)->Void
    var finish: ()->Void
    
    var body: some View {
        VStack {
            ProgressView(value: 1)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(participants) { participant in
                        ProfileCellView(imageURL: URL(string: participant.avatar_url),
                                        profileType: participant.profile_type,
                                        name: participant.name, rating: participant.rating,
                                        commentsCount: participant.comments_number)
                        Button(action: { openParticipantComment(participant) }, label: {
                            Text("Оставить отзыв")
                        }).buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.Bluegray800,
                                                       textColor: ColorConstants.WhiteA700))
                            .padding(.vertical, getRelativeHeight(10))
                        
                        Rectangle()
                            .foregroundColor(ColorConstants.Gray600)
                            .frame(width: getRelativeWidth(343), height: 1, alignment: .center)
                    }
                }
            }
            
            Button(action: { finish() }, label: {
                Text("Завершить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor:
                                             ColorConstants.BlueA700 ,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
    }
}
