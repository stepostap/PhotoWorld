//
//  PhotoChoiceView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 21.04.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct PhotoChoiceView: View {
    @State private var showSheet = false
    @ObservedObject var mediaItems: PickedMediaItems
    let sendData: ()->Void
    let progress: Double
    @State var isLoading = false
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            ScrollView {
                Button(action: { showSheet = true }, label: {
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
                
                ForEach(0 ..< (mediaItems.items.count + 1) / 2, id: \.self) { row in
                    HStack {
                        ForEach(0..<2) { col in
                            let index = row*2 + col
                            if index < mediaItems.items.count {
                                Image.init(uiImage: (mediaItems.items[index].photo ?? UIImage(named: "inputError"))!)
                                    .resizable()
                                    .frame(width: getRelativeWidth(165.0),
                                           height: getRelativeWidth(165.0), alignment: .leading)
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(8)
                                    .padding(.horizontal, getRelativeWidth(4))
                            }
                        }
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(160), alignment: .leading)
                    .padding(.bottom, getRelativeHeight(15.0))
                }
                
            }.padding(.top, getRelativeHeight(25))
            
            Button(action: {
                isLoading = true
                sendData()
            }, label: {
                if isLoading {
                    Loader()
                } else {
                    Text(mediaItems.items.count != 0 ? "Отправить" : "Пропустить")
                }
            }).disabled(isLoading)
                .buttonStyle(MainButtonStyle(backgoundColor:
                                             ColorConstants.BlueA700 ,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(mediaItems: mediaItems) { didSelectItem in
                showSheet = false
            }
        })
    }
}
