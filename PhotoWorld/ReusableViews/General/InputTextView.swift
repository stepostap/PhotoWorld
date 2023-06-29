//
//  InputTextView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 23.04.2023.
//

import Foundation
import SwiftUI

struct InputTextView: View {
    
    var labelText: String? = nil
    @Binding var text: String
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
    
    var body: some View {
        VStack {
            if let labelText = labelText {
                Text(labelText)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(20.0), alignment: .leading)
            }
            HStack {
                TextEditor(text: $text)
                    .multilineTextAlignment(.leading)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeholder).foregroundColor(Color.gray)
                            .padding(.top, getRelativeHeight(22))
                            .padding(.leading, getRelativeWidth(20))
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .frame(width: getRelativeWidth(343), height: getRelativeHeight(200), alignment: .topLeading)
                    })
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(200), alignment: .leading)
                if status != .valid {
                    Image("inputError").padding()
                }
            }
            .frame(width: getRelativeWidth(343), height: getRelativeHeight(200.0), alignment: .center)
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
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(15.0),
                           alignment: .topLeading)
            }
        }
    }
}
