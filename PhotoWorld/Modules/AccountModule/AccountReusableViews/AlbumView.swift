//
//  AlbumView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 09.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct AlbumView: View {
    let album: Album
    
    var body: some View {
        VStack {
            KFImage(album.firstImageURL)
                .resizable()
                .placeholder({ Loader() })
                .frame(width: getRelativeWidth(165.0),
                       height: getRelativeWidth(165.0), alignment: .leading)
                .scaledToFit()
                .clipped()
                .cornerRadius(8)
                .padding(.horizontal, getRelativeWidth(4))
            Text(album.name)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(alignment: .leading)
            Text("\(album.imagesCount.description) фотографии")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(12.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.Gray600)
                .frame(alignment: .leading)
        }
    }
}
