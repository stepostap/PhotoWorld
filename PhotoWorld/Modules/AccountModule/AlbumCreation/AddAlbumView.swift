//
//  AddAlbumView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import SwiftUI

enum AlbumVisibility: CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .friendsOnly:
            return "Только друзья"
        case .open:
            return "Все пользователи"
        case .closed:
            return "Только я"
        }
    }
    
    var networkTitle: String {
        switch self {
        case .friendsOnly:
            return ""
        case .open:
            return ""
        case .closed:
            return ""
        }
    }
    
    case friendsOnly
    case open
    case closed
}

struct AddAlbumView:  View {
    private let passInfo: ((name: String, visibility: AlbumVisibility)) -> Void
    public init(passInfo: @escaping ((name: String, visibility: AlbumVisibility)) -> Void) {
        UITextView.appearance().backgroundColor = .clear
        self.passInfo = passInfo
    }
    
    @State var name = ""
    @State var albumVisibility: AlbumVisibility?
    
    var body: some View {
        VStack {
            ProgressView(value: 0.5)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            InputTextField(labelText: "Название альбома", text: $name, placeholder: "Название фотосессии...")
                .padding(.vertical, getRelativeHeight(15))
            
            Text("Кто может просматривать этот альбом")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(20.0), alignment: .leading)
                .padding(.top, getRelativeHeight(10))
      
            RadioButtonGroup(selection: $albumVisibility,
                             orientation: .vertical,
                             tags: AlbumVisibility.allCases,
                             button: { isSelected in
                ZStack {
                    if isSelected {
                        Circle()
                            .foregroundColor(ColorConstants.Blue800)
                            .frame(width: getRelativeWidth(18), height: getRelativeWidth(18))
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: getRelativeWidth(10), height: getRelativeWidth(10))
                    
                    } else {
                        Circle()
                            .stroke(ColorConstants.Bluegray800, lineWidth: 1)
                            .foregroundColor(ColorConstants.Bluegray900)
                            .frame(width: getRelativeWidth(18), height: getRelativeWidth(18))
                    }
                    
                }
            },
                             label: { tag in
                Text("\(tag.description)")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .padding(getRelativeHeight(10))
            })
                .frame(width: getRelativeWidth(343), alignment: .leading)

            Spacer()
            
            Button(action: {
                passInfo((name: name, visibility: albumVisibility!))
            }, label: {
                Text("Продолжить")
            })
                .disabled(!infoFilled())
                .buttonStyle(MainButtonStyle(backgoundColor: infoFilled() ? ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
    }
    
    func infoFilled() -> Bool {
        return !(name.isEmpty || albumVisibility == nil)
    }
}

