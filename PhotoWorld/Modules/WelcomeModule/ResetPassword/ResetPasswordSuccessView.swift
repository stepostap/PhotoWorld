//
//  ResetPasswordSuccess.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 20.04.2023.
//

import Foundation
import SwiftUI

struct ResetPasswordSuccessView:  View {
    
    var successButtonPressed: ()->Void
    
    var body: some View {
        VStack {
            Image("successTick")
                .resizable()
                .frame(width: getRelativeWidth(49.0), height: getRelativeWidth(49.0),
                       alignment: .center)
                .scaledToFit()
                .clipped()
            Text("Пароль изменен")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .multilineTextAlignment(.center)
                .frame(width: getRelativeWidth(144.0), height: getRelativeHeight(18.0),
                       alignment: .topLeading)
            
            Button(action: { successButtonPressed() }, label: {
                Text("Закрыть")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .multilineTextAlignment(.center)
                    .frame(width: getRelativeWidth(118.0), height: getRelativeHeight(48.0),
                           alignment: .center)
                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                               bottomRight: 8.0)
                            .fill(ColorConstants.BlueA700))
            })
                .frame(width: getRelativeWidth(118.0), height: getRelativeHeight(48.0),
                       alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                        .fill(ColorConstants.BlueA700))
                .padding()
            
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(ColorConstants.Bluegray900)
            .ignoresSafeArea()
    }
}
