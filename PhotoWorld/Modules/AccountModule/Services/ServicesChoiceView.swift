//
//  ServicesChoiceView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import SwiftUI

struct ServicesChoiceView<Model>: View where Model: ServicesChoiceViewModelIO {
    @ObservedObject var viewModel: Model
    @State var progress = 0.25
    
    var body: some View {
        VStack {
//            ProgressView(value: progress)
//                .tint(Color.blue)
//                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                
            ScrollView {
                ForEach(0 ..< viewModel.servicesPresent.count, id: \.self) { index in
                    Toggle(isOn: $viewModel.servicesPresent[index].present) {
                        Text(viewModel.servicesPresent[index].serviceName)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .padding(.leading, 10)
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(30), alignment: .leading)
                    .toggleStyle(CheckboxStyle(size: .big))
                    .padding(.bottom, 20)
                }
            }.padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            Button(action: { viewModel.passChosenServices() }, label: {
                Text("Сохранить")
            })
                .disabled(!viewModel.servicesWereChosen())
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.servicesWereChosen() ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}
