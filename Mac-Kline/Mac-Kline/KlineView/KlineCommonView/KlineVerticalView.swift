//
//  KlineVerticalView.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

class KlineVerticalView: NSView {
    
    lazy var timeLabel: NSLabel = {
        let label = NSLabel()
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = NSColor.blueColor
        label.layer?.borderColor = NSColor.blueColor.cgColor
        label.layer?.borderWidth = 0.5
        label.font = NSFont.PingFang.regular.font(12)
        label.isHidden = true
        return label
    }()
    let timeLableheight:CGFloat = 20
    var vereticalLineLayer: CAShapeLayer?

    var candleChartHeight: CGFloat = 0
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        if oldSize.width <= 0 && oldSize.height <= 0 {
            return
        }
        candleChartHeight = oldSize.height - 20.0
        self.bounds.size.width = oldSize.width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        candleChartHeight = NSScreen.main!.frame.size.height - 20
        buildUI()
    }
    
    func buildUI() {
        buildVerticalLine()
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(timeLableheight)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(timeWidth)
        }
        timeLabel.text = "00:00"
    }
    
    func buildVerticalLine() {
        vereticalLineLayer?.removeFromSuperlayer()
        vereticalLineLayer = nil
        vereticalLineLayer = CAShapeLayer()
        let topPath:CGMutablePath = CGMutablePath()
        topPath.move(to: CGPoint(x: CGFloat(timeWidth / 2.0), y: 0))
        topPath.addLine(to: CGPoint(x: CGFloat(timeWidth / 2.0), y: (candleChartHeight - timeLableheight)))
        vereticalLineLayer?.lineWidth = 1
        vereticalLineLayer?.path = topPath
        vereticalLineLayer?.lineDashPattern = [3,4,10,4]
        vereticalLineLayer?.strokeColor = NSColor.blueColor.cgColor
        layer?.addSublayer(vereticalLineLayer!)
    }
    
    func updateTimeString(timeString: String) {
        timeLabel.text = timeString
        timeLabel.backgroundColor(backColor: NSColor.clear)
    }
    func updateTimeLeft(leftdistance: CGFloat) {
        timeLabel.snp.updateConstraints({ make in
            make.centerX.equalToSuperview().offset(leftdistance)
        })
    }
    func updateVerticalLine(heigh: CFloat) {
        candleChartHeight = CGFloat(heigh)
        buildVerticalLine()
        timeLabel.isHidden = false
    }
    override var isFlipped: Bool {
        get{return true}
        set {self.isFlipped = newValue}
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
