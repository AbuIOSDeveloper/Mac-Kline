//
//  KLine KLineIndexCalculate.swift
//  AbuKline-Swift
//
//  Created by yskj21.5 on 2018/12/13.
//  Copyright © 2018年 Jefferson. All rights reserved.
//

import Cocoa

    class KLineIndexCalculate: NSObject {
        let kRise = "kRise"
        let kDrop = "kDrop"
        static let sharedManager: KLineIndexCalculate = KLineIndexCalculate()
        
        public func initializeQuotaDataWithArray(dataArray: [KLineModel], type:KlineIndexType) -> [KLineModel] {
            for (index,model) in dataArray.enumerated() {
                handleQuotaDataWithDataArr(dataArray: dataArray, model: model, index: index, type: type)
            }
            return dataArray
        }
        
        public func handleQuotaDataWithDataArr(dataArray: [KLineModel], model: KLineModel, index: Int, type: KlineIndexType) {
            if type == .MACD {
                calculateMACDWithDataArr(dataArr: dataArray, model: model, index: index)
            } else if type == .KD {
                calculateKDWithDataArr(dataArr: dataArray, model: model, index: index)
            } else if type == .W_R {
                calculateWRWithDataArr(dataArr: dataArray, model: model, index: index)
            } else if type == .VOL {
                calculateVOLWithDataArr(dataArr: dataArray, model: model, index: index)
                calculateBOLLWithDataArr(dataArr: dataArray, model: model, index: index)
                calculateMACDWithDataArr(dataArr: dataArray, model: model, index: index)
                calculateMAWithDataArr(dataArr: dataArray, num: 5, model: model, index: index)
                calculateMAWithDataArr(dataArr: dataArray, num: 10, model: model, index: index)
                calculateMAWithDataArr(dataArr: dataArray, num: 20, model: model, index: index)
                calculateKDWithDataArr(dataArr: dataArray, model: model, index: index)
            } else if type == .BOLL {
                calculateBOLLWithDataArr(dataArr: dataArray, model: model, index: index)
            } else if type == .MA {
                calculateMAWithDataArr(dataArr: dataArray, num: 5, model: model, index: index)
                calculateMAWithDataArr(dataArr: dataArray, num: 10, model: model, index: index)
                calculateMAWithDataArr(dataArr: dataArray, num: 20, model: model, index: index)
            }
        }
    }

    extension KLineIndexCalculate {
    
        func calculateMACDWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            var previousKlineModel:KLineModel = KLineModel()
            if index > 0 && index < dataArr.count {
                previousKlineModel = dataArr[index - 1]
            }
            model.previousKlineModel = previousKlineModel
            model.reInitData()
        }
        func calculateMAWithDataArr(dataArr: [KLineModel], num: Int, model: KLineModel, index: Int) {
            var sum: CGFloat = 0
            if index >= (num - 1) {
                for i in 0...(num - 1) {
                    let model:KLineModel = dataArr[index - i]
                    sum += model.closePrice
                }
                let value:Double = Double(Double(sum) / Double(num))
                if num == 5 {
                    model.MA5 = value
                } else if num == 10 {
                    model.MA10 = value
                } else if num == 20 {
                    model.MA20 = value
                }
            }
        }
        func calculateKDWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            let N: Int = 9
            let M1: Int = 3
            let M2: Int = 3
            var RSV: Double = 0.0
            var K: Double = 0.0
            var D: Double = 0
            var lowPrice: Float = MAXFLOAT
            var highPrice: Float = 0.0
            if index < N - 1 {
                lowPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: false))
                highPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: true))
            } else {
                for _ in (index - N + 1)...index {
                    lowPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: false))
                    highPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: true))
                    RSV = (Double(model.closePrice) - Double(lowPrice)) * 100.0 / (Double(highPrice) - Double(lowPrice))
                    K = getRSVWithDataArray(dataArray: dataArr, currentDay: index, aveDay: M1)
                    D = getKWithDataArray(dataArray: dataArr, currentDay: index, aveDay: M2)
                    model.RSV = RSV
                    model.K = K
                    model.D = D
                }
            }
        }
        func getHighPrice(dataArray: [KLineModel],currentIdx: Int, aveg: Int, isMax:Bool) -> Double {
            var result = 0.0
            var resultArray = [Double]()
            if !resultArray.isEmpty {
                resultArray.removeAll()
            }
            if currentIdx < (aveg - 1) {
                for i in 0...currentIdx {
                    let model: KLineModel = dataArray[i]
                    if isMax {
                        resultArray.append(Double(model.highPrice))
                    } else {
                        resultArray.append(Double(model.lowPrice))
                    }
                }
            } else {
                for i in(currentIdx - aveg + 1)...currentIdx {
                    let model: KLineModel = dataArray[i]
                    if isMax {
                        resultArray.append(Double(model.highPrice))
                    } else {
                        resultArray.append(Double(model.lowPrice))
                    }
                }
            }
            let resultDic: Dictionary = KlineCalculate.sharedManager.calculateMaxAndMinValueWithDataArr(dataArr: [resultArray])
            if isMax {
                result = resultDic[kMaxValue]!
            } else {
                result = resultDic[kMinValue]!
            }
            return result
        }
        
        func getRSVWithDataArray(dataArray: [KLineModel], currentDay: Int, aveDay: Int) -> Double {
            var result = 0.0
            if currentDay < (aveDay - 1) {
                for i in 0...currentDay {
                    let model: KLineModel = dataArray[i]
                    result += model.RSV
                }
                result = result / Double(currentDay + 1)
            } else {
                for i in (currentDay - aveDay + 1)...currentDay {
                    let model: KLineModel = dataArray[i]
                    result += model.RSV
                }
                result = result / Double(aveDay)
            }
            return result
        }
        func getKWithDataArray(dataArray: [KLineModel], currentDay: Int, aveDay: Int) -> Double {
            var result = 0.0
            if currentDay < (aveDay - 1) {
                for i in 0...currentDay {
                    let model: KLineModel = dataArray[i]
                    result += model.K
                }
                result = result / Double(currentDay + 1)
            } else {
                for i in (currentDay - aveDay + 1)...currentDay {
                    let model: KLineModel = dataArray[i]
                    result += model.K
                }
                result = result / Double(aveDay)
            }
            return result
        }
        func calculateWRWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            let N = 14
            var lowPrice: Float = 0.0
            var highPrice: Double = 0.0
            if index < N - 1 {
                lowPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: false))
                highPrice = getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: true)
            } else {
                for _ in (index - N + 1)...index {
                    lowPrice = Float(getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: false))
                    highPrice = getHighPrice(dataArray: dataArr, currentIdx: index, aveg: N, isMax: true)
                }
            }
            model.WR = (highPrice - Double(model.closePrice)) * 100.0 / Double(highPrice - Double(lowPrice))
        }
        func calculateVOLWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            let VOLFiveNum: Int = 5
            if index >= (VOLFiveNum - 1) {
                model.volumn_MA5 = getPreviousAverageVolumnWithDataArr(dataArr: dataArr, dayCount: VOLFiveNum, idx: index)
            }
            let VOLTenNum: Int = 10
            if index >= (VOLTenNum - 1) {
                model.volumn_MA10 = getPreviousAverageVolumnWithDataArr(dataArr: dataArr, dayCount: VOLTenNum, idx: index)
            }
            let VOLTwentyNum: Int = 20
            if index >= (VOLTwentyNum - 1) {
                model.volumn_MA20 = getPreviousAverageVolumnWithDataArr(dataArr: dataArr, dayCount: VOLTwentyNum, idx: index)
            }
        }
        func getPreviousAverageVolumnWithDataArr(dataArr: [KLineModel], dayCount: Int, idx: Int) -> Double {
            var sumOfVolumn: Double = 0
            for i in (idx-(dayCount-1))...idx {
                if (i >= 0 ) {
                    let model: KLineModel = dataArr[i]
                    sumOfVolumn += Double(model.volumn)!
                }
            }
            return sumOfVolumn / Double(dayCount)
        }
        func calculateBOLLWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            var MA: Double = 0.0
            var MD: Double = 0.0
            var SUM: Double = 0.0
            var SUMMA: Double = 0.0
            var num: Int = 0
            let N: Int = 20
            let BOLLP: Double = 2.0
            if index > (N - 1) {
                for i in 0...(N - 1) {
                    let model: KLineModel = dataArr[index - N  + 1 + i]
                    SUMMA = SUMMA + Double(model.closePrice)
                    num += i
                }
                MA = (SUMMA / Double(N))
                for i in 0...(N - 1) {
                    let model: KLineModel = dataArr[index - N  + 1 + i]
                    SUM += pow((Double(model.closePrice) - MA), 2.0)
                }
                MD = sqrt(SUM / Double(N))
                let MB: Double = MA
                let UP: Double = MB + BOLLP * MD
                let DN: Double = MB - BOLLP * MD
                model.BOLL_MB = MB
                model.BOLL_UP = UP
                model.BOLL_DN = DN
            }
        }
        func calculateRSIWithDataArr(dataArr: [KLineModel], model: KLineModel, index: Int) {
            let RSISixNum = 6
            let RSITwelveNum = 12
            let RSITwentyfourNum = 24
            if index >= RSISixNum - 1 {
                model.RSI_6 = getRSIWithDataArr(dataArr: dataArr, dayCount: RSISixNum, index: index)
            }
            if index >= RSITwelveNum - 1 {
                model.RSI_12 = getRSIWithDataArr(dataArr: dataArr, dayCount: RSITwelveNum, index: index)
            }
            if index >= RSITwentyfourNum - 1 {
                model.RSI_24 = getRSIWithDataArr(dataArr: dataArr, dayCount: RSITwentyfourNum, index: index)
            }
            if index >= 14 - 1 {
                model.RSI_14 = getRSIWithDataArr(dataArr: dataArr, dayCount: 14, index: index)
            }
            if index >= 21 - 1 {
                model.RSI_21 = getRSIWithDataArr(dataArr: dataArr, dayCount: 21, index: index)
            }
            model.judgeRSIIsNan()
        }
        func getRSIWithDataArr(dataArr: [KLineModel], dayCount: Int, index: Int) -> Double {
            var previousPriceArr = [Double]()
            for i in (index - (dayCount - 1))...index {
                if i >= 1 {
                    let model = dataArr[i]
                    let lastModel = dataArr[i - 1]
                    previousPriceArr.append(Double(model.closePrice - lastModel.closePrice))
                    
                }
            }
            return getRSIWithPreviousPriceOfChangeArr(dataArr: previousPriceArr, dayCount: dayCount)
        }
        
        func getRSIWithPreviousPriceOfChangeArr(dataArr: [Double], dayCount: Int) -> Double {
            let dic = getSumOfRiseAndDropWithPreviousPriceOfChangeArr(previousPriceOfChangeArr: dataArr)
            let riseSum = dic[kRise]!
            let dropSum = dic[kDrop]!
            let riseRate = riseSum / Double(dayCount)
            let dropRate = dropSum / Double(dayCount)
            let RS = riseRate / dropRate
            let RSI = 100.0 - 100.0 / (1 + RS)
            return RSI
        }
        
        func getSumOfRiseAndDropWithPreviousPriceOfChangeArr(previousPriceOfChangeArr:[Double]) -> Dictionary<String,Double> {
            var sumOfRise: Double = 0.0
            var sumOfDrop: Double = 0.0
            var dic = Dictionary<String,Double>()
            for (_,value) in previousPriceOfChangeArr.enumerated() {
                if value >= 0 {
                    sumOfRise = sumOfRise + value
                } else {
                    sumOfDrop = sumOfDrop + value
                }
            }
            dic[kRise] = sumOfRise
            dic[kDrop] = sumOfRise
            return dic
        }
    }
    
    extension KLineIndexCalculate {
        
}



