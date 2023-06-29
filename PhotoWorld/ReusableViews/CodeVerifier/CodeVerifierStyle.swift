//
//  CodeVerifierStyle.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI

class CodeVerifierStyle: ObservableObject {
    internal init(lineWidth: CGFloat, lineHeight: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat, labelSpacing: CGFloat, lineTextSpacing: CGFloat, background: Color) {
        self.lineWidth = lineWidth
        self.lineHeight = lineHeight
        self.labelWidth = labelWidth
        self.labelHeight = labelHeight
        self.labelSpacing = labelSpacing
        self.lineTextSpacing = lineTextSpacing
        self.background = background
    }    
    
    var lineWidth: CGFloat
    var lineHeight: CGFloat
    var labelWidth: CGFloat
    var labelHeight: CGFloat
    var labelSpacing: CGFloat
    var lineTextSpacing: CGFloat
    var background: Color
}
