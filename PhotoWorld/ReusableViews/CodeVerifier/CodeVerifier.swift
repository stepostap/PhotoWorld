//
//  CodeVerifier.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI


/// Represents the list of all secure code fields
struct CodeView: View {
    @EnvironmentObject var style: CodeVerifierStyle
    var fields: [CodeLabelState]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: style.labelSpacing) {
            ForEach(fields) { labelState in
                CodeLabel(state: labelState)
            }
        }
    }
}


public struct SecureCodeVerifier: View {
    var style: CodeVerifierStyle
    @Binding var curCode: String
    @State private var insertedCode: String = ""
    @State private var isTextFieldFocused: Bool = true
    
    @StateObject private var viewModel: SecureCodeVerifierViewModel
    
    private var textfieldSize: CGSize = .zero
    
    private var action: ((Bool) -> Void)?
    
    init(fieldNumber: Int, style: CodeVerifierStyle, code: Binding<String>) {
        self._viewModel = StateObject(wrappedValue: SecureCodeVerifierViewModel(fieldNumber: fieldNumber))
        self.style = style
        let height = style.labelHeight + style.lineHeight + style.lineTextSpacing
        let width = (style.labelWidth * CGFloat(fieldNumber)) + (style.labelSpacing * CGFloat(fieldNumber))
        self.textfieldSize = CGSize(width: width, height: height)
        _curCode = code
    }
    
    public var body: some View {
        CodeView(fields: viewModel.fields)
            .background(
                Rectangle()
                    .foregroundColor(style.background)
            )
            .background(
                SecureTextfield(text: $insertedCode, isFocusable: $isTextFieldFocused, labels: viewModel.fieldNumber)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .frame(width: textfieldSize.width, height: textfieldSize.height)
            .padding()
            .onChange(of: insertedCode) { newValue in
                curCode = insertedCode
                viewModel.buildFields(for: newValue)
            }
            .onReceive(viewModel.$codeCorrect.dropFirst()) { value in
                action?(value)
            }
            .environmentObject(style)
    }
}

extension SecureCodeVerifier {
    public func onCodeFilled(perform action: ((Bool) -> Void)?) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}
