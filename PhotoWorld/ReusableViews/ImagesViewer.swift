//
//  ImagesViewer.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct ImagesViewer: View {
    var imageURLS: [URL]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView {
                ForEach(imageURLS, id: \.self) { url in
                    KFImage(url)
                        .resizable()
                        .placeholder({Loader()})
                        .aspectRatio(contentMode: .fit)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }
}
