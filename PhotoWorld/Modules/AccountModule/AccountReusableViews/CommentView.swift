//
//  CommentView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct CommentView: View {
    var comments: [CommentInfo]
    var avScore: Double {
        var a = 0.0
        for comment in comments {
            a += Double(comment.grade)
        }
        if !comments.isEmpty {
            return a / Double(comments.count)
        } else {
            return 0
        }
    }

    var body: some View {
        VStack {
            TitleText(text: "\(comments.count) отзывов")
            HStack {
                ForEach(0..<Int(avScore)) { _ in
                    Image("star.filled")
                        .resizable()
                        .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                }
                ForEach(0..<5-Int(avScore)) { _ in
                    Image("star")
                        .resizable()
                        .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                }
                
                Text("\(avScore, specifier: "%.1f") / 5")
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .padding(.leading, getRelativeWidth(10))
            }.frame(width: getRelativeWidth(343), alignment: .leading)
                .padding(.bottom, getRelativeHeight(10))
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(0..<comments.count, id: \.self) { index in
                        CommentCell(comment: comments[index])
                            .padding(.bottom, getRelativeWidth(10))
                    }
                }
            }
        }.frame(width: getRelativeWidth(343), alignment: .center)
    }
}

struct CommentCell: View {
    var comment: CommentInfo
    
    var body: some View {
        VStack {
            HStack {
                Text(comment.writer_name)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                
                Spacer()
                
                HStack {
                    ForEach(0..<comment.grade) { _ in
                        Image("star.filled")
                            .resizable()
                            .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                    }
                    ForEach(0..<5-comment.grade) { _ in
                        Image("star")
                            .resizable()
                            .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                    }
                }
            }.frame(width: getRelativeWidth(320), alignment: .center)
                .padding(.top, getRelativeHeight(10))
            
            Text(comment.getDateString())
                .foregroundColor(Color.gray)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(12.0)))
                .frame(width: getRelativeWidth(320), alignment: .leading)
            
            Text(comment.comment)
                .foregroundColor(ColorConstants.WhiteA700)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .frame(width: getRelativeWidth(320), alignment: .leading)
                .padding(.vertical, getRelativeHeight(10))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<comment.photos.count, id: \.self) {index in
                        KFImage(comment.photos[index])
                            .resizable()
                            .placeholder( {Loader()} )
                            .frame(width: getRelativeWidth(100),
                                   height: getRelativeHeight(100), alignment: .leading)
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(8)
                    }
                }
            }.frame(width: getRelativeWidth(320), alignment: .center)
                .padding(.bottom, getRelativeHeight(10))
        }.frame(width: getRelativeWidth(343), alignment: .center)
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0,
                                       bottomLeft: 8.0, bottomRight: 8.0)
                    .fill(ColorConstants.Bluegray800))
    }
}
