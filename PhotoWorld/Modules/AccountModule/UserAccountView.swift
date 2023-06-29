//
//  UserAccountView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI
import Kingfisher

struct UserAccountView<model>: View where model: UserAccountViewModelIO {
    @ObservedObject var viewModel: model
    @State var profileInfoViewSelection = 0
    
    public init(viewModel: model) {
        self.viewModel = viewModel
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(ColorConstants.Blue800)
        UISegmentedControl.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().tintColor = UIColor(ColorConstants.WhiteA700)
    }
    
    var body: some View {
        VStack {
            AccountHeaderView(account: viewModel.account,
                              mainButtonTitle: "Настройки профиля",
                              mainButtonAction: { viewModel.openEditing() })
            
            CustomSegmentController(choiceOptions: ["Фотографии","Информация","Отзывы"],
                                    selected: $profileInfoViewSelection)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(25), alignment: .center)
            
            ScrollView(.vertical, showsIndicators: false) {
                if profileInfoViewSelection==0 {
                    UserAccountPhotoView<model>()
                }
                if profileInfoViewSelection==1 {
                    AccountInfoView<model>()
                }
                if profileInfoViewSelection==2 {
                    CommentView(comments: viewModel.account.comments ?? [])
                }
            }
                .environmentObject(viewModel)
                .frame(width: getRelativeWidth(343), alignment: .center)
                .padding(.top, getRelativeWidth(10))
                .padding(.bottom, getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint + 20))
                .ignoresSafeArea()
                
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
        .onAppear(perform: { viewModel.showTabbar() })
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
