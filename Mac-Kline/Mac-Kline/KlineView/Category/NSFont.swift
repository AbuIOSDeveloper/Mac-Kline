//
//  NSFont.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa


extension NSFont {
    enum PingFang: String {
        case ultralight = "PingFangSC-Ultralight"
        case regular = "PingFangSC-Regular"
        case semibold = "PingFangSC-Semibold"
        case thin = "PingFangSC-Thin"
        case light = "PingFangSC-Light"
        case medium = "PingFangSC-Medium"
        
        public func font(_ size:CGFloat) -> NSFont {
            
            return NSFont(name: self.rawValue, size: size)!
        }
    }
}
