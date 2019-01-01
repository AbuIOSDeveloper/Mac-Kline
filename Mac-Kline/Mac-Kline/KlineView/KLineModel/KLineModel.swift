//
//  KLineModel.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa
import SwiftyJSON

class KLineModel: NSObject {
    private let kRise = "kRise"
    private let kDrop = "kDrop"
    //* 最高价
    var highPrice: CGFloat = 0.0
    //* 最低价
    var lowPrice: CGFloat = 0.0
    //* 开盘价
    var openPrice: CGFloat = 0.0
    //* 收盘价
    var closePrice: CGFloat = 0.0
    //* 日期
    var date = ""
    //* 成交量
    var volumn = ""
    var isDrawDate = false
    var currentPrice: Double = 0.0
    var timestamp: Int = 0
    var isNew: Bool = false
    var timeStr:String = ""
    var xPoint: Int = 0
    var y: CGFloat = 0.0
    var h: CGFloat = 0.0
    var opensPoint = CGPoint.zero
    var closesPoint = CGPoint.zero
    var highestPoint = CGPoint.zero
    var lowestPoint = CGPoint.zero
    var fillColor: NSColor?
    var strokeColor: NSColor?
    var isPlaceHolder = false
    var previousKlineModel: KLineModel?
    var EMA12: Double = 0.0
    var EMA26: Double = 0.0
    var DIF: Double = 0.0
    var DEA: Double = 0.0
    var MACD: Double = 0.0
    var HNinePrice: Double = 0.0
    var LNinePrice: Double = 0.0
    var RSV_9: Double = 0.0
    var KDJ_K: Double = 0.0
    var KDJ_D: Double = 0.0
    var KDJ_J: Double = 0.0
    var BOLL_MA: Double = 0.0
    var BOLL_MD: Double = 0.0
    var BOLL_MB: Double = 0.0
    var BOLL_UP: Double = 0.0
    var BOLL_DN: Double = 0.0
    var RSI_6: Double = 0.0
    var RSI_12: Double = 0.0
    var RSI_14: Double = 0.0
    var RSI_21: Double = 0.0
    var RSI_24: Double = 0.0
    var SMAMAX: Double = 0.0
    var SMAABX: Double = 0.0
    var UPDM: Double = 0.0
    var DNDM: Double = 0.0
    var ADXTR: Double = 0.0
    var ADMUP: Double = 0.0
    var ADMDN: Double = 0.0
    var ADXATR: Double = 0.0
    var DIUP: Double = 0.0
    var DIDN: Double = 0.0
    var DX: Double = 0.0
    var ADX: Double = 0.0
    var volumn_MA5: Double = 0.0
    var volumn_MA10: Double = 0.0
    var volumn_MA20: Double = 0.0
    var MA5: Double = 0.0
    var MA10: Double = 0.0
    var MA14: Double = 0.0
    var MA20: Double = 0.0
    var N: Int = 0
    var AR: Double = 0.0
    var BR: Double = 0.0
    func reInitARBPData() {
    }
    var TR: Double = 0.0
    var ATR: Double = 0.0
    var BIAS1: Double = 0.0
    var BIAS2: Double = 0.0
    var BIAS3: Double = 0.0
    func reInitBIASData() {
    }
    var TP: Double = 0.0
    var CCI: Double = 0.0
    var SMA: Double = 0.0
    var SELL: Double = 0.0
    var BUY: Double = 0.0
    var ENE1: Double = 0.0
    var ENE2: Double = 0.0
    var RSV: Double = 0.0
    var K: Double = 0.0
    var D: Double = 0.0
    var LWR1: Double = 0.0
    var LWR2: Double = 0.0
    var WR: Double = 0.0
    var DD: Double = 0.0
    var GG: Double = 0.0
    var EMA1: Double = 0.0
    var EMA2: Double = 0.0
    var EMA3: Double = 0.0
    var EMA4: Double = 0.0
    var EMA5: Double = 0.0
    var EMA6: Double = 0.0
    var PBX1: Double = 0.0
    var PBX2: Double = 0.0
    var PBX3: Double = 0.0
    var PBX4: Double = 0.0
    var PBX5: Double = 0.0
    var PBX6: Double = 0.0

    override init() {
        super.init()
    }
    
    init?(json:JSON) {
        closePrice = CGFloat(json["c"].floatValue)
        openPrice = CGFloat(json["o"].floatValue)
        highPrice = CGFloat(json["h"].floatValue)
        lowPrice = CGFloat(json["l"].floatValue)
        date = json["t"].stringValue
        volumn = json["v"].stringValue
    }
    
    func reInitData() {
        let SHORT: Int = 12
        let LONG: Int = 26
        let M: Int = 9
        EMA12 = (2.0 * Double(closePrice) + Double((SHORT - 1)) * (previousKlineModel!.EMA12)) / Double((SHORT + 1))
        EMA26 = (2 * Double(closePrice) + Double((LONG - 1)) * previousKlineModel!.EMA26) / Double((LONG + 1))
        DIF = EMA12 - EMA26
        DEA = (previousKlineModel!.DEA) * Double((M - 1)) / Double((M + 1)) + 2.0 / Double((M + 1)) * DIF
        MACD = 2 * (DIF - DEA)
    }
    
    func reInitKDJData() {
        self.RSV_9 = (Double(self.closePrice) - self.LNinePrice) / (self.HNinePrice - self.LNinePrice) * 100.0
        var previousK = 0.0
        if xPoint == 8 {
            previousK = 50.0
        } else {
            previousK = (self.previousKlineModel?.KDJ_K)!
        }
        self.KDJ_K = previousK * orignIndicatorOrignY + orignIndicatorScale * self.RSV_9
        var previousD = 0.0
        if xPoint == 8 {
            previousD = 50.0
        } else {
            previousD = (self.previousKlineModel?.KDJ_D)!
        }
        self.KDJ_D = previousD * orignIndicatorOrignY + orignIndicatorScale * self.KDJ_K
        self.KDJ_J = 3.0 * self.KDJ_K - 2.0 * self.KDJ_D
        if KDJ_K.isNaN {
            self.KDJ_K = (previousKlineModel?.KDJ_K)!
        }
        if KDJ_D.isNaN {
            self.KDJ_D = (previousKlineModel?.KDJ_D)!
        }
        if KDJ_J.isNaN {
            self.KDJ_J = (previousKlineModel?.KDJ_J)!
        }
    }
    
    func judgeRSIIsNan() {
        if RSI_6.isNaN {
            self.RSI_6 = (previousKlineModel?.RSI_6)!
        }
        if RSI_12.isNaN {
            self.RSI_12 = (previousKlineModel?.RSI_12)!
        }
        if RSI_24.isNaN {
            self.RSI_24 = (previousKlineModel?.RSI_24)!
        }
    }
}
