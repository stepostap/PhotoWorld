//
//  LoginView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI

struct LoginView<model>: View where model: LoginViewModelIO{
    @ObservedObject var viewModel: model
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Text("Вход")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(24.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                       alignment: .topLeading)
                .padding()

            InputTextField(labelText: "Эл.почта", text: $viewModel.email,
                           inputState: $viewModel.emailInputStatus, placeholder: "email").padding([.bottom], getRelativeHeight(10.0))
            PasswordTextField(password: $viewModel.password,
                              status: $viewModel.passwordStatus, label: "Пароль").padding([.bottom], getRelativeHeight(10.0))

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
                Spacer()
                Button(action: { viewModel.forgotPassword() }, label: {
                    Text("Забыли пароль?")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                }).buttonStyle(.borderless)
            }
            .frame(width: getRelativeWidth(343), height: getRelativeHeight(35), alignment: .center)
            .padding([.bottom], getRelativeHeight(10.0))

            Button(action: {
                isLoading = true
                viewModel.logIn()
            }, label: {
                if isLoading {
                    Loader()
                } else {
                    Text("Войти")
                }
            })
            .disabled(isLoading)
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

            HStack {
                Text("Нет аккаунта?")
                    .foregroundColor(Color.gray)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                Button(action: { viewModel.createAccount() }, label: {
                    Text("Зарегистрироваться")
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

