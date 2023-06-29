//
//  TestView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 11.04.2023.
//

import Foundation
import SwiftUI

struct RegistrationView<model>: View where model: RegViewModelIO {
    @ObservedObject var viewModel: model
    
    var body: some View {
        
        VStack {
            Text("Регистрация")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(24.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                       alignment: .topLeading)
                .padding()
            
            InputTextField(labelText: "Имя", text: $viewModel.name,
                           inputState: $viewModel.nameInputStatus,
                            placeholder: "Введите имя").padding([.bottom], getRelativeHeight(10.0))
            InputTextField(labelText: "Эл.почта", text: $viewModel.email,
                           inputState: $viewModel.emailInputStatus, placeholder: "email").padding([.bottom], getRelativeHeight(10.0))
            PasswordTextField(password: $viewModel.password,
                              status: $viewModel.passwordStatus, label: "Пароль").padding([.bottom], getRelativeHeight(10.0))
            PasswordTextField(password: $viewModel.repeatPassword,
                              status: $viewModel.passwordStatus, label: "Подтверждение пароля").padding([.bottom], getRelativeHeight(10.0))
            
            if viewModel.passwordStatus != .valid {
                Text(viewModel.passwordStatus.title)
                    .font(FontScheme.kInterRegular(size: getRelativeHeight(14.0)))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Red400)
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(15.0),
                           alignment: .topLeading)
                    .padding([.bottom], getRelativeHeight(10.0))
            }
            
            HStack {
                Toggle(isOn: $viewModel.rememberUser) {
                    Text("Запомнить пароль")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                }
                .toggleStyle(CheckboxStyle(size: .small))
            }
            .frame(width: getRelativeWidth(343), height: getRelativeHeight(35), alignment: .leading)
            .padding([.bottom], getRelativeHeight(10.0))
            
            Button(action: { viewModel.createAccount() }, label: {
                Text("Создать аккаунт")
            })
            .padding([.bottom], getRelativeHeight(10.0))
            .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.BlueA700, textColor: ColorConstants.WhiteA700))
            
//            Button(action: { viewModel.logInWithGoogle() }, label: {
//                HStack {
//                    Image("img_group_red_500")
//                        .resizable()
//                        .frame(width: getRelativeWidth(18.0),
//                               height: getRelativeWidth(18.0), alignment: .leading)
//                        .scaledToFit()
//                        .clipped()
//                        .padding(.vertical, getRelativeHeight(14.0))
//                    Text("Войти с помощью гугл")
//                }
//            })
//            .padding([.bottom], getRelativeHeight(10.0))
//            .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.WhiteA700, textColor: ColorConstants.Gray900))
//            
            HStack {
                Text("Уже есть аккаунт?")
                    .foregroundColor(Color.gray)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                Button(action: { viewModel.goToLogIn() }, label: {
                    Text("Войти")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                })
                .buttonStyle(.borderless)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}
