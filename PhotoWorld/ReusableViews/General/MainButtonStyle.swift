//
//  Button.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.04.2023.
//

import Foundation
import SwiftUI

struct MainButtonStyle: ButtonStyle {

    var width = getRelativeWidth(343)
    var height = getRelativeHeight(48)
    var fontSize = 16.0
    var backgoundColor: Color
    var textColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(FontScheme.kInterMedium(size: getRelativeHeight(fontSize)))
            .foregroundColor(textColor)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .frame(width: width,
                   height: height, alignment: .center)
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0,
                                       bottomLeft: 8.0, bottomRight: 8.0)
                            .fill(backgoundColor))
            .padding(.top, getRelativeHeight(0.0))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
