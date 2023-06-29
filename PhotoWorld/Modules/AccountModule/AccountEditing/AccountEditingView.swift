//
//  AccountEditingView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 11.05.2023.
//

import Foundation
import SwiftUI

struct AccountEditingView<model>: View where model: AccountEditingViewModelIO {
    let viewModel: model
    
    var body: some View {
        VStack {

            AccountHeaderView(account: viewModel.account,
                              mainButtonTitle: "Изменить фото профиля",
                              mainButtonAction: {})
                .padding(.vertical, getRelativeWidth(30))
            
            editInfoButton(imageName: "info.circle.fill", infoName: "Информация о профиле",
                           pressAction: { viewModel.openInfoEditing() })
            
            editInfoButton(imageName: "tag.circle.fill", infoName: "Теги",
                           pressAction: { viewModel.openTagsEditing() })
            
            editInfoButton(imageName: "rublesign.circle.fill", infoName: "Услуги и цены",
                           pressAction: { viewModel.editServices() })
            
            editInfoButton(imageName: "rectangle.portrait.and.arrow.right.fill", infoName: "Выйти",
                           pressAction: { viewModel.exit() })
                
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "trash")
                        .resizable()
                        .foregroundColor(ColorConstants.Red400)
                        .padding(getRelativeWidth(10))
                        .frame(width: getRelativeWidth(45), height: getRelativeHeight(45), alignment: .center)
                        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                   bottomRight: 8.0)
                                        .fill(ColorConstants.Bluegray800))
                    Text("Удалить профиль")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.Red400)
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(45), alignment: .leading)
                
            })
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
    
    @ViewBuilder func editInfoButton(imageName: String, infoName: String, pressAction: @escaping ()->Void) -> some View {
        Button(action: pressAction, label: {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .foregroundColor(ColorConstants.WhiteA700)
                    .padding(getRelativeWidth(10))
                    .frame(width: getRelativeWidth(45), height: getRelativeHeight(45), alignment: .center)
                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                               bottomRight: 8.0)
                                    .fill(ColorConstants.Bluegray800))
                Text(infoName)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
            }.frame(width: getRelativeWidth(343), height: getRelativeHeight(45), alignment: .leading)
                .padding(.bottom, getRelativeHeight(20))
        })
    }
}
