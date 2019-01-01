//
//  KlineCandelLayer.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

class KlineCandelLayer: CAShapeLayer {
    var klineDataSource = [KLineModel]()
    var CandleWidth:CGFloat = 0.0
    var CandleSpace:CGFloat = 0.0
    var StartIndex:CGFloat = 0
    var MaxValue:CGFloat = 0.0
    var HeightPerpoint:CGFloat = 0.0
    var ContentWidth:CGFloat = 0.0
    init(dataArr: [KLineModel], candleWidth: CGFloat, candleSpace: CGFloat, startIndex: CGFloat,maxValue: CGFloat, heightPerpoint: CGFloat,contentWidth: CGFloat) {
        super.init()
        klineDataSource = dataArr
        CandleWidth = candleWidth
        CandleSpace = candleSpace
        StartIndex = startIndex
        MaxValue = maxValue
        HeightPerpoint = heightPerpoint
        ContentWidth = contentWidth
        convertToKlinePositionDataArr()
        drawCandleSublayers()
    }
    
    func convertToKlinePositionDataArr() {
        for (index,model) in klineDataSource.enumerated() {
            let open = ((MaxValue - model.openPrice) * HeightPerpoint) + CGFloat(midDistance)
            let close = ((MaxValue - model.closePrice) * HeightPerpoint) + CGFloat(midDistance)
            let high = ((MaxValue - model.highPrice) * HeightPerpoint) + CGFloat(midDistance)
            let low = ((MaxValue - model.lowPrice) * HeightPerpoint) + CGFloat(midDistance)
            let left = CGFloat(StartIndex) + ((CandleWidth + CandleSpace) * CGFloat(index))
            model.opensPoint = CGPoint(x: left, y: open)
            model.closesPoint = CGPoint(x: left, y: close)
            model.highestPoint = CGPoint(x: left, y: high)
            model.lowestPoint = CGPoint(x: left, y: low)
        }
    }
    
    func getShaperLayer(model: KLineModel) -> CAShapeLayer {
        let candelLayer = CAShapeLayer()
        let open = model.opensPoint.y
        let close = model.closesPoint.y
        let high = model.highestPoint.y
        let low = model.lowestPoint.y
        let x = model.opensPoint.x + CandleWidth / 2.0
        candelLayer.lineWidth = 1
        let candelPath = CGMutablePath.drawKLine(open: open, close: close, high: high, low: low, candleWidth: CandleWidth, xPostion: x, lineWidth: self.lineWidth)
        candelLayer.fillColor = NSColor.clear.cgColor
        if model.opensPoint.y >= model.closesPoint.y {
            candelLayer.strokeColor = RISECOLOR.cgColor
            candelLayer.fillColor = RISECOLOR.cgColor
            
        } else {
            candelLayer.strokeColor = DROPCOLOR.cgColor
            candelLayer.fillColor = NSColor.clear.cgColor
        }
        candelLayer.path = candelPath
        return candelLayer
    }
    
    func drawCandleSublayers() {
        for (_,model) in klineDataSource.enumerated() {
            let subLayer = getShaperLayer(model: model)
            addSublayer(subLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
