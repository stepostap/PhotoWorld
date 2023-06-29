//
//  ShortInfoView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 23.04.2023.
//

import SwiftUI

struct ShortInfoView<model: ShortInfoViewModelIO>:  View {
    @ObservedObject var viewModel: model
    var progress = 0.4
    
    public init(viewModel: model) {
        UITextView.appearance().backgroundColor = .clear
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopConstraint)
            
            InputTextView(labelText: "О себе", text: $viewModel.shortInfo.about,
                          placeholder: "Расскажите о себе...")
                .padding(.top, getRelativeHeight(30))
            
            Text("Опыт работы")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(20.0), alignment: .leading)
                .padding(.top, getRelativeHeight(20))
            
            TextField("", value: $viewModel.shortInfo.experience, format: .number)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .foregroundColor(ColorConstants.WhiteA700)
                .padding()
                .placeholder(when: viewModel.shortInfo.experience == nil, placeholder: {
                    Text("Опыт работы в годах...").foregroundColor(Color.gray).padding()
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                })
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(ColorConstants.Bluegray800))
                .padding(.bottom, getRelativeHeight(20))
            
            InputTextField(labelText: "Дополнительная информация", text: $viewModel.shortInfo.additionalInfo, placeholder: "Написать...")
            
            Spacer()
            
            Button(action: { viewModel.passShortInfo() }, label: {
                Text(viewModel.infoEmpty() ? "Пропустить" : "Отправить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}

