//
//  KlineMenu.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/29.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa
protocol KlineMenuDelegate: NSObjectProtocol {
    func didSelectedIndex(klineType: KLINETYPE)
}
class KlineMenu: NSView {

    var config: MenuConfig?
    private var titles = [String]()
    var bottomLine = NSView()
    var selectIndex: Int = 0
    weak open var delegate: KlineMenuDelegate!
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    convenience init(frame: CGRect, titles: [String], config: MenuConfig) {
        self.init()
        self.config = config
        if titles.isEmpty {
            NSException(name: NSExceptionName(rawValue: "KlineMenu"), reason: "标题数组元素不能为0", userInfo: nil).raise()
        }
        self.titles = titles
        buildTitleButton()
    }
    
    func buildTitleButton() {
        let btnWidth = (NSScreen.main!.frame.size.width - 80 - CGFloat(priceWidth)) / CGFloat(self.titles.count)
        for (index,title) in self.titles.enumerated() {
            let btn = KlineButton(frame: .zero)
            btn.title = title
            btn.momentary = false
            if index == selectIndex {
                btn.setOn(true)
            } else {
                btn.setOn(false)
            }
            btn.tag = index + 1
            self.addSubview(btn)
            btn.addTarget(target: self, action: #selector(btnClick(_:)))
            btn.snp.makeConstraints { (make) in
                if index == 0 {
                    make.left.equalToSuperview()
                } else if index == self.titles.count - 1 {
                    make.right.equalToSuperview()
                } else {
                    make.left.equalToSuperview().offset(CGFloat(index) * btnWidth)
                    print(CGFloat(index) * btnWidth)
                }
                make.top.bottom.equalToSuperview()
                make.width.equalTo(btnWidth)
            }
            
            if let titleFont = self.config?.titleFont {
                btn.font = titleFont
            }
            btn.buttonColor = NSColor.clear
            btn.activeButtonColor = NSColor.clear
            if let titleColor = self.config?.titleColor {
                    btn.textColor = titleColor
                   
            }
            if let activeTextColor = self.config?.titleSelectedColor {
                btn.activeTextColor = activeTextColor
                
            }
            if let borderSelectedColor = self.config?.borderSelectedColor {
                    btn.activeBorderColor = borderSelectedColor
            }
        }
    }
    @objc func btnClick(_ sender: KlineButton) {
        if (sender.tag - 1) == selectIndex {
            sender.setOn(true)
            return
        }
        for (index,btn) in self.subviews.enumerated() {
            if btn is KlineButton {
                let selectBtn: KlineButton = btn as! KlineButton
                if index == sender.tag - 1 {
                    selectBtn.setOn(true)
                } else {
                    selectBtn.setOn(false)
                }
            }
        }
        selectIndex = sender.tag - 1
        
        if let klineTypes = self.config?.klineTypes {
            delegate.didSelectedIndex(klineType: klineTypes[selectIndex])
        }
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
}
