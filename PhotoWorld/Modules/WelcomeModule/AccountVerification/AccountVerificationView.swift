//
//  AccountVerification.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI

struct AccountVerificationView<model>: View where model: VerificationViewModelIO {
    @ObservedObject var viewModel: model
    let myStyle = CodeVerifierStyle(lineWidth: 20, lineHeight: 2, labelWidth: 20, labelHeight: 30, labelSpacing: 15, lineTextSpacing: 5, background: ColorConstants.Bluegray800)
    
    var body: some View {
        VStack {
            
            HStack {
                Text("На вашу почту").foregroundColor(ColorConstants.WhiteA700)
                Text(viewModel.email).foregroundColor(Color.blue)
            }
            .frame(width: getRelativeWidth(343), alignment: .topLeading)
            .padding([.top], getRelativeHeight(EdgeInsets.SafeAreaTopConstraint))
            
            Text("отправлен код подтверждения регистрации")
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343), alignment: .topLeading)
                .padding([.bottom], getRelativeHeight(10))
            
            SecureCodeVerifier(fieldNumber: 6, style: myStyle, code: $viewModel.insertedCode)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
                .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
                            .stroke(ColorConstants.Bluegray800, lineWidth: 1))
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(ColorConstants.Bluegray800))
                .padding([.bottom], getRelativeHeight(10))
            
            if viewModel.codeEnterState == .invalid {
                HStack {
                    Text("Код неверный")
                        .foregroundColor(ColorConstants.Red400)
                    Image("inputError")
                }.frame(width: getRelativeWidth(343), alignment: .topLeading)
            }
            
            if viewModel.timeTillNewCode <= 0 {
                Button(action: { viewModel.requestNewCode() }, label: {
                    Text("Отправить код повторно")
                })
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.WhiteA700, textColor: ColorConstants.Bluegray800))
            } else {
                Text("Запросить код повторно через 00:\(viewModel.timeTillNewCode < 10 ? "0" : "")\(viewModel.timeTillNewCode)")
                    .foregroundColor(Color.gray)
                    .frame(width: getRelativeWidth(343), alignment: .topLeading)
            }
                
            Spacer()
            
            Button(action: { viewModel.sendCode() }, label: {
                Text("Подтвердить")
            })
                .disabled(viewModel.insertedCode.count < 6)
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.insertedCode.count >= 6 ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(ColorConstants.Bluegray900)
            .ignoresSafeArea()
    }
}
