//
//  AccountInfoView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI

struct AccountInfoView<model>: View where model: UserAccountViewModelIO {

    @EnvironmentObject var viewModel: model
    
    var body: some View {
        
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    if let text = viewModel.account.profileInfo?.about, !text.isEmpty {
                        TitleText(text: "О себе")
                        
                        Text(text)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343.0),
                                   alignment: .topLeading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if let tags = viewModel.account.tags {
                        TitleText(text: "Теги")
                            .padding(.top, getRelativeHeight(10))
                        
                        VStack {
                            ForEach(0..<(tags.count+1)/2, id: \.self) { row in
                                let index = row * 2
                                HStack {
                                    TagView(text: tags[index])
                                    if index+1 < tags.count {
                                        TagView(text: tags[index+1])
                                    }
                                }.frame(width: getRelativeWidth(343), alignment: .leading)
                            }
                        }.padding(.bottom, getRelativeHeight(10))
                    }
                                        
                    if let experience = viewModel.account.profileInfo?.experience {
                        TitleText(text: "Стаж работы")
                        
                        Text(experience.description)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343.0),
                                   alignment: .topLeading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if let services = viewModel.account.services, !services.userServices.isEmpty {
                        TitleText(text: "Услуги и цены")
                            .padding(.top, getRelativeHeight(10))
                        
                        ForEach(0..<services.userServices.count, id: \.self) { index in
                            ServiceCell(service: services.userServices[index])
                                .padding(.bottom, getRelativeHeight(5))
                        }
                    }
                    
                }.frame(alignment: .top)
            }
            
        }
        .frame(width: getRelativeWidth(343), alignment: .center)
        .background(ColorConstants.Bluegray900)
        ///.ignoresSafeArea()
    }
}

//@ViewBuilder func titleText(text: String) -> some View {
//    Text(text)
//        .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
//        .fontWeight(.bold)
//        .foregroundColor(ColorConstants.WhiteA700)
//        .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
//               alignment: .topLeading)
//}
