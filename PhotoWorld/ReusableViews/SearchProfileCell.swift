//
//  SearchProfileCell.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct SearchProfileCell: View {
    var userProfile: SearchProfileInfo
    var buttonText: String
    var buttonAction: ()->Void
    
    var body: some View {
        VStack {
            ProfileCellView(imageURL: URL(string: userProfile.avatar_url),
                            profileType: ProfileType.photographer,
                            name: userProfile.name,
                            rating: userProfile.rating,
                            commentsCount: userProfile.comments_number)
            
           
            if let photos = userProfile.photos, !photos.isEmpty {
                Text("Фотографии")
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(20), alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<photos.count, id: \.self) {index in
                            KFImage(photos[index])
                                .resizable()
                                .placeholder( {Loader()} )
                                .frame(width: getRelativeWidth(140),
                                       height: getRelativeHeight(140), alignment: .leading)
                                .scaledToFit()
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(145), alignment: .center)
            }
            
            if !userProfile.services.isEmpty {
                ForEach ( userProfile.services.map({ rko in UserServiceInfo(rko: rko)})) { service in
                    ServiceCell(service: service)
                }
            }
            
            Button(action: { buttonAction() }, label: {
                Text(buttonText)
            })
            .buttonStyle(MainButtonStyle(height: getRelativeHeight(37), backgoundColor: ColorConstants.BlueA700, textColor: ColorConstants.WhiteA700))
            
            Rectangle()
                .foregroundColor(ColorConstants.Gray600)
                .frame(width: getRelativeWidth(343), height: 1, alignment: .center)
                .padding()
        }
        .frame(alignment: .top)
    }
}
