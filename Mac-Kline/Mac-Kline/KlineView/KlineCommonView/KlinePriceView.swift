//
//  KlinePriceView.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa
import SnapKit

class KlinePriceView: NSView {

    let priceLabelHeight:CGFloat = 30
   var priceLabelArr:Array = [NSLabel]()
   var priceArr:Array = [String]()
   lazy var currentPositionPriceLabel:NSTextField = {
        let lab = NSTextField()
        lab.wantsLayer = true
        lab.backgroundColor = NSColor.clear
        lab.font = NSFont.PingFang.regular.font(9)
        lab.isEditable = false
        lab.isBordered = false
        return lab
    }()
    lazy var zeroLabel:NSTextField = {
        let lab = NSTextField()
        lab.wantsLayer = true
        lab.textColor = NSColor.black
        lab.backgroundColor = NSColor.clear
        lab.isEditable = false
        lab.isBordered = false
        lab.font = NSFont.PingFang.regular.font(9)
        return lab
    }()
    init(frame: CGRect, PriceArr:[String]) {
        super.init(frame: frame)
        priceArr = PriceArr
        creatPriceLabel()
        creatCurrentPositionPriceLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func creatPriceLabel() {
        let intervalSpace: CGFloat = frame.size.height / (CGFloat)(priceArr.count - 1)
        for i in 0..<priceArr.count {
            let priceLabel = NSLabel()
            priceLabel.backgroundColor(backColor: NSColor.clear)
            priceLabel.textColor = NSColor.white
            priceLabel.font = NSFont.systemFont(ofSize: 9)
            priceLabel.textAlignment = .left
            priceLabel.lineBreakMode = .byWordWrapping
            priceLabel.text = priceArr[i]
            priceLabel.frame = CGRect(x: 4.0, y: intervalSpace * (CGFloat)(i) - (CGFloat)(priceLabelHeight / 2), width: frame.size.width - 4, height: (CGFloat)(priceLabelHeight))
            priceLabelArr.append(priceLabel)
            addSubview(priceLabel)
        }
    }
    
    func creatCurrentPositionPriceLabel() {
        addSubview(currentPositionPriceLabel)
        currentPositionPriceLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(4)
            make.height.equalTo(priceLabelHeight)
        }
        currentPositionPriceLabel.isHidden = true
    }
    
    func creatXZeroLabel() {
        addSubview(zeroLabel)
        zeroLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(4)
            make.height.equalTo(priceLabelHeight)
        }
        zeroLabel.isHidden = true
    }
    
    open func updateFrameWithHeight(height:CGFloat) {
        let intervalSpace = height / (CGFloat)(self.priceArr.count-1)
        for (idex,label) in self.priceLabelArr.enumerated() {
            label.snp.updateConstraints { (make) in
                if idex == 0 {
                    make.top.equalToSuperview()
                } else if idex == priceLabelArr.count - 1 {
                    make.bottom.equalToSuperview()
                } else {
                    make.top.equalToSuperview().offset(intervalSpace * (CGFloat)(idex) - priceLabelHeight / 2.0)
                }
                make.width.equalTo(priceWidth)
            }
        }
    }
    
    open func reloadPriceWithPriceArr(priceArr:[String], precision:Int) {
        for (idex,label) in priceLabelArr.enumerated() {
            label.text = priceArr[idex].precision(precision: precision)
        }
    }
    
    open func refreshCurrentPositionPricePositonY(positionY: CGFloat, price: String) {
        zeroLabel.isHidden = false
        zeroLabel.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(positionY-priceLabelHeight/2))
        }
        zeroLabel.stringValue = price
    }
    
    open func hideZeroLabel(isHide: Bool) {
        if isHide {
            zeroLabel.isHidden = true
        } else {
            zeroLabel.isHidden = false
        }
    }
    
    open func refreshCurrentPositionPrice(price: String) {
        zeroLabel.stringValue = price
    }
    
    open func hideCurrentPositionPriceLabel() {
        currentPositionPriceLabel.isHidden = true
    }
}
