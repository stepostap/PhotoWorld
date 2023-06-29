//
//  CustomSegmentController.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 15.05.2023.
//

import Foundation
import SwiftUI

struct CustomSegmentController: View {
    var choiceOptions: [String]
    var selected: Binding<Int>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<choiceOptions.count, id: \.self) { index in
                    makeButton(index: index)
                }
            }
        }
    }
    
    @ViewBuilder func makeButton(index: Int) -> some View {
        Button(action: { selected.wrappedValue = index }, label: {
            Text(choiceOptions[index])
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .fontWeight(.medium)
                .padding(getRelativeWidth(7))
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(height: getRelativeHeight(25.0), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(index == selected.wrappedValue ? ColorConstants.Blue800 : ColorConstants.Bluegray900))
        })
    }
}
