//
//  MenuConfig.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/29.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

class MenuConfig: NSObject {
    var showBottomSeparator: Bool = false
    var spacingBetweenButtons: CGFloat = 20
    var titleFont: NSFont = NSFont.PingFang.medium.font(15)
    var titleColor: NSColor = NSColor.black
    var titleSelectedColor: NSColor = NSColor.red
    var indicatorColor: NSColor = NSColor.red
    var borderColor: NSColor = NSColor.red
    var borderSelectedColor: NSColor = NSColor.red
    var klineTypes: [KLINETYPE] = [KLINETYPE]()
}
