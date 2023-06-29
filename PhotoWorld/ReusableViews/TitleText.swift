//
//  TitleText.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import SwiftUI


struct TitleText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
            .fontWeight(.bold)
            .foregroundColor(ColorConstants.WhiteA700)
            .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                   alignment: .topLeading)
    }
}
