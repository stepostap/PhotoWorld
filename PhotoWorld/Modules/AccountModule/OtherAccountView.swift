//
//  OtherAccountView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.05.2023.
//

import Foundation
import SwiftUI

struct OtherAccountView: View {
    var account: Account
    var openChat: ()->Void
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    Rectangle()
                        .frame(width: getRelativeWidth(343), height: getRelativeHeight(160))
                        .cornerRadius(10)
                        .foregroundColor(ColorConstants.Bluegray800)
                        .padding(.top, getRelativeHeight(20))
                    
                    VStack {
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
                    }
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(240), alignment: .center)
                    // .padding(.top, getRelativeHeight(35))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if let albums = account.albums {
                            ForEach(0 ..< albums.count, id: \.self) { index in
                                AlbumView(album: albums[index])
                            }
                        }
                    }.frame( alignment: .top)
                }.frame(width: getRelativeWidth(343))
                
                VStack {
                    if let text = account.profileInfo?.about, !text.isEmpty {
                        TitleText(text: "О себе")
                        
                        Text(text)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343.0),
                                   alignment: .topLeading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if let tags = account.tags {
                        TitleText(text: "Теги")
                            .padding(.top, getRelativeHeight(10))
                        
                        VStack {
                            ForEach(0..<(tags.count+1)/2, id: \.self) { row in
                                let index = row * 2
                                HStack {
                                    TagView(text: tags[index])
                                    if index+1 < tags.count {
                                        TagView(text: tags[index+1])
                                    }
                                }.frame(width: getRelativeWidth(343), alignment: .leading)
                            }
                        }.padding(.bottom, getRelativeHeight(10))
                    }
                    
                    if let experience = account.profileInfo?.experience {
                        TitleText(text: "Стаж работы")
                        
                        Text("\(experience.description) лет")
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343.0),
                                   alignment: .topLeading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if let services = account.services, !services.userServices.isEmpty {
                        TitleText(text: "Услуги и цены")
                            .padding(.top, getRelativeHeight(10))
                        
                        ForEach(0..<services.userServices.count, id: \.self) { index in
                            ServiceCell(service: services.userServices[index])
                                .padding(.bottom, getRelativeHeight(5))
                        }
                    }
                    
                }.frame(alignment: .top)
                    .padding(.bottom, getRelativeHeight(10))

                
                if let comments = account.comments {
                    TitleText(text: "\(comments.count) отзывов")
                    HStack {
                        ForEach(0..<Int(account.getAvRating()), id: \.self) { _ in
                            Image("star.filled")
                                .resizable()
                                .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                        }
                        ForEach(0..<5-Int(account.getAvRating()), id: \.self) { _ in
                            Image("star")
                                .resizable()
                                .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                        }
                        
                        Text("\(account.getAvRating(), specifier: "%.1f") / 5")
                            .foregroundColor(ColorConstants.WhiteA700)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                            .padding(.leading, getRelativeWidth(10))
                    }.frame(width: getRelativeWidth(343), alignment: .leading)
                        .padding(.bottom, getRelativeHeight(10))
                    
                    
                    VStack {
                        ForEach(0..<comments.count, id: \.self) { index in
                            CommentCell(comment: comments[index])
                                .padding(.bottom, getRelativeWidth(10))
                        }
                    }.frame(width: getRelativeWidth(343), alignment: .center)
                    
                }
                
                Button(action: { openChat() }, label: {
                    Text("Написать")
                })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(width: getRelativeWidth(343),
                                             backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))
            }
            //.padding(.bottom, getRelativeHeight(90))
            .padding(.top, getRelativeHeight(70))
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            .background(ColorConstants.Bluegray900)
          
    }
}








