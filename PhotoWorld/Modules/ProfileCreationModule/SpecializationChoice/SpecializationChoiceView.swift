//
//  SpecializationChoiceView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import Foundation
import SwiftUI

struct SpecializationChoiceView<T: SpecializationChoiceViewModelIO>:  View {
    @ObservedObject var viewModel: T
    @State var progress = 0.25
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopConstraint)
            ScrollView {
                Text("Ваша специализация")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(22), alignment: .leading)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .padding(.bottom, getRelativeHeight(10))
                Text("Специалисты видят его и могут присылать свои предложения")
                    .foregroundColor(Color.gray)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(40), alignment: .leading)
//                ForEach(viewModel.specializations) { index in
//                    Toggle(isOn: index.$present) {
//                        Text(index.specialization)
//                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
//                            .foregroundColor(ColorConstants.WhiteA700)
//                            .padding(.leading, 10)
//                    }
//                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(30), alignment: .leading)
//                    .toggleStyle(CheckboxStyle(size: .big))
//                    .padding(.bottom, 20)
//                }
                ForEach(0 ..< viewModel.specializations.count, id: \.self) { index in
                    Toggle(isOn: $viewModel.specializations[index].present) {
                        Text(viewModel.specializations[index].specialization)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .padding(.leading, 10)
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(30), alignment: .leading)
                    .toggleStyle(CheckboxStyle(size: .big))
                    .padding(.bottom, 20)
                }
            }.padding(.top, getRelativeHeight(15))
            
            Button(action: { viewModel.passChosenSpecs() }, label: {
                Text("Отправить")
            })
                .disabled(!viewModel.specsChosen)
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.specsChosen ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}
