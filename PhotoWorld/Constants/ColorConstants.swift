//
//  ColorConstants.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.04.2023.
//

import Foundation
import SwiftUI

struct ColorConstants {
    static let Bluegray900: Color = .init("Bluegray900")
    static let Gray600: Color = .init("Gray600")
    static let Bluegray800: Color = .init("Bluegray800")
    static let Bluegray700: Color = .init("Bluegray700")
    static let Blue800: Color = .init("Blue800")
    static let BlueA700: Color = .init("BlueA700")
    static let Bluegray300: Color = .init("Bluegray300")
    static let Gray900: Color = .init("Gray900")
    static let Green800: Color = .init("Green800")
    static let GreenA100: Color = .init("GreenA100")
    static let Bluegray100: Color = .init("Bluegray100")
    static let BlueA200: Color = .init("BlueA200")
    static let Red400: Color = .init("Red400")
    static let WhiteA700: Color = .init("WhiteA700")
    static let AcceptText: Color = .init("AcceptTextColor")
    static let AcceptBackground: Color = .init("AcceptBackground")
    static let PendingBackground: Color = .init("PendingBackground")
    static let PendingTextColor: Color = .init("PendingTextColor")
    static let DeclineBackground: Color = .init("DeclineBackground")
    static let DeclineTextColor: Color = .init("DeclineTextColor")
}

class FontScheme: NSObject {
    static func kInterMedium(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kInterMedium, size: size)
    }

    static func kInterRegular(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kInterRegular, size: size)
    }

    static func fontFromConstant(fontName: String, size: CGFloat) -> Font {
        var result = Font.system(size: size)

        switch fontName {
        case "kInterMedium":
            result = self.kInterMedium(size: size)
        case "kInterRegular":
            result = self.kInterRegular(size: size)
        default:
            result = self.kInterMedium(size: size)
        }
        return result
    }

    enum FontConstant {
        /**
         * Please Add this fonts Manually
         */
        static let kInterMedium: String = "Inter-Medium"
        /**
         * Please Add this fonts Manually
         */
        static let kInterRegular: String = "InterRegular"
    }
}
