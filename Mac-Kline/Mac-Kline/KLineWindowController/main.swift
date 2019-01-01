//
//  main.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/26.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Foundation
import Cocoa

func mainMenu() -> NSMenu {
    let    mainMenu             =    NSMenu()
    let    mainAppMenuItem      =    NSMenuItem(title: "Application", action: nil, keyEquivalent: "")
    let    mainFileMenuItem     =    NSMenuItem(title: "File", action: nil, keyEquivalent: "")
    mainMenu.addItem(mainAppMenuItem)
    mainMenu.addItem(mainFileMenuItem)
    
    let    appMenu              =    NSMenu()
    mainAppMenuItem.submenu     =    appMenu
    
    let    appServicesMenu      =    NSMenu()
    NSApp.servicesMenu          =    appServicesMenu
    appMenu.addItem(withTitle: "About", action: nil, keyEquivalent: "")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Preferences...", action: nil, keyEquivalent: ",")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Hide", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
    appMenu.addItem({ ()->NSMenuItem in
        let m = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        m.keyEquivalentModifierMask = NSEvent.ModifierFlags([.command, .option])
        return m
        }())
    appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
    
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Services", action: nil, keyEquivalent: "").submenu    =    appServicesMenu
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    
    let    fileMenu             =    NSMenu(title: "File")
    mainFileMenuItem.submenu    =    fileMenu
    fileMenu.addItem(withTitle: "New...", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "n")
    
    return mainMenu
}

autoreleasepool {
    let app =   NSApplication.shared
    let delegate = AppDelegate()
    app.delegate =  delegate
    app.mainMenu = mainMenu()
    app.run()
}

