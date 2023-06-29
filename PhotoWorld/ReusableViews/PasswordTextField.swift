//
//  PasswordTextField.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.04.2023.
//

import Foundation
import SwiftUI

enum PasswordStatus {
        case valid
        case samePassword
        case weakPassword
        case empty
    }

extension PasswordStatus {
    var title: String {
        get {
            switch self {
            case .valid:
                return ""
            case .samePassword:
                return "Пароли не совпадают"
            case .weakPassword:
                return "Пароль слишком слабый"
            case .empty:
                return "Требуется ввести пароль"
            }
        }
    }
}

enum Focus {
    case plain
    case secure
}

struct PasswordTextField: View {
    @State private var showPassword: Bool = false
    @Binding var password:  String
    @Binding var status: PasswordStatus
    @FocusState private var focusedField: Focus?
    var label: String? = nil
    
    var body: some View {
        VStack {
            if let labelText = label {
                Text(labelText)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(getRelativeWidth(343)), height: getRelativeHeight(20.0), alignment: .leading)
                    .padding([.leading], getRelativeWidth(50))
            }
            HStack {
                secureField()
                if status == .valid {
                    seePasswordButton()
                } else {
                    Image("inputError").padding()
                }
            }
            .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(45.0), alignment: .center)
            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
                        .stroke(status == .valid ? ColorConstants.Bluegray800 : ColorConstants.Red400, lineWidth: 1))
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                            .fill(ColorConstants.Bluegray800))
        }
    }
    
    @ViewBuilder
    func seePasswordButton() -> some View {
        Button(action: {
            self.showPassword.toggle()
            focusedField = showPassword ? .plain : .secure
        }, label: {
            Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                .padding()
        })
    }
    
    @ViewBuilder
        func secureField() -> some View {
            if self.showPassword {
                TextField("Password", text: $password)
                    .focused($focusedField, equals: .plain)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(status == .valid ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                    .padding()
                    .keyboardType(.default)
                    .onChange(of: password, perform: { _  in status = .valid })
                    .placeholder(when: password.isEmpty, placeholder: {
                        Text("Введите пароль").foregroundColor(Color.gray).padding()
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    })
                    
            } else {
                SecureField("Password", text: $password)
                    .focused($focusedField, equals: .secure)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(status == .valid ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                    .padding()
                    .keyboardType(.default)
                    .onChange(of: password, perform: { _  in status = .valid })
                    .placeholder(when: password.isEmpty, placeholder: {
                        Text("Введите пароль").foregroundColor(Color.gray).padding()
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    })
            }
        }
}
