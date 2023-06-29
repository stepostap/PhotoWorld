//
//  Tag.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.05.2023.
//

import Foundation
import SwiftUI

struct TagView: View {
    var text: String
    var color = ColorConstants.Blue800
    var textColor = ColorConstants.WhiteA700
    
    var body: some View {
        Text(text)
            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
            .fontWeight(.medium)
            .padding(getRelativeWidth(5))
            .foregroundColor(textColor)
            .frame(height: getRelativeHeight(25.0), alignment: .center)
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                            .fill(color))
    }
}
