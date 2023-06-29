//
//  ViewAlbumView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 27.05.2023.
//


import Foundation
import SwiftUI
import Kingfisher

struct ViewAlbumView<model: ViewAlbumViewModelIO>: View {
    @ObservedObject var viewModel: model
    
    var body: some View {
        VStack {
            ProgressView(value: 0.5)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            if viewModel.refresh { Text("").frame(width: 0, height: 0) }
            
            ScrollView {
                Button(action: { viewModel.showSheet = true }, label: {
                    HStack {
                        Text("Загрузить фотографии")
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: getRelativeWidth(18.0),
                                   height: getRelativeWidth(18.0), alignment: .leading)
                            .scaledToFit()
                            .clipped()
                            .padding(.vertical, getRelativeHeight(14.0))
    
                    }
                })
                    .padding([.bottom], getRelativeHeight(20.0))
                    .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.WhiteA700, textColor: ColorConstants.Gray900))
                
                ForEach(0 ..< (viewModel.urls.count + 1) / 2, id: \.self) { row in
                    HStack {
                        ForEach(0..<2) { col in
                            let index = row*2 + col
                            if index < viewModel.urls.count {
                                KFImage(viewModel.urls[index])
                                    .resizable()
                                    .placeholder({ Loader() })
                                    .frame(width: getRelativeWidth(165.0),
                                           height: getRelativeWidth(165.0), alignment: .leading)
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(8)
                                    .padding(.horizontal, getRelativeWidth(4))
                                    .onTapGesture(perform: {
                                        self.viewModel.openPhotoView()
                                    })
                            }
                        }
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(160), alignment: .leading)
                    .padding(.bottom, getRelativeHeight(15.0))
                }
                
            }.padding(.top, getRelativeHeight(25))
            
//            Button(action: { viewModel.goToCommentView() }, label: {
//                Text("Продолжить")
//            })
//                .buttonStyle(MainButtonStyle(backgoundColor:
//                                             ColorConstants.BlueA700 ,
//                                             textColor: ColorConstants.WhiteA700))
//                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .sheet(isPresented: $viewModel.showSheet, content: {
            viewModel.photoPicker
        })
    }
}
