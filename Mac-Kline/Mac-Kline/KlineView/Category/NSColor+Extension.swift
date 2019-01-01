//
//  NSColor+Extension.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

extension NSColor {
    
    open class var blackColor: NSColor {
        return NSColor.color(red: 35, green: 36, blue: 40)
    }

    open class var blueColor: NSColor {
        return  NSColor.color(red: 84, green: 140, blue: 249)
    }
    
    open class func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> NSColor {
        return NSColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    open class func colorWithHexString(hex hexStr: String, alpha: CGFloat = 1.0) -> NSColor {
        var hex: String = hexStr
        if (hex.hasPrefix("#")) {
            hex.remove(at: hex.startIndex)
        }
        
        let redStart = hex.index(hex.startIndex, offsetBy: 0)
        let redEnd   = hex.index(hex.startIndex, offsetBy: 2)
        let redStr: String = String(hex[redStart..<redEnd])
        
        let greenStart = hex.index(hex.startIndex, offsetBy: 2)
        let greenEnd   = hex.index(hex.startIndex, offsetBy: 4)
        let greenStr: String = String(hex[greenStart..<greenEnd])
        
        let blueStart = hex.index(hex.startIndex, offsetBy: 4)
        let blueEnd   = hex.index(hex.startIndex, offsetBy: 6)
        let blueStr: String = String(hex[blueStart..<blueEnd])
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        Scanner(string: redStr).scanHexInt32(&red)
        Scanner(string: greenStr).scanHexInt32(&green)
        Scanner(string: blueStr).scanHexInt32(&blue)
        return NSColor.color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
}
