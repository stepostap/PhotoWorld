//
//  ChannelList.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 17.05.2023.
//

import Foundation
import SendbirdUIKit
import SendbirdChatSDK
import UIKit
import SwiftUI

extension Color {
 
    func uiColor() -> UIColor {

        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

class Header: SBUGroupChannelListModule.Header {
    override func setupViews() {
        let title = createCustomTitleLabel()
//        title.largeContentTitle = "Мэссенджер"
//        title.tintColor = UIColor.white
//        title.showsLargeContentViewer = true
        self.titleView = title
    }
    
    func createCustomTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = "Мэссенджер"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }
}


class CustomGroupChannel: SBUGroupChannelViewController {
    
}


class asd: SBUGroupChannelListViewController {
    override func showChannel(channelURL: String, messageListParams: MessageListParams? = nil) {
        // If you want to use your own ChannelViewController, you can override and customize it here.
        let vc = SBUGroupChannelViewController(channelURL: channelURL)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override init() {
        super.init()
        //self.headerComponent?.titleView = self.createCustomTitleLabel()
    }
    
    @objc @MainActor required init(channelListQuery: GroupChannelListQuery? = nil) {
        super.init(channelListQuery: channelListQuery)
    }
    
    
    
    override func setupStyles() {
        self.setupNavigationBar(backgroundColor: ColorConstants.Bluegray900.uiColor(),
                                shadowColor: ColorConstants.Bluegray900.uiColor())
//
//        let theme = SBUGroupChannelListTheme(navigationBarTintColor: UIColor.red,
//                                              backgroundColor: UIColor.blue)
//        self.listComponent?.setupStyles(theme: SBUGroupChannelListTheme.dark)
//        self.headerComponent?.setupStyles(theme: SBUGroupChannelListTheme.dark)
    }
    
    open override func setupViews() {

//        self.listComponent?.configure(delegate: self, dataSource: self, theme: SBUGroupChannelListTheme.dark)

        self.headerComponent = Header()
//        self.headerComponent?.configure(delegate: self, theme: SBUGroupChannelListTheme.dark)
//
//        self.loadChannelTypeSelector()

        super.setupViews()
    }
}
