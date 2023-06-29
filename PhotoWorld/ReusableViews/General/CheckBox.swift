//
//  Checkbox.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.04.2023.
//

import Foundation
import SwiftUI

enum CheckboxSize {
    case small
    case big
}

struct CheckboxStyle: ToggleStyle {
    var size: CheckboxSize
    private var sideLen: CGFloat {
        get {
            size == .small ? 16 : 24
        }
    }
    private var fontSize: CGFloat {
        get {
            size == .small ? 15 : 20
        }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(configuration.isOn ? ColorConstants.Blue800 : ColorConstants.Bluegray800)
                .frame(width: getRelativeWidth(sideLen), height: getRelativeHeight(sideLen), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(configuration.isOn ? ColorConstants.WhiteA700 : ColorConstants.Bluegray800))
            configuration.label
                .foregroundColor(configuration.isOn ? ColorConstants.WhiteA700 : Color.gray)
                .font(Font.system(size: fontSize))
        }
        .onTapGesture { configuration.isOn.toggle() }
    }
}
