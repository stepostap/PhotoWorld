//
//  AccountHeaderView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 11.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct AccountHeaderView: View {
    let account: Account
    let mainButtonTitle: String
    let mainButtonAction: ()->Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(200))
                .cornerRadius(10)
                .foregroundColor(ColorConstants.Bluegray800)
                .padding(.top, getRelativeHeight(45))
            
            VStack {
                HStack {
                    addProfileButton()
                    ProfileImageView(imageURL: account.profileImageURL)
                        .scaledToFill()
                        .clipped()
                        .frame(width: getRelativeWidth(91.0),
                               height: getRelativeWidth(91.0), alignment: .center)
                        .cornerRadius(20.33)
                        .overlay(RoundedCorners(topLeft: 20.33, topRight: 20.33,
                                                bottomLeft: 20.33, bottomRight: 20.33)
                                .stroke(ColorConstants.Blue800,
                                        lineWidth: 3))
                    
                    addProfileButton()
                }
                
                Text(account.name)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                           alignment: .center)
           
                HStack {
                    Image("star.filled")
                        .resizable()
                        .frame(width: getRelativeWidth(15.0),
                               height: getRelativeHeight(15), alignment: .center)
                        .scaledToFit()
                        .clipped()
                       
                    Text("\(account.getAvRating(), specifier: "%.1f") \(account.type.title)")
                        .font(FontScheme
                                .kInterMedium(size: getRelativeHeight(13.0)))
                        .fontWeight(.semibold)
                        .foregroundColor(ColorConstants.WhiteA700)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(width: getRelativeWidth(65.0),
                               height: getRelativeHeight(23.0),
                               alignment: .center)
                        .padding(.horizontal, getRelativeWidth(4.0))
                }.frame(width: getRelativeWidth(300.0),
                        height: getRelativeHeight(23.0), alignment: .center)
                 .background(RoundedCorners(topLeft: 4.59, topRight: 4.59,
                                            bottomLeft: 4.59, bottomRight: 4.59)
                         .fill(ColorConstants.Bluegray800))
                
                Button(action: { mainButtonAction() }, label: {
                    Text(mainButtonTitle)
                })
                .padding([.vertical], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(width: getRelativeWidth(311), height: getRelativeHeight(37), backgoundColor: ColorConstants.Bluegray300, textColor: ColorConstants.WhiteA700))
            }
        }.frame(width: getRelativeWidth(343), height: getRelativeHeight(240), alignment: .center)
            .padding(.top, getRelativeHeight(55))
    }
    
    @ViewBuilder func addProfileButton() -> some View {
        Button(action: {}, label: {
            Image("AddProfile")
        })
        .frame(width: getRelativeWidth(61.0),
               height: getRelativeWidth(61.0), alignment: .center)
        .overlay(RoundedCorners(topLeft: 20.33, topRight: 20.33,
                                bottomLeft: 20.33, bottomRight: 20.33)
                .stroke(ColorConstants.Bluegray700,
                        lineWidth: 1))
        .background(RoundedCorners(topLeft: 20.33, topRight: 20.33,
                                   bottomLeft: 20.33,
                                   bottomRight: 20.33)
                .fill(ColorConstants.Bluegray800))
        .padding(.vertical, getRelativeHeight(14.0))
    }

}
