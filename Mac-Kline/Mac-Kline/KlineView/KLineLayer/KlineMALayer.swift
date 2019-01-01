//
//  KlineMALayer.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/25.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa

class KlineMALayer: CAShapeLayer {
    
    var klineDataSource = [KLineModel]()
    var CandleWidth: CGFloat = 0.0
    var CandleSpace: CGFloat = 0.0
    var StartIndex: CGFloat = 0
    var MaxValue: CGFloat = 0.0
    var HeightPerpoint: CGFloat = 0.0
    var TotalHeight: CGFloat = 0.0
    var LineWidth: CGFloat = 0.0
    var LineColor: NSColor = NSColor.red
    var WireType: LINETYPE = .MA5TYPE
    var KlineSubOrMain: KlineWireSubOrMain = .Main
    
    init(dataArr: [KLineModel], candleWidth: CGFloat, candleSpace: CGFloat, startIndex: CGFloat,maxValue: CGFloat, heightPerpoint: CGFloat, totalHeight: CGFloat, lineWidth: CGFloat, lineColor: NSColor, wireType: LINETYPE, klineWiretype: KlineWireSubOrMain) {
        super.init()
        klineDataSource = dataArr
        CandleWidth = candleWidth
        CandleSpace = candleSpace
        StartIndex = startIndex
        MaxValue = maxValue
        HeightPerpoint = heightPerpoint
        TotalHeight = totalHeight
        LineWidth = lineWidth
        LineColor = lineColor
        WireType = wireType
        KlineSubOrMain = klineWiretype
        drawWireLine(postions: coverPostionModel())
    }
    
    func coverPostionModel() -> [Dictionary<String, Double>] {
        var postions = [Dictionary<String, Double>]()
        var vaule:Double = 0.0
        var yPosition: CGFloat = CGFloat(MAXFLOAT)
        var postionPoint = CGPoint.zero
        for (index,model) in klineDataSource.enumerated() {
            var dict: Dictionary = Dictionary<String, Double>()
            switch WireType {
            case .MA5TYPE:
                if model.MA5 > 0 {
                    vaule = model.MA5
                } else {
                    continue
                }
            case .MA10TYPE:
                if model.MA10 > 0 {
                    vaule = model.MA10
                } else {
                    continue
                }
            case .MA20TYPE:
                if model.MA20 > 0 {
                    vaule = model.MA20
                } else {
                    continue
                }
            case .MACDDEA:
                vaule = model.DEA
            case .MACDDIF:
                vaule = model.DIF
            case .KDJ_K:
                if model.K > 0 {
                    vaule = model.K
                }
            case .KDJ_D:
                if model.D > 0 {
                    vaule = model.D
                }
            case .BOLL_UP:
                if model.BOLL_UP > 0 {
                    vaule = model.BOLL_UP
                } else {
                    continue
                }
            case .BOLL_MB:
                if model.BOLL_MB > 0 {
                    vaule = model.BOLL_MB
                } else {
                    continue
                }
            case .BOLL_DN:
                if model.BOLL_DN > 0 {
                    vaule = model.BOLL_DN
                } else {
                    continue
                }
            case .KLINE_RSI6:
                vaule = model.RSI_6
            case .KLINE_RSI12:
                vaule = model.RSI_12
            case .KLINE_RSI24:
                vaule = model.RSI_24
            default: break
            }
            let xPosition: CGFloat = StartIndex + ((CandleWidth  + CandleSpace) * CGFloat(index)) + CandleWidth / 2.0
            if KlineSubOrMain == .Main {
                yPosition = (MaxValue - CGFloat(vaule)) * HeightPerpoint + CGFloat(topDistance)
                
            } else if KlineSubOrMain == .Sub {
                if WireType == .MACDDIF || WireType == .MACDDEA {
                    yPosition = (MaxValue - CGFloat(vaule)) / HeightPerpoint + TotalHeight + CGFloat(midDistance)
                } else {
                    yPosition = (MaxValue - CGFloat(vaule)) * HeightPerpoint + TotalHeight + CGFloat(midDistance)
                }
            }
            postionPoint = CGPoint(x: xPosition, y: yPosition)
            dict["x"] = Double(postionPoint.x)
            dict["y"] = Double(postionPoint.y)
            postions.append(dict)
        }
        return postions
    }
    
    func drawWireLine(postions: [Dictionary<String, Double>]) {
        let wirePath:CGMutablePath = CGMutablePath.drawWireLine(linesArray: postions)
        self.path = wirePath
        self.strokeColor = LineColor.cgColor
        self.fillColor = NSColor.clear.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

