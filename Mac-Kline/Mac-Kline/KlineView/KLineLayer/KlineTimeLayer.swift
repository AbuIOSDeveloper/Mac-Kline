//
//  KlineTimeLayer.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/31.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

class KlineTimeLayer: CAShapeLayer {
 
    var klineDataSource = [KLineModel]()
    var candleWidth:CGFloat = 0.0
    var height:CGFloat = 0.0
    var timeHight:CGFloat = 0
    var bottomMargin:CGFloat = 0.0
    var LineWidth:CGFloat = 0.0
    init(dataArr: [KLineModel], candleWidth: CGFloat, height: CGFloat, timeHight: CGFloat, bottomMargin: CGFloat, lineWidth: CGFloat) {
        super.init()
        self.klineDataSource = dataArr
        self.candleWidth = candleWidth
        self.height = height
        self.timeHight = timeHight
        self.bottomMargin = bottomMargin
        self.LineWidth = lineWidth
        drawTimeLayer()
    }
    func drawTimeLayer() {
        for (_,model) in self.klineDataSource.enumerated() {
            if model.isDrawDate {
                let textLayer = getTextLayer()
                textLayer.string = model.timeStr
                if model.highestPoint.x < 0.000000001 {
                    textLayer.frame = NSRect(x: 0, y: self.height - CGFloat(timeheight), width: 90, height: CGFloat(timeheight))
                } else {
                    textLayer.position = NSPoint(x: model.highestPoint.x + self.candleWidth, y: self.height - CGFloat(timeheight  / 2.0) - self.bottomMargin)
                    textLayer.bounds = NSRect(x: 0, y: 0, width: 90, height: CGFloat(timeheight))
                }
                self.addSublayer(textLayer)
            }
        }
    }
    
    func getTextLayer() -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.fontSize = 12
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.foregroundColor = NSColor.white.cgColor
        return textLayer
    }
    
    func getAxispLayer() -> CAShapeLayer {
        let axiLayer = CAShapeLayer()
        axiLayer.strokeColor = NSColor.colorWithHexString(hex: "#ededed").cgColor
        axiLayer.fillColor = NSColor.clear.cgColor
        return axiLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
