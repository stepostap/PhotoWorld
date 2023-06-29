//
//  CodeLabel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI

//public extension EnvironmentValues {
//    var secureCodeStyle: CodeVerifierStyle {
//        get { return self[CodeVerifierStyle.self] }
//        set { self[CodeVerifierStyle.self] = newValue }
//    }
//}

/// The smallest view in the verifier.
/// Contains the text label and the blinking carrier when needed
struct CodeLabel: View {
    @EnvironmentObject var style: CodeVerifierStyle
    let labelState: CodeLabelState
    
    private var lineColor: Color = .clear
    private var textColor: Color = .clear
    
    init(state: CodeLabelState) {
        self.labelState = state
//        self.lineColor = state.showingError ? style.errorLineColor : style.normalLineColor
//        self.textColor = state.showingError ? style.errorTextColor : style.normalTextColor
        self.lineColor = Color.gray
        self.textColor = ColorConstants.WhiteA700
    }
    
    public var body: some View {
        VStack(spacing: style.lineTextSpacing) {
            Text(labelState.textLabel)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: style.labelWidth, height: style.labelHeight, alignment: .center)
            Rectangle()
                .frame(width: style.lineWidth, height: style.lineHeight)
                .foregroundColor(lineColor)
        }
    }
}
