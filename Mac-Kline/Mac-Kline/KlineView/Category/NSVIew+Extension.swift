//
//  NSVIew+Extension.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

extension NSView {
    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return self.layer!.borderWidth
//        }
//        set {
//            self.layer!.borderWidth = newValue
//        }
//    }
//    
//    @IBInspectable
//    var borderColor: NSColor {
//        get {
//            return NSColor(cgColor: self.layer!.borderColor!)!
//        }
//        set {
//            self.layer!.borderColor = newValue.cgColor
//        }
//    }
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var bottomY: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set { self.frame.origin.y = newValue - self.frame.size.height }
    }
    
    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    func bringSubviewToFront(view: NSView) {
        view.removeFromSuperview()
        self.addSubview(view, positioned: .above, relativeTo: nil)
    }
    
    func sendSubviewToBack(view: NSView) {
        view.removeFromSuperview()
        self.addSubview(view, positioned: .below, relativeTo: nil)
    }
    
    func backgroundColor(backColor: NSColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = backColor.cgColor
    }
    
}
