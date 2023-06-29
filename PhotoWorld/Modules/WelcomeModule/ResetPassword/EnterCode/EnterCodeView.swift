////
////  EnterCodeView.swift
////  PhotoWorld
////
////  Created by Stepan Ostapenko on 19.04.2023.
////
//
//import Foundation
//import SwiftUI
//
//struct ResetPasswordCodeView: View {
//    @ObservedObject var viewModel: EnterCodeViewModel
//    let myStyle = CodeVerifierStyle(lineWidth: 20, lineHeight: 2, labelWidth: 20, labelHeight: 30, labelSpacing: 15, lineTextSpacing: 5, background: ColorConstants.Bluegray800)
//    
//    var body: some View {
//        VStack {
//            VStack {
//                HStack {
//                    Text("На вашу почту").foregroundColor(ColorConstants.WhiteA700)
//                    Text(viewModel.email).foregroundColor(Color.blue)
//                }
//                .frame(width: getRelativeWidth(343), alignment: .topLeading)
//                
//                Text("отправлен код подтверждения регистрации")
//                    .foregroundColor(ColorConstants.WhiteA700)
//                    .frame(width: getRelativeWidth(343), alignment: .topLeading)
//                    .padding([.bottom], getRelativeHeight(10))
//                
//                SecureCodeVerifier(fieldNumber: 6, style: myStyle, code: $viewModel.insertedCode)
//                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
//                    .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
//                                .stroke(ColorConstants.Bluegray800, lineWidth: 1))
//                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
//                                               bottomRight: 8.0)
//                                    .fill(ColorConstants.Bluegray800))
//                    .padding([.bottom], getRelativeHeight(10))
//                
//                if viewModel.codeEnterState == .invalid {
//                    HStack {
//                        Text("Код неверный")
//                            .foregroundColor(ColorConstants.Red400)
//                        Image("inputError")
//                    }.frame(width: getRelativeWidth(343), alignment: .topLeading)
//                }
//                
//                if viewModel.timeTillNewCode <= 0 {
//                    Button(action: { viewModel.requestNewCode() }, label: {
//                        Text("Отправить код повторно")
//                    })
//                    .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.WhiteA700, textColor: ColorConstants.Bluegray800))
//                } else {
//                    Text("Запросить код повторно через 00:\(viewModel.timeTillNewCode < 10 ? "0" : "")\(viewModel.timeTillNewCode)")
//                        .foregroundColor(ColorConstants.WhiteA700)
//                        .frame(width: getRelativeWidth(343), alignment: .topLeading)
//                }
//            }.padding([.top], getRelativeHeight(EdgeInsets.SafeAreaTopConstraint))
//            
//            Spacer()
//            
//            Button(action: { viewModel.sendPassword() }, label: {
//                Text("Отправить")
//            })
//                .disabled(!viewModel.canSend())
//                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.canSend() ?
//                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
//                                             textColor: ColorConstants.WhiteA700))
//                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
//        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            .background(ColorConstants.Bluegray900)
//            .ignoresSafeArea()
//    }
//}
//
