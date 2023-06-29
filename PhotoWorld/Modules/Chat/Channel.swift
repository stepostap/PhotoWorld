//
//  Channel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 17.05.2023.
//

import Foundation
import SendbirdUIKit
import SendbirdChatSDK
import UIKit

class Channel: SBUGroupChannelViewController {
    var temp = SBUGroupChannelCellTheme()
}

class Themes {
    static let main: UIColor = UIColor(named: "Bluegray900")!
    static let white: UIColor = UIColor(named: "WhiteA700")!
    static let secondMain = UIColor(named: "Bluegray800")!
    
    static let channelTheme = SBUGroupChannelListTheme(backgroundColor:main)
    
    static let groupChannelCellTheme = SBUGroupChannelCellTheme(backgroundColor: main,
                                                                titleTextColor: white,
                                                                lastUpdatedTimeTextColor: white,
                                                                messageTextColor: white)
    
    static let messageTheme = SBUChannelTheme(navigationBarTintColor: main, navigationBarShadowColor: secondMain, leftBarButtonTintColor: white, rightBarButtonTintColor: white, backgroundColor: main)
    
    static let messageCellTheme = SBUMessageCellTheme(backgroundColor: main)
    static let inputTheme = SBUMessageInputTheme(backgroundColor: secondMain, textFieldBackgroundColor: main, textFieldTextColor: white)
    
    
    static let mainTheme = SBUTheme(groupChannelListTheme: channelTheme, groupChannelCellTheme: groupChannelCellTheme, openChannelListTheme: .dark, openChannelCellTheme: .dark, channelTheme: messageTheme, messageInputTheme: inputTheme, messageCellTheme: messageCellTheme, messageTemplateTheme: .dark, userListTheme: .dark, userCellTheme: .dark, channelSettingsTheme: .dark, userProfileTheme: .dark, componentTheme: .dark, messageSearchTheme: .dark, messageSearchResultCellTheme: .dark, createOpenChannelTheme: .dark, voiceMessageInputTheme: .dark)
    
}
