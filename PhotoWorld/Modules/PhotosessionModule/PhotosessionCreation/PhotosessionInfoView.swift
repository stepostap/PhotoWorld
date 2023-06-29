//
//  PhotosessionInfoView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import SwiftUI

struct PhotosessionInfoView:  View {
    private let passInfo: (PhotosessionShortInfo) -> Void
    public init(passInfo: @escaping (PhotosessionShortInfo) -> Void) {
        UITextView.appearance().backgroundColor = .clear
        self.passInfo = passInfo
    }
    
    @State var description = ""
    @State var name = ""
    @State var location = ""
    
    var body: some View {
        VStack {
            ProgressView(value: 0.5)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, getRelativeHeight(90))
            
            InputTextField(labelText: "Название фотосессии", text: $name, placeholder: "Название фотосессии...")
                .padding(.top, getRelativeHeight(30))
            
            InputTextView(labelText: "Описание", text: $description,
                          placeholder: "Расскажите об идее съемки...")
                .padding(.vertical, getRelativeHeight(20))
               
            InputTextField(labelText: "Место проведения", text: $location, placeholder: "Адрес...")
            
            Spacer()
            
            Button(action: {
                passInfo(PhotosessionShortInfo(name: name, description: description, location: location))
            }, label: {
                Text("Отправить")
            })
                .disabled(!infoFilled())
                .buttonStyle(MainButtonStyle(backgoundColor: infoFilled() ? ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
    
    func infoFilled() -> Bool {
        return !(name.isEmpty || description.isEmpty || location.isEmpty)
    }
}

