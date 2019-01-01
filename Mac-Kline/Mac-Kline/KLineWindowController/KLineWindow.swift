//
//  KLineWindow.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/26.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa

class KLineWindow: NSWindow {

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        NotificationCenter.default.addObserver(self, selector: #selector(windowBoundsChanged(_:)), name: NSWindow.didResizeNotification, object: self)
    }
    @objc func windowBoundsChanged(_ notification: NSNotification) {
    }
    
}
