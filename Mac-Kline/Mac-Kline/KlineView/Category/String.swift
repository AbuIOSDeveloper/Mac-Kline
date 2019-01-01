//
//  String.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

extension String {
    
    func sizeOfString(usingFont font: NSFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func preciseDecimal(p : Int) -> String {
        if (Double(self) != nil) {
            let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode(rawValue: 0)!, scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(self)!)
            let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
            var formatterString : String = "0."
            let count : Int = (p < 0 ? 0 : p)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            formatter.positiveFormat = formatterString
            return formatter.string(from: resultNumber)!
        }
        return "0"
    }
    
    func precision(precision:Int) -> String {
        if Double(self) != nil {
            let num:Double = Double(self)!
            return "\(num.roundTo(places: precision))"
        }
        return "0"
    }
}

extension Double {

    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
}

