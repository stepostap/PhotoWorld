//
//  InputTextField.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.04.2023.
//

import Foundation
import SwiftUI

enum InputTextFieldState: Equatable {
    case valid
    case invalid(String)
}

enum InputTextFieldSize: CGFloat {
    case big = 343
    case mid = 165
}

struct InputTextField: View {
    
    var labelText: String? = nil
    @Binding var text:  String
    var inputState: Binding<InputTextFieldState>?
    
    var status: InputTextFieldState {
        get {
            if let inputState = inputState {
                return inputState.wrappedValue
            } else {
                return .valid
            }
        }
    }
    
    var placeholder: String
    var size: InputTextFieldSize = .big
    private var sideLen: CGFloat {
        get {
            size == .big ? 343 : 160
        }
    }
    
    var body: some View {
        VStack {
            if let labelText = labelText {
                Text(labelText)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(sideLen), height: getRelativeHeight(20.0), alignment: .leading)
            }
            HStack {
                TextField("input", text: $text)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(status == .valid ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                    .autocorrectionDisabled(true)
                    .padding()
                    .onChange(of: text, perform: { _  in inputState?.wrappedValue = .valid })
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeholder).foregroundColor(Color.gray).padding()
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    })
                if status != .valid {
                    Image("inputError").padding()
                }
            }
            .frame(width: getRelativeWidth(sideLen), height: getRelativeHeight(45.0), alignment: .center)
            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
                        .stroke(status == .valid ? ColorConstants.Bluegray800 : ColorConstants.Red400, lineWidth: 1))
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                            .fill(ColorConstants.Bluegray800))
            if case .invalid(let error) = status {
                Text(error)
                    .font(FontScheme.kInterRegular(size: getRelativeHeight(14.0)))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Red400)
                    .frame(width: getRelativeWidth(sideLen), height: getRelativeHeight(15.0),
                           alignment: .topLeading)
            }
        }
    }
}
