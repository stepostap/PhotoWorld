//
//  ProfileCell.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher
 
struct ProfileImageView: View {
    var imageURL: URL?
    
    var body: some View {
        if let imageURL = imageURL {
            KFImage(imageURL)
                .resizable()
                .placeholder({ Loader() })
        } else if let image = UIImage(named: "accountPlaceholder") {
            Image(uiImage: image)
                .resizable()
        }
    }
}

struct ProfileCellView: View {
    var imageURL: URL?
    var profileType: ProfileType
    var name: String
    var rating: Double
    var commentsCount: Int
    
    var body: some View {
        HStack {
            ProfileImageView(imageURL: imageURL)
                .scaledToFill()
                .clipped()
                .frame(width: getRelativeWidth(75.0),
                       height: getRelativeWidth(75.0), alignment: .center)
                .cornerRadius(10)
                .padding()
                
            VStack {
                Text(profileType.title)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .frame(width: getRelativeWidth(100), height: getRelativeHeight(20), alignment: .center)
                    .background(RoundedCorners(topLeft: 12, topRight: 12,
                                               bottomLeft: 12,
                                               bottomRight: 12)
                            .fill(ColorConstants.Bluegray800))
                
                
                Text(name)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                
                HStack {
                    Image("ratingStar")
                        .resizable()
                        .frame(width: getRelativeWidth(15.0),
                               height: getRelativeHeight(15), alignment: .center)
                        .scaledToFit()
                        .clipped()
                    
                    Text("\(rating, specifier: "%.1f")")
                        .foregroundColor(ColorConstants.Bluegray700)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    
                    Spacer()
                    
                    Text("\(commentsCount.description) отзывов")
                        .foregroundColor(ColorConstants.Bluegray700)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                }.frame(width: getRelativeWidth(120), height: getRelativeHeight(20), alignment: .leading)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }.frame(width:  getRelativeWidth(343))
    }
}
