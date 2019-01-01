//
//  Constant.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

let midDistance = 30.0
let topDistance = 20.0
let leftDistance = 20.0
let rightDistance = 20.0
let bottomDistance = 20.0
let scrollViewTopDistance = 40.0
let timeheight = 20.0
let timeWidth = 90.0
let MinCount = 10.0
let MaxCount = 30.0

let KlineCount = 88.0

let maxCandelWith = 20.0
let minCandelWith = 10.0

let orignIndicatorScale =  1.0 / 5.0
let orignIndicatorOrignY =  3.0 / 5.0
let priceWidth =  50.0

let RISECOLOR: NSColor = NSColor.colorWithHexString(hex:  "#fb463e")
let DROPCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#30b840")
let MA5Color: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let MA10Color: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let MA20Color: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let MA30Color: NSColor = NSColor.colorWithHexString(hex:  "#99cccc")
let MA60Color: NSColor = NSColor.colorWithHexString(hex:  "#cc99cc")
let BBIColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let MIKEWRColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let MIKEMRColor: NSColor = NSColor.colorWithHexString(hex:  "#ffCC66")
let MIKESRColor: NSColor = NSColor.colorWithHexString(hex:  "#9999CC")
let MIKEWSColor: NSColor = NSColor.colorWithHexString(hex:  "#99cccc")
let MIKEMSColor: NSColor = NSColor.colorWithHexString(hex:  "#cc99cc")
let MIKESSColor: NSColor = NSColor.colorWithHexString(hex:  "#003366")
let PBX1Color: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let PBX2Color: NSColor = NSColor.colorWithHexString(hex:  "#ffCC66")
let PBX3Color: NSColor = NSColor.colorWithHexString(hex:  "#9999CC")
let PBX4Color: NSColor = NSColor.colorWithHexString(hex:  "#99cccc")
let PBX5Color: NSColor = NSColor.colorWithHexString(hex:  "#cc99cc")
let PBX6Color: NSColor = NSColor.colorWithHexString(hex:  "#003366")
let QuotaMACDCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let QuotaDIFCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaDEACOLOR: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaKCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaDCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaJCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let QuotaBOOLUPCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaBOOLMBCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaBOOLDNCOLOR: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let QuotaRSI_6: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaRSI_12: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaRSI_24: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let QuotaARColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaBRColor: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaTRColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaATRColor: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaBIAS1Color: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaBIAS2Color: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaBIAS3Color: NSColor = NSColor.colorWithHexString(hex:  "#9999cc")
let QuotaCCIColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaDKBYBuyColor: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaDKBYSellColor: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaWR1Color: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaWR2Color: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")
let QuotaQHL5Color: NSColor = NSColor.colorWithHexString(hex:  "#6699ff")
let QuotaQHL10Color: NSColor = NSColor.colorWithHexString(hex:  "#ffcc66")

enum KlineWireSubOrMain: NSInteger {
    case Main = 1
    case Sub
}

enum KLINETYPE: NSInteger {
    case MIN5 = 1
    case MIN15 = 2
    case MIN30 = 3
    case MIN60 = 4
    case DAY = 5
    case WEEK = 6
    case MONTH = 7
    case VANE = 8
    case YEAR = 9
    case MANY_DAY = 15
    case MANY_MIN = 16
    case MANY_HOUR = 17
    case MIN1 = 34
    case MIN = 35
    case MIN3 = 36
    case HOUR1 = 37
    case HOUR4 = 38
}

enum LINETYPE: NSInteger {
    case MA5TYPE = 1
    case MA10TYPE
    case MA20TYPE
    case MA60TYPE
    case MA100TYPE
    case MACDDIF
    case MACDDEA
    case KDJ_K
    case KDJ_D
    case KDJ_J
    case KLINE_WR
    case KLINE_RSI6
    case KLINE_RSI12
    case KLINE_RSI24
    case BOLL_UP
    case BOLL_MB
    case BOLL_DN
}

enum KlineMainKPIType: NSInteger {
    case BBI = 1
    case BOLL
    case MA
    case MIKE
    case PBX
}

enum KlineSubKPIType: NSInteger {
    case ATR = 1
    case BIAS
    case CCI
    case KD
    case PBX
    case MACD
    case RSI
    case W_R
    case ARBP
    case DKBY
    case KDJ
    case LW_R
    case QHLSR
    case KD5
    case MACD24
    case VOL
}

enum KlineIndexType: NSInteger {
    case ATR = 1
    case BIAS
    case CCI
    case KD
    case MACD
    case RSI
    case W_R
    case ARBP
    case DKBY
    case KDJ
    case LW_R
    case QHLSR
    case KD5
    case MACD24
    case VOL
    case BBI
    case BOLL
    case MA
    case MIKE
    case PBX
}

