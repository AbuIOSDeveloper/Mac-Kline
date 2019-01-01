//
//  KLineWindowContrroler.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/26.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa

class KLineWindowContrroler: NSWindowController {

    lazy var Window: NSWindow? = {
        let frame: CGRect = CGRect(x: 0, y: 0, width: 1200, height: 650)
        let style: NSWindow.StyleMask = [.titled,.closable,.miniaturizable,.resizable]
        let back: NSWindow.BackingStoreType = .buffered
        let window: KLineWindow = KLineWindow(contentRect: frame, styleMask: style, backing: back, defer: false)
        window.minSize = NSSize(width: 1200, height: 650)
        window.title = "Mac版K线"
        window.windowController = self
        return window
    }()
        
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
        self.window = self.Window
        self.contentViewController = KLineController()
        self.window?.center()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
