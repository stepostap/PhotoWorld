//
//  ResetPasswordEmailView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI

struct ResetPasswordEmailView<model>: View where model: EnterEmailViewModelIO {
    @ObservedObject var viewModel: model
    
    var body: some View {
        VStack {
            VStack {
                Text("Введите вашу почту и мы отправим вам код для подтверждения сброса пароля")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343), alignment: .topLeading)
                    .padding()
                InputTextField(text: $viewModel.email, inputState: $viewModel.emailInputState, placeholder: "name@example.com")
            }.padding([.top], getRelativeHeight(EdgeInsets.SafeAreaTopConstraint))
            
            Spacer()
            
            Button(action: { viewModel.sendCode() }, label: {
                Text("Отправить")
            })
                .disabled(viewModel.email.isEmpty)
                .buttonStyle(MainButtonStyle(backgoundColor: !viewModel.email.isEmpty ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(ColorConstants.Bluegray900)
            .ignoresSafeArea()
    }
}
