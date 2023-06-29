//
//  ServiceCell.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.05.2023.
//

import Foundation
import SwiftUI

struct ServiceCell: View {
    let service: UserServiceInfo
    
    var body: some View {
        HStack {
            Text(service.serviceName)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .foregroundColor(ColorConstants.WhiteA700)
                .padding(.leading, getRelativeWidth(10))
            Spacer()
            Text(service.priceDescription() ?? "")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .foregroundColor(ColorConstants.WhiteA700)
                .padding(.trailing, getRelativeWidth(10))
        }
        .frame(width: getRelativeWidth(343), height: getRelativeHeight(40), alignment: .leading)
        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                   bottomRight: 8.0)
                        .fill(ColorConstants.Bluegray800))
    }
}
