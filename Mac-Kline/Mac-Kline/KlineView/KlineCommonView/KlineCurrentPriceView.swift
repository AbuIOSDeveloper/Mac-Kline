//
//  KlineCurrentPriceView.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

class KlineCurrentPriceView: NSView {

    var isUpdate: Bool = false
    var horizontalLineLayer: CAShapeLayer!
    lazy var currentPriceLine: NSView = {
        let view = NSView()
        view.wantsLayer = true
        return view
    }()
    
    lazy var price: NSLabel = {
        let priceLabel = NSLabel()
        priceLabel.textAlignment = .left
        priceLabel.lineBreakMode = .byWordWrapping
        priceLabel.layer?.borderColor = NSColor.blueColor.cgColor
        priceLabel.layer?.borderWidth = 0.5
        priceLabel.textColor = NSColor.blueColor
        priceLabel.font = NSFont.PingFang.regular.font(12)
        priceLabel.backgroundColor(backColor: NSColor.clear)
        return priceLabel
    }()
    
     init(frame: CGRect, update: Bool) {
        super.init(frame: frame)
        isUpdate = update
        buildUI()
        addConstrains()
    }
    
    func buildUI() {
        addSubview(currentPriceLine)
        addSubview(price)
        self.currentPriceLine.backgroundColor(backColor: NSColor.clear)
        if isUpdate {
            self.currentPriceLine.layer!.addSublayer(creatLayerWithColor(color: NSColor.clear))
        }
    }
    
    func creatLayerWithColor(color: NSColor) -> CAShapeLayer {
        if horizontalLineLayer != nil {
            horizontalLineLayer.removeFromSuperlayer()
            horizontalLineLayer = nil
        }
        horizontalLineLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: NSScreen.main!.frame.size.width, y: 0))
        horizontalLineLayer.lineWidth = 2
        horizontalLineLayer.lineDashPattern = [3,4,10,4]
        horizontalLineLayer.path = path
        horizontalLineLayer.strokeColor = color.cgColor
        return horizontalLineLayer
    }
    
    func addConstrains() {
        currentPriceLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-priceWidth)
            make.left.equalToSuperview()
            make.height.equalTo(2)
            make.centerY.equalToSuperview()
        }
        price.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(timeheight)
            make.width.equalTo(priceWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    
    func updateNewPrice(newPrice: String, backgroundColor: NSColor, precision: Int) {
        let priceStr = newPrice.preciseDecimal(p: precision)
        price.text = priceStr
        price.textColor = backgroundColor
        currentPriceLine.backgroundColor(backColor: NSColor.clear)
        currentPriceLine.layer!.addSublayer(creatLayerWithColor(color: NSColor.blueColor))
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        if oldSize.width <= 0 && oldSize.height <= 0 {
            return
        }
        self.bounds.size.height = oldSize.height
        self.bounds.size.width = oldSize.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
