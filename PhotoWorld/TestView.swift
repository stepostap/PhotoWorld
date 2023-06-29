//
//  TestView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct TestView: View {
    @State private var showSheet = false
    @ObservedObject var mediaItems = PickedMediaItems()
    //@ObservedObject var viewModel: PhotoChoiceViewModel
    
    var body: some View {
        NavigationView {

        }
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(mediaItems: mediaItems) { didSelectItem in
                // Handle didSelectItems value here...
                showSheet = false
            }
        })
        
        VStack {
            ProgressView(value: 0.6)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, getRelativeHeight(90))
            
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
                
                ForEach(0 ..< (mediaItems.items.count + 1) / 2, id: \.self) { index in
                    HStack {
                        Image.init(uiImage: (mediaItems.items[index].photo ?? UIImage(named: "inputError"))!)
                            .resizable()
                            .frame(width: getRelativeWidth(165.0),
                                   height: getRelativeWidth(165.0), alignment: .leading)
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(8)
                            .padding(.horizontal, getRelativeWidth(4))

                        if index + 1 < mediaItems.items.count {
                            Image.init(uiImage: (mediaItems.items[index + 1].photo ?? UIImage(named: "inputError"))!)
                                .resizable()
                                .frame(width: getRelativeWidth(165.0),
                                       height: getRelativeWidth(165.0), alignment: .leading)
                                .scaledToFit()
                                .clipped()
                                .cornerRadius(8)
                        }
                        
                    }
                        .frame(width: getRelativeWidth(343), height: getRelativeHeight(160), alignment: .center)
                        .padding(.bottom, getRelativeHeight(15.0))
                }
            }.padding(.top, getRelativeHeight(25))
            
            Button(action: { }, label: {
                Text("Отправить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor:
                                             ColorConstants.BlueA700 ,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
        
    }
}
