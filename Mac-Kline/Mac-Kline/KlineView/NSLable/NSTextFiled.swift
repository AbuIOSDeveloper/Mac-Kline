//
//  NSTextFiled.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/27.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa



extension NSTextField {
    
    var text: String {
        get { return self.stringValue}
        set { self.stringValue = newValue }
    }
    var attributedText: NSAttributedString {
        get { return self.attributedStringValue}
        set { self.attributedStringValue = newValue}
    }
    
    var placeholder: String {
        get { return self.placeholderString!}
        set {self.placeholderString = newValue}
    }
}
