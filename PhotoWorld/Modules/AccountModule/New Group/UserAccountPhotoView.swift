//
//  UserAccountPhotoView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI
import Kingfisher

struct UserAccountPhotoView<model>: View where model: UserAccountViewModelIO {

    @EnvironmentObject var viewModel: model
    
    var body: some View {
        
        VStack {
            Text("Мои альбомы")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                       alignment: .topLeading)
                .padding([.leading], getRelativeHeight(10))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    bigUploadImagmaeButton(action: viewModel.openAlbumCreation, label: "Создать альбом")
                    if let albums = viewModel.account.albums {
                        ForEach(0 ..< albums.count, id: \.self) { index in
                            AlbumView(album: albums[index])
                                .onTapGesture {
                                    viewModel.openAlbum(name: albums[index].name)
                                }
                        }
                    }
                }.frame(alignment: .top)
            }
            
            
            Text("Все фотографии")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                       alignment: .topLeading)
                .padding([.horizontal, .leading], getRelativeHeight(10))
            
            HStack {
                bigUploadImagmaeButton(action: { viewModel.openAddPhotos() }, label: "Загрузить фотографии")
                if let image = viewModel.account.allPhotos?.first {
                    KFImage(image)
                        .resizable()
                        .placeholder({Loader()})
                        .frame(width: getRelativeWidth(165.0),
                               height: getRelativeWidth(165.0), alignment: .leading)
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(8)
                        .padding(.bottom, getRelativeHeight(28))
                }
            }
            .frame(width: getRelativeWidth(343), alignment: .leading)
            .padding(.bottom, getRelativeHeight(15.0))

            if let allPhotos = viewModel.account.allPhotos, !allPhotos.isEmpty {
                ForEach(0 ..< (allPhotos.count) / 2, id: \.self) { row in
                    HStack {
                        ForEach(1..<3) { col in
                            let index = row*2 + col
                            if index < allPhotos.count {
                                KFImage(allPhotos[index])
                                    .resizable()
                                    .placeholder({Loader()})
                                    .frame(width: getRelativeWidth(165.0),
                                           height: getRelativeWidth(165.0), alignment: .leading)
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(160), alignment: .leading)
                    .padding(.bottom, getRelativeHeight(15.0))
                }
            }
        }
        .frame(width: getRelativeWidth(343), alignment: .center)
        .background(ColorConstants.Bluegray900)
    }
}


@ViewBuilder func bigUploadImagmaeButton(action: @escaping ()->Void, label: String ) -> some View {
    Button(action: { action() }, label: {
        VStack {
            ZStack {
                VStack {
                    Image("img_arrowup")
                        .resizable()
                        .frame(width: getRelativeWidth(30.0), height: getRelativeHeight(33.0),
                               alignment: .center)
                        .scaledToFill()
                        .clipped()
                    Text("Загрузить изображения")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(12.0)))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Gray600)
                        .frame(alignment: .center)
                }.frame(alignment: .center)
            }
            .frame(width: getRelativeWidth(168.0), height: getRelativeHeight(168),
                   alignment: .center)
            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                    bottomRight: 8.0)
                        .stroke(ColorConstants.Bluegray700,
                                lineWidth: 2))
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                            .fill(ColorConstants.Bluegray800))

            Text(label)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(alignment: .leading)

            Spacer()
        }.frame(alignment: .top)
    })
}
