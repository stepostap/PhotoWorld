//
//  ProfileChoiceView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import SwiftUI

struct ProfileChoiceView<T: ProfileChoiceFlowCoordinatorIO>: View {
//    private let chooseProfile: (ProfileType) -> Void
//
//    public init(chooseProfile: @escaping (ProfileType) -> Void) {
//        self.chooseProfile = chooseProfile
//    }
    
    let viewModel: ProfileChoiceViewModel<T>
    
    var body: some View {
        VStack {
            Image("profileChoiceImg")
                .resizable()
                .frame(width: getRelativeWidth(320.0), height: getRelativeHeight(252.0),
                       alignment: .center)
                .scaledToFit()
                .clipped()
                .padding(.trailing, getRelativeWidth(35))
            Text("Чем вы планируете заниматься?")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(24.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .multilineTextAlignment(.center)
                .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(65.0),
                       alignment: .center)
                .padding()
                
            Button(action: { viewModel.chooseProfile(type: .photographer) }, label: {
                HStack {
                    Image("icon_camera")
                        .resizable()
                        .frame(width: getRelativeWidth(20.0),
                               height: getRelativeHeight(20.0), alignment: .leading)
                        .scaledToFill()
                        .padding(.horizontal, getRelativeWidth(15))
                        .clipped()
                    Text("Фотограф")
                }.frame(maxWidth: .infinity, alignment: .leading)
            })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.Bluegray800, textColor: ColorConstants.WhiteA700))
            
            Button(action: { viewModel.chooseProfile(type: .model) }, label: {
                HStack {
                    Image("icon_model")
                        .resizable()
                        .frame(width: getRelativeWidth(20.0),
                               height: getRelativeHeight(20.0), alignment: .leading)
                        .scaledToFill()
                        .padding(.horizontal, getRelativeWidth(15))
                        .clipped()
                    Text("Модель")
                }.frame(maxWidth: .infinity, alignment: .leading)
            })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.Bluegray800, textColor: ColorConstants.WhiteA700))
            
            Button(action: { viewModel.chooseProfile(type: .stylist) }, label: {
                HStack {
                    Image("icon_stylist")
                        .resizable()
                        .frame(width: getRelativeWidth(20.0),
                               height: getRelativeHeight(20.0), alignment: .leading)
                        .scaledToFill()
                        .padding(.horizontal, getRelativeWidth(15))
                        .clipped()
                    Text("Визажист")
                }.frame(maxWidth: .infinity, alignment: .leading)
            })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.Bluegray800, textColor: ColorConstants.WhiteA700))
            
//            Button(action: { viewModel.chooseProfile(type: .viewer) }, label: {
//                Text("Пропустить")
//                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
//            })
//                .padding(.top, getRelativeHeight(30))
//                .buttonStyle(.borderless)

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}
