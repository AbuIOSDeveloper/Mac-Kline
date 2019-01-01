//
//  NSString.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/12.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

class StringTools: NSObject {
    class func relaodIndexTitleWithModel(model: KLineModel, indexType: KlineIndexType) -> NSMutableAttributedString {
        
        let resultString = NSMutableAttributedString(string: "")
        switch indexType {
        case .MA:
            resultString.append(setupAttributeString(string: String(format: "MA5: %.2f  ",model.MA5), attributedColor: MA5Color))
            resultString.append(setupAttributeString(string: String(format: "MA10: %.2f  ",model.MA10), attributedColor: MA10Color))
            resultString.append(setupAttributeString(string: String(format: "MA20: %.2f  ",model.MA20), attributedColor: MA20Color))
        case .BOLL:
            resultString.append(setupAttributeString(string: String(format: "UP: %.2f  ",model.BOLL_UP), attributedColor: QuotaBOOLUPCOLOR))
            resultString.append(setupAttributeString(string: String(format: "MB: %.2f  ",model.BOLL_MB), attributedColor: QuotaBOOLMBCOLOR))
            resultString.append(setupAttributeString(string: String(format: "DN: %.2f  ",model.BOLL_DN), attributedColor: QuotaBOOLDNCOLOR))
        case .MACD:
            resultString.append(setupAttributeString(string: String(format: "MACD: %.2f  ",model.MACD), attributedColor: QuotaMACDCOLOR))
            resultString.append(setupAttributeString(string: String(format: "DIF: %.2f  ",model.DIF), attributedColor: QuotaDIFCOLOR))
            resultString.append(setupAttributeString(string: String(format: "DEA: %.2f  ",model.DEA), attributedColor: QuotaDEACOLOR))
        case .KD:
            resultString.append(setupAttributeString(string: String(format: "K: %.2f  ",model.K), attributedColor: QuotaKCOLOR))
            resultString.append(setupAttributeString(string: String(format: "D: %.2f  ",model.D), attributedColor: QuotaDCOLOR))
        case .RSI:
            resultString.append(setupAttributeString(string: String(format: "RSI6: %.2f  ",model.RSI_6), attributedColor: QuotaRSI_6))
            resultString.append(setupAttributeString(string: String(format: "RSI12: %.2f  ",model.RSI_12), attributedColor: QuotaRSI_12))
            resultString.append(setupAttributeString(string: String(format: "RSI24: %.2f  ",model.RSI_24), attributedColor: QuotaRSI_24))
        case .W_R:
            resultString.append(setupAttributeString(string: String(format: "WR: %.2f  ",model.WR), attributedColor: QuotaWR1Color))
        case .VOL:
            resultString.append(setupAttributeString(string: String(format: "VOL5: %.2f  ",model.volumn_MA5), attributedColor: MA5Color))
            resultString.append(setupAttributeString(string: String(format: "VOL10: %.2f  ",model.volumn_MA10), attributedColor: MA10Color))
            resultString.append(setupAttributeString(string: String(format: "VOL20: %.2f  ",model.volumn_MA20), attributedColor: MA20Color))
        default:
            break
        }
        return resultString
    }
    
    class func setupAttributeString(string: String, attributedColor: NSColor) -> NSAttributedString {
        if string.isEmpty {
            return NSMutableAttributedString(string: "")
        }
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: attributedColor], range: NSMakeRange(0, string.count))
        return attributedString
    }
}

