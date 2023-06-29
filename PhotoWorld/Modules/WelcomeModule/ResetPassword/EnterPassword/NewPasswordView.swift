//
//  EnterCodeView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation
import SwiftUI

struct ResetPasswordNewPasswordView<model: EnterNewPasswordViewModelIO>: View {
    @ObservedObject var viewModel: model
    
    var body: some View {
        VStack {
            VStack {
                Text("Укажите новый пароль для вашей страницы")
                    .multilineTextAlignment(.leading)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343), alignment: .topLeading)
                    .padding()
                
                PasswordTextField(password: $viewModel.password,
                                  status: $viewModel.passwordStatus, label: "Новый пароль").padding([.bottom], getRelativeHeight(10.0))
                PasswordTextField(password: $viewModel.repeatPassword,
                                  status: $viewModel.passwordStatus, label: "Подтверждение пароля").padding([.bottom], getRelativeHeight(10.0))
                
                if viewModel.passwordStatus != .valid {
                    Text(viewModel.passwordStatus.title)
                        .font(FontScheme.kInterRegular(size: getRelativeHeight(14.0)))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Red400)
                        .frame(width: getRelativeWidth(343), height: getRelativeHeight(15.0),
                               alignment: .topLeading)
                }
            }.padding([.top], getRelativeHeight(EdgeInsets.SafeAreaTopConstraint))
            
            Spacer()
            
            Button(action: { viewModel.sendPassword() }, label: {
                Text("Отправить")
            })
                .disabled(!viewModel.canSend())
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.canSend() ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(ColorConstants.Bluegray900)
            .ignoresSafeArea()
    }
}

