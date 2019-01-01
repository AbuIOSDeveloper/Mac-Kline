//
//  AppDelegate.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/18.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var windowController: KLineWindowContrroler = {
        let windowController = KLineWindowContrroler()
        return windowController
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
   
       self.windowController.showWindow(self)
   
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    @objc func windowBoundsChanged(_ notification: NSNotification) {
    
  }


}

