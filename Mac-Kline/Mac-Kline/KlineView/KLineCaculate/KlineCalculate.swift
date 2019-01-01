//
//  KlineCaculate.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/13.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa
 let kMaxValue = "kMaxValue"
 let kMinValue = "kMinValue"
class KlineCalculate: NSObject {
    
    public static let sharedManager: KlineCalculate = KlineCalculate()
    
    public func calculateMaxAndMinValueWithDataArr(dataArr:Array<[Double]>) -> Dictionary<String, Double> {
        var resultDic:Dictionary = Dictionary<String,Double>()
        var array = [Double]()
        for (_,objc) in dataArr.enumerated() {
            array += objc
        }
        
        var min:Double = array[0]
        var max:Double = array[0]
        for i in 0..<array.count {
            if array[i] < min {
                min = array[i]
            }
            
            if array[i] > max {
                max = array[i]
            }
        }
        resultDic[kMaxValue] = max
        resultDic[kMinValue] = min
        return resultDic
    }
}
