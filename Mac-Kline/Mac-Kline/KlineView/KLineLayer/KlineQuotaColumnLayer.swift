//
//  KlineQuotaColumnLayer.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

class KlineQuotaColumnLayer: CAShapeLayer {
    
    private let macdStartX = "macdStartX"
    private let macdStartY = "macdStartY"
    private let macdEndX = "macdEndX"
    private let macdEndY = "macdEndY"
    private let volStartX = "volStartX"
    private let volStartY = "volStartY"
    private let openPrice = "openPrice"
    private let closePrice = "closePrice"
    
    var klineDataSource = [KLineModel]()
    var CandleWidth: CGFloat = 0.0
    var CandleSpace: CGFloat = 0.0
    var StartIndex: CGFloat = 0
    var MaxValue: CGFloat = 0.0
    var MinValue: CGFloat = 0.0
    var HeightPerpoint: CGFloat = 0.0
    var QutoaHeight: CGFloat = 0.0
    var KlineSubOrMain: KlineIndexType = .MACD
    
    init(dataArr: [KLineModel], candleWidth: CGFloat, candleSpace: CGFloat, startIndex: CGFloat,maxValue: CGFloat,minValue: CGFloat, heightPerpoint: CGFloat, qutoaHeight: CGFloat, klineIndexype: KlineIndexType) {
        super.init()
        klineDataSource = dataArr
        CandleWidth = candleWidth
        CandleSpace = candleSpace
        StartIndex = startIndex
        MaxValue = maxValue
        MinValue = minValue
        HeightPerpoint = heightPerpoint
        QutoaHeight = qutoaHeight
        if klineIndexype == .MACD || klineIndexype == .MACD24 {
            drawMACDLayer(postions: coverMACDPostions())
        } else if klineIndexype == .VOL {
            drawVolLayer(postions: coverVOLPostions())
        }
    }
    func coverVOLPostions() ->[Dictionary<String, Double>] {
        var postions = [Dictionary<String, Double>]()
        for (index,model) in klineDataSource.enumerated() {
            var dict: Dictionary = Dictionary<String, Double>()
            let xPosition: CGFloat = CGFloat(StartIndex) + ((CandleWidth  + CandleSpace) * CGFloat(index)) + CandleWidth / 2.0
            let yPosition: CGFloat = (MaxValue - CGFloat(Double(model.volumn)!)) * HeightPerpoint
            dict[volStartX] = Double(xPosition)
            dict[volStartY] = Double(yPosition)
            dict[openPrice] = Double(model.openPrice)
            dict[closePrice] = Double(model.closePrice)
            let x = MaxValue  * HeightPerpoint - yPosition
            if macdIsEqualZero(value: Float(x)) {
                dict[volStartY] = Double(MaxValue * HeightPerpoint - 1)
            }
            postions.append(dict)
        }
        return postions
    }
    
    func drawVolLayer(postions: [Dictionary<String, Double>]) {
        for (_,dic) in postions.enumerated() {
            let strartX = dic[volStartX]
            let strartY = dic[volStartY]
            let open = dic[openPrice]
            let close = dic[closePrice]
            let rect:CGRect = CGRect(x: strartX!, y: strartY! + Double(QutoaHeight) + midDistance, width: Double(CandleWidth), height: Double((MaxValue - MinValue) * HeightPerpoint) - strartY!)
            let path = CGMutablePath.init()
            path.addRect(rect)
            let subLayer = CAShapeLayer()
            subLayer.path = path
            if open! > close! {
                subLayer.strokeColor = DROPCOLOR.cgColor
                subLayer.fillColor = DROPCOLOR.cgColor
            } else {
                subLayer.strokeColor = RISECOLOR.cgColor
                subLayer.fillColor = RISECOLOR.cgColor
            }
            addSublayer(subLayer)
        }
    }
    func coverMACDPostions() ->[Dictionary<String, Double>] {
        var postions = [Dictionary<String, Double>]()
        for (index,model) in klineDataSource.enumerated() {
            var dict: Dictionary = Dictionary<String, Double>()
            let xPosition: CGFloat = StartIndex + ((CandleWidth  + CandleSpace) * CGFloat(index)) + CandleWidth / 2.0
            let yPosition: CGFloat = abs((MaxValue - CGFloat(model.MACD))) / HeightPerpoint
            dict[macdEndX] = Double(xPosition)
            dict[macdEndY] = Double(xPosition)
            let strartPoint = CGPoint(x: xPosition, y: yPosition)
            dict[macdStartX] = Double(strartPoint.x)
            dict[macdStartY] = Double(strartPoint.y)
            let x = strartPoint.y - yPosition
            if macdIsEqualZero(value: Float(x)) {
                dict[macdEndY] = Double(MaxValue / HeightPerpoint)
            }
            postions.append(dict)
        }
        return postions
    }
    
    func drawMACDLayer(postions: [Dictionary<String, Double>]) {
        for (_,dic) in postions.enumerated() {
            let strartX = dic[macdStartX]
            let strartY = dic[macdStartY]
            let endY = dic[macdEndY]
            let rect:CGRect = CGRect(x: strartX!, y: strartY! + Double(QutoaHeight) + midDistance, width: Double(CandleWidth), height: endY! - strartY!)
            let path = CGMutablePath.init()
            path.addRect(rect)
            let subLayer = CAShapeLayer()
            subLayer.path = path
            if endY! > strartY! {
                subLayer.strokeColor = DROPCOLOR.cgColor
                subLayer.fillColor = DROPCOLOR.cgColor
            } else {
                subLayer.strokeColor = RISECOLOR.cgColor
                subLayer.fillColor = RISECOLOR.cgColor
            }
            addSublayer(subLayer)
        }
    }
    
    private func macdIsEqualZero(value: Float) -> Bool {
        return fabsf(value) <= 0.00001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
