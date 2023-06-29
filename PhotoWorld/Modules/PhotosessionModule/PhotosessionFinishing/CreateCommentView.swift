//
//  CreateCommentView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 16.05.2023.
//

import Foundation
import SwiftUI

struct CreateCommentView<model: CreateCommentViewModelIO>: View {
    
    @ObservedObject var viewModel: model
    @State var showSheet = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    ProfileCellView(imageURL: URL(string: viewModel.profile.avatar_url),
                                    profileType: viewModel.profile.profile_type,
                                    name: viewModel.profile.name,
                                    rating: viewModel.profile.rating,
                                    commentsCount: viewModel.profile.comments_number)
                    .padding(.top, EdgeInsets.SafeAreaTopConstraint)
                    
                    TitleText(text: "Оцените пользователя")
                    HStack {
                        ForEach(0..<5) { index in
                            starButton(index: index)
                                .padding(.trailing, getRelativeWidth(15))
                        }
                    }.frame(width: getRelativeWidth(343), alignment: .center)
                        .padding(.vertical, getRelativeHeight(20))
                    
                    TitleText(text: "Расскажите подробнее")
                    InputTextView(text: $viewModel.comment, placeholder: "Комментарий")
                    
                    Toggle("Оставить отзыв анонимным", isOn: $viewModel.anonymus)
                        .toggleStyle(SwitchToggleStyle(tint: ColorConstants.BlueA700))
                        .foregroundColor(ColorConstants.WhiteA700)
                        .frame(width: getRelativeWidth(343), alignment: .center)
                    
                    Button(action: { showSheet.toggle(); viewModel.loadingPhotos = true }, label: {
                        if viewModel.loadingPhotos {
                            Loader()
                        } else {
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
                        }
                    })
                        .buttonStyle(MainButtonStyle(backgoundColor:
                                                     ColorConstants.Bluegray700 ,
                                                     textColor: ColorConstants.WhiteA700))
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<viewModel.imageLoader.pickedItems.items.count, id: \.self) {index in
                                Image.init(uiImage: (viewModel.imageLoader.pickedItems.items[index].photo
                                                     ?? UIImage(named: "inputError"))!)
                                    .resizable()
                                    .frame(width: getRelativeWidth(100),
                                           height: getRelativeHeight(100), alignment: .leading)
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }.frame(width: getRelativeWidth(343), alignment: .center)
                    
                    Button(action: { viewModel.createComment() }, label: {
                        Text("Отправить")
                    })
                        .buttonStyle(MainButtonStyle(backgoundColor:
                                                     ColorConstants.BlueA700 ,
                                                     textColor: ColorConstants.WhiteA700))
                        .padding(.bottom, EdgeInsets.SafeAreaBottomConstraint)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(mediaItems: viewModel.imageLoader.pickedItems) { didSelectItem in
                showSheet = false
                viewModel.imageLoader.uploadImages()
            }
        })
        
    }
    
    @ViewBuilder func starButton(index: Int) -> some View {
        Button(action: {
            viewModel.chosenRating = index+1
        }, label: {
            if index < viewModel.chosenRating {
                Image("star.filled")
                    .resizable()
                    .frame(width: getRelativeWidth(30), height: getRelativeHeight(30), alignment: .center)
            } else {
                Image("star")
                    .resizable()
                    .frame(width: getRelativeWidth(30), height: getRelativeHeight(30), alignment: .center)
            }
        })
    }
}
