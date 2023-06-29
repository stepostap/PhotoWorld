//
//  ProgressView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 09.05.2023.
//

import Foundation
import SwiftUI

struct Loader: View {
    var body: some View {
        ProgressView()
            .tint(ColorConstants.Blue800)
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                            .fill(ColorConstants.Bluegray800))
    }
}
