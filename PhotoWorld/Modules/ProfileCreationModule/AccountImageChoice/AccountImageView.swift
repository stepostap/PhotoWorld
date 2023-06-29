//
//  AccountImageView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 23.04.2023.
//

import SwiftUI

struct AccountImageView<model: AccountImageViewModelIO>: View {
    @State private var showSheet = false
    
    public init(viewModel: model) {
        self.viewModel = viewModel
        self.mediaItems = viewModel.mediaItems
    }
    
    @ObservedObject var viewModel: model
    @ObservedObject var mediaItems: PickedMediaItems
    
    var body: some View {
        VStack {
            ProgressView(value: 1)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopConstraint)
            
            Text("Загрузите фото профиля")
                .foregroundColor(ColorConstants.WhiteA700)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(25), alignment: .leading)
                .padding(.top, getRelativeHeight(10))
            Text("Клиенты чаще выбирают специалистов с фото. Потом его можно будет поменять в настройках")
                .foregroundColor(Color.gray)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(40), alignment: .leading)
            
            imageView()
                .padding(.top, getRelativeHeight(64.0))
                .padding(.horizontal, getRelativeWidth(16.0))
            
            Button(action: { showSheet = true }, label: {
                Text("Прикрепить фото")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
            })
            .buttonStyle(.borderless)
            .padding(.top, getRelativeHeight(20))
            
            Spacer()
            
            Button(action: { viewModel.uploadImage() }, label: {
                Text(viewModel.mediaItems.items.count != 0 ? "Отправить" : "Пропустить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor:
                                             ColorConstants.BlueA700 ,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(mediaItems: viewModel.mediaItems, selectionLimit: 1) { didSelectItem in
                showSheet = false
            }
        })
        
    }
    
    @ViewBuilder func imageView() -> some View {
        if let image = viewModel.mediaItems.items.first?.photo {
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: getRelativeWidth(236.0), height: getRelativeHeight(228.0),
                           alignment: .center)
                    .scaledToFit()
                    .clipped()
                    .cornerRadius(8)
                    .padding(.top, getRelativeHeight(97.41))
                    .padding(.bottom, getRelativeHeight(97.59))
                    .padding(.horizontal, getRelativeWidth(102.99))
            }
            .frame(width: getRelativeWidth(236.0), height: getRelativeHeight(228.0),
                   alignment: .center)
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                    .fill(ColorConstants.Bluegray800))
            
        } else {
            ZStack {
                Image("img_arrowup")
                    .resizable()
                    .frame(width: getRelativeWidth(30.0), height: getRelativeHeight(33.0),
                           alignment: .center)
                    .scaledToFill()
                    .clipped()
                    .padding(.top, getRelativeHeight(97.41))
                    .padding(.bottom, getRelativeHeight(97.59))
                    .padding(.horizontal, getRelativeWidth(102.99))
            }
            .frame(width: getRelativeWidth(236.0), height: getRelativeHeight(228.0),
                   alignment: .center)
            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                    bottomRight: 8.0)
                    .stroke(ColorConstants.Bluegray700,
                            lineWidth: 2))
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                    .fill(ColorConstants.Bluegray800))
        }
    }
}
