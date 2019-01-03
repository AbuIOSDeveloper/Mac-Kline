//
//  AbuKlineMainView.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/23.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

protocol AbuKlineMainViewDelegate: NSObjectProtocol {
    func currentScreenleftPostionx(leftPostionx: CGFloat, leftIndex: Int, klineCount: Int)
    func refreshLastModel(model: KLineModel)
    func reloadPriceViewWithPriceArr(priceArray: [String])
    func reloadPriceViewWithQuotaMaxValue(maxValue: Double, minValue: Double)
    func reloadPriceViewWithVolQuotaMaxValue(maxValue: Double, minValue: Double)
    func reloadMoreData()
    func reloadCurrentIndextitle(attributedString: NSMutableAttributedString, SubType: KlineIndexType ,mainOrSub: KlineWireSubOrMain)
}

class AbuKlineMainView: NSView {

    var scrollView: NSScrollView!
    var leftPostion: CGFloat = 0.0
    var currentDisplayArray: [KLineModel] = []
    var previousOffsetX: CGFloat = 0.0
    var maxAssert: CGFloat = 0.0
    var minAssert: CGFloat = 0.0
    var quotalHeight: CGFloat = 0.0
    var heightPerpoint: CGFloat = 0.0
    var quotaVolMinAssert: Double = 0.0
    var quotaVolMaxAssert: Double = 0.0
    var quotaVolHeightPerPoint: Double = 0.0
    var quotaMinAssert: Double = 0.0
    var quotaMaxAssert: Double = 0.0
    var quotaHeightPerPoint: Double = 0.0
    var isRefresh = false
    
    var dataArray: [KLineModel] = []
    var candleSpace: CGFloat = 5
    var candleWidth: CGFloat = 0.0
    var currentStartIndex: Int = 0
    var contentOffset: CGFloat = 0.0
    var scrollEnble:Bool = false
    var hollowRise = false
    
    var chartSize: Float = 0.0
    var isShowSubView = false
    var contentHeight: CGFloat = 0.0
    var subTypeArray: [KlineIndexType] = []
    var currentMainType: KlineIndexType = .BOLL
    var precisions: Int = 0
    var timeLayer: KlineTimeLayer?
    var candelLayer: KlineCandelLayer?
    var ma5LineLayer: KlineMALayer?
    var ma10LineLayer: KlineMALayer?
    var ma20LineLayer: KlineMALayer?
    var boll_MBLineLayer: KlineMALayer?
    var boll_UPLineLayer: KlineMALayer?
    var boll_DNLineLayer: KlineMALayer?
    var macdLayer: KlineQuotaColumnLayer?
    var volLayer: KlineQuotaColumnLayer?
    var deaLayer: KlineMALayer?
    var diffLayer: KlineMALayer?
    var kLineLayer: KlineMALayer?
    var dLineLayer: KlineMALayer?
    var wrLineLayer: KlineMALayer?
    var rsi6Layer: KlineMALayer?
    var rsi12Layer: KlineMALayer?
    var rsi24Layer: KlineMALayer?
    weak var delegate: AbuKlineMainViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        calcuteCandleWidth()
        initConfig()

    }

    func initConfig() {
        scrollEnble = true
        isRefresh = true
        chartSize = Float(orignIndicatorOrignY)
        isShowSubView = true
    }
    
    func calcuteCandleWidth() {
        candleWidth = CGFloat(minCandelWith)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        scrollView = (superview?.superview as! NSScrollView)

        self.scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(clipViewBoundsChanged(_:)), name: NSView.boundsDidChangeNotification, object: self.scrollView.contentView)
        

    }
    @objc func clipViewBoundsChanged(_ notification: NSNotification) {
        guard let documentView = self.scrollView.contentView.documentView else { return }
        scrollView.width = scrollView.bounds.width
        contentOffset = documentView.visibleRect.minX
        drawKLine()
    }
   
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        scrollView.height = oldSize.height
        drawKLine()
    }
    
    func getScrollEnble(enble:Bool) {
        scrollEnble = enble
    }
    
    func drawKLine() {
        leftPostion = getKlineLeftPostionX()
        currentStartIndex = getKlineCurrentStarIndex()
        initCurrentDisplayModels()
        calcuteMaxAndMinValue()
        delegate?.reloadPriceViewWithPriceArr(priceArray: calculatePrcieArrWhenScroll())
        drawMainKlineView()
    }
    
    func drawMainKlineView() {
        drawCandelLayer()
        drawMainSubLineLayer()
        drawSubLineLayer()
        drawTimeLayer()
        let line = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: NSPoint(x: 0, y: contentHeight))
        path.addLine(to: NSPoint(x: self.scrollView.width, y: contentHeight))
        line.path = path
        line.lineWidth = 1
        line.fillColor = NSColor.red.cgColor
        self.layer?.addSublayer(line)
        delegate?.refreshLastModel(model: currentDisplayArray.last!)
    }
    
    func drawMainSubLineLayer() {
        if currentDisplayArray.isEmpty {
            return
        }
        removeMainSubLayers()
        if currentMainType == .MA {
            drawMASubLineLayer()
        } else if currentMainType == .BOLL {
            drawBOLLSubLineLayer()
        }
        let attStr = StringTools.relaodIndexTitleWithModel(model: currentDisplayArray.last!, indexType: currentMainType)
        delegate?.reloadCurrentIndextitle(attributedString: attStr, SubType: currentMainType, mainOrSub: .Main)
    }
    
    func drawCandelLayer() {
        if candelLayer != nil {
            candelLayer!.removeFromSuperlayer()
        }
        candelLayer = KlineCandelLayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, contentWidth: scrollView.contentSize.width)
        layer!.addSublayer(candelLayer!)
    }
    func drawSubLineLayer() {
        for (_,type) in subTypeArray.enumerated() {
            drawPresetQuota(type: type)
            let attStr = StringTools.relaodIndexTitleWithModel(model: currentDisplayArray.last!, indexType: type)
            delegate?.reloadCurrentIndextitle(attributedString: attStr, SubType: type, mainOrSub: .Sub)
        }
    }
    
    func drawPresetQuota(type:KlineIndexType) {
        calcuteQuotaMaxAssertAndMinAssert(type: type)
        switch type {
        case .MACD:
            drawPresetMACD()
        case .VOL:
            drawPresetVOL()
            delegate?.reloadPriceViewWithVolQuotaMaxValue(maxValue: quotaVolMaxAssert, minValue: quotaVolMinAssert)
        case .KD:
            drawPresetKD()
        default:
            break
        }
        delegate?.reloadPriceViewWithQuotaMaxValue(maxValue: quotaMaxAssert, minValue: quotaMinAssert)
    }
    
    func drawTimeLayer(){
        if timeLayer != nil {
            timeLayer!.removeFromSuperlayer()
        }
        self.timeLayer = KlineTimeLayer(dataArr: currentDisplayArray, candleWidth: candleWidth, height: self.scrollView.height, timeHight: CGFloat(timeheight), bottomMargin: 0, lineWidth: 0)
        self.layer?.addSublayer(timeLayer!)
    }
    
    func updateDataSourece(datasource:[KLineModel], mainType: KlineIndexType, subTypes: [KlineIndexType], precision: Int) {
        dataArray = datasource
        precisions = precision
        subTypeArray = subTypes
        currentMainType = mainType
    }

    func removeMainSubLayers()
    {
        if ma5LineLayer != nil {
            ma5LineLayer!.removeFromSuperlayer()
        }
        if ma10LineLayer != nil {
            ma10LineLayer!.removeFromSuperlayer()
        }
        if ma20LineLayer != nil {
            ma20LineLayer!.removeFromSuperlayer()
        }
        if boll_UPLineLayer != nil {
            boll_UPLineLayer!.removeFromSuperlayer()
        }
        if boll_MBLineLayer != nil {
            boll_MBLineLayer!.removeFromSuperlayer()
        }
        if boll_DNLineLayer != nil {
            boll_DNLineLayer!.removeFromSuperlayer()
        }
    }
    override var isFlipped: Bool  {
        get { return true}
        set {return self.isFlipped = newValue}
    }
}

extension AbuKlineMainView {
    
    open func reloadKlineView() {
        updateWidth()
        drawKLine()
    }
    func updateWidth() {
        var klineWidth: CGFloat = (CGFloat)(dataArray.count) * (candleWidth + candleSpace) + 5
        if klineWidth < scrollView!.width {
                klineWidth = scrollView!.width
        }
        scrollView.documentView?.bounds.size = NSSize(width: klineWidth, height: 0)
        if isRefresh {
            scrollView.documentView?.scroll(NSPoint(x: klineWidth - scrollView!.width, y: 0))
        }
        contentOffset = scrollView.documentView!.visibleRect.minX
    }
    func getKlineLeftPostionX() -> CGFloat {
        var scrollViewOffsetX: CGFloat = contentOffset < 0 ? 0 : contentOffset
        if contentOffset + scrollView!.width >= scrollView!.documentView!.width {
            scrollViewOffsetX = scrollView!.documentView!.width - scrollView!.width
        }
        if scrollViewOffsetX == 0 {
            scrollViewOffsetX = 10
        }
        leftPostion = scrollViewOffsetX
        return scrollViewOffsetX
    }
    func getKlineCurrentStarIndex() -> Int {
        let scrollViewOffsetX = leftPostion < 0 ? 0 : leftPostion
        let leftArrCount:Int = (Int)((scrollViewOffsetX) / (candleSpace + candleWidth))
        if leftArrCount > dataArray.count {
            currentStartIndex = dataArray.count - 1
        } else if (leftArrCount == 0) {
            currentStartIndex = 0
        } else {
            currentStartIndex = leftArrCount
        }
        return currentStartIndex
    }
    func initCurrentDisplayModels() {
        let needDrawKLineCount: Int = Int(scrollView!.width / (candleWidth + candleSpace))
        let currentStart: Int = currentStartIndex
        let count: Int = (currentStartIndex + needDrawKLineCount) > dataArray.count ? dataArray.count :currentStartIndex+needDrawKLineCount
        currentDisplayArray.removeAll()
        if currentStart < count {
            for (index,model) in dataArray.enumerated() {
                if index >= currentStart && index <= currentStart + needDrawKLineCount {
                    currentDisplayArray.append(model)
                }
            }
        }
    }
}

extension AbuKlineMainView {
    
    func calcuteMaxAndMinValue() {
        var openPriceArray = [Double]()
        var closePriceArray = [Double]()
        var heightPriceArray = [Double]()
        var lowPriceArray = [Double]()
        var Array1 = [Double]()
        var Array2 = [Double]()
        var Array3 = [Double]()
        for (_,model) in currentDisplayArray.enumerated() {
            openPriceArray.append(Double(model.openPrice))
            closePriceArray.append(Double(model.closePrice))
            heightPriceArray.append(Double(model.highPrice))
            lowPriceArray.append(Double(model.lowPrice))
            if currentMainType == .BOLL {
                if model.BOLL_UP > 0 {
                    Array1.append(model.BOLL_UP)
                }
                if model.BOLL_MB > 0 {
                    Array2.append(model.BOLL_MB)
                }
                if model.BOLL_DN > 0 {
                    Array3.append(model.BOLL_DN)
                }
            } else if currentMainType == .MA {
                if model.MA5 > 0 {
                    Array1.append(model.MA5)
                }
                if model.MA10 > 0 {
                    Array2.append(model.MA10)
                }
                if model.MA20 > 0 {
                    Array3.append(model.MA20)
                }
            }
        }
        let dic: Dictionary = KlineCalculate.sharedManager.calculateMaxAndMinValueWithDataArr(dataArr: [openPriceArray,closePriceArray,heightPriceArray,lowPriceArray,Array1,Array2,Array3])
        maxAssert = CGFloat(dic[kMaxValue]!)
        minAssert = CGFloat(dic[kMinValue]!)
        contentHeight = scrollView.height * CGFloat(orignIndicatorOrignY) - CGFloat(topDistance * 4)
        heightPerpoint = contentHeight / (maxAssert - minAssert)
        
    }
    func calcuteQuotaMaxAssertAndMinAssert(type:KlineIndexType) {
        var dic: Dictionary = Dictionary<String,Double>()
        var contentHeigh = 0.0
        if type == .MACD {
            var DEAArray = [Double]()
            var DIFArray = [Double]()
            var MACDArray = [Double]()
            for (_,model) in currentDisplayArray.enumerated() {
                DEAArray.append(model.DEA)
                DIFArray.append(model.DIF)
                MACDArray.append(model.MACD)
            }
            dic = KlineCalculate.sharedManager.calculateMaxAndMinValueWithDataArr(dataArr: [DEAArray,DIFArray,MACDArray])
            quotaMaxAssert = dic[kMaxValue]!
            quotaMinAssert = dic[kMinValue]!
            contentHeigh = Double(scrollView.height) * orignIndicatorScale - midDistance - timeheight
            quotaHeightPerPoint = (quotaMaxAssert - quotaMinAssert) / contentHeigh
        } else if type == .KD {
            var KDataArr = [Double]()
            var DDataArr = [Double]()
            for (_,model) in currentDisplayArray.enumerated() {
                if model.K > 0 {
                    KDataArr.append(model.K)
                }
                if model.D > 0 {
                    DDataArr.append(model.D)
                }
            }
            dic = KlineCalculate.sharedManager.calculateMaxAndMinValueWithDataArr(dataArr: [KDataArr,DDataArr])
            quotaMaxAssert = dic[kMaxValue]!
            quotaMinAssert = dic[kMinValue]!
            contentHeigh = Double(scrollView.height) * orignIndicatorScale - midDistance - timeheight
            quotaHeightPerPoint = contentHeigh / (quotaMaxAssert - quotaMinAssert)
        } else if type == .W_R {
            
        } else if type == .VOL {
            var VolArray = [Double]()
            var VOL_MA5DataArr = [Double]()
            var VOL_MA10DataArr = [Double]()
            var VOL_MA20DataArr = [Double]()
            for (_,model) in currentDisplayArray.enumerated() {
                VolArray.append(Double("\(model.volumn)")!)
                if model.xPoint >= 4 {
                    VOL_MA5DataArr.append(model.volumn_MA5)
                }
                if model.xPoint >= 9 {
                    VOL_MA10DataArr.append(model.volumn_MA10)
                }
                if model.xPoint >= 19 {
                    VOL_MA20DataArr.append(model.volumn_MA20)
                }
            }
            dic = KlineCalculate.sharedManager.calculateMaxAndMinValueWithDataArr(dataArr: [VolArray,VOL_MA5DataArr,VOL_MA10DataArr,VOL_MA20DataArr])
            quotaVolMaxAssert = dic[kMaxValue]!
            quotaVolMinAssert = dic[kMinValue]!
            if subTypeArray.count > 1 {
                contentHeigh = Double(scrollView.height) * orignIndicatorScale  - midDistance - timeheight
            } else {
                contentHeigh = Double(scrollView.height) * orignIndicatorScale * 2.0 - midDistance - timeheight
            }
            
            quotaVolHeightPerPoint = contentHeigh / (quotaVolMaxAssert - quotaVolMinAssert)
            
        } else if type == .RSI {
            
        }
    }

    func calculatePrcieArrWhenScroll() -> [String] {
        
        var priceArr = [String]()
        
        for i in (0...5).reversed() {
            if i == 5 {
                priceArr.append(String(Double(maxAssert)))
                continue
            }
            if i == 0 {
                priceArr.append(String(Double(minAssert)))
                continue
            }
            priceArr.append(String((Double(minAssert) + Double(contentHeight / 5.0) * Double(i) / Double(heightPerpoint))))
        }
        return priceArr
    }

}

extension AbuKlineMainView {
    func drawMASubLineLayer() {
        ma5LineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: MA5Color, wireType: .MA5TYPE, klineWiretype: .Main)
        layer!.addSublayer(ma5LineLayer!)
        ma10LineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: MA10Color, wireType: .MA10TYPE, klineWiretype: .Main)
        layer!.addSublayer(ma10LineLayer!)
        ma20LineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: MA20Color, wireType: .MA20TYPE, klineWiretype: .Main)
        layer!.addSublayer(ma20LineLayer!)
    }
    func drawBOLLSubLineLayer() {
        boll_UPLineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: QuotaBOOLUPCOLOR, wireType: .BOLL_UP, klineWiretype: .Main)
        layer!.addSublayer(boll_UPLineLayer!)
        boll_MBLineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: QuotaBOOLMBCOLOR, wireType: .BOLL_MB, klineWiretype: .Main)
        layer!.addSublayer(boll_MBLineLayer!)
        boll_DNLineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: maxAssert, heightPerpoint: heightPerpoint, totalHeight: 0, lineWidth: 1, lineColor: QuotaBOOLDNCOLOR, wireType: .BOLL_DN, klineWiretype: .Main)
        layer!.addSublayer(boll_DNLineLayer!)
    }
}
extension AbuKlineMainView {
    func drawPresetMACD() {
        if macdLayer != nil {
            macdLayer!.removeFromSuperlayer()
        }
        macdLayer = KlineQuotaColumnLayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaMaxAssert), minValue: CGFloat(quotaMinAssert), heightPerpoint: CGFloat(quotaHeightPerPoint), qutoaHeight: scrollView.height * CGFloat(orignIndicatorOrignY + orignIndicatorScale), klineIndexype: .MACD)
        layer!.addSublayer(macdLayer!)
        if deaLayer != nil {
            deaLayer!.removeFromSuperlayer()
        }
        deaLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaMaxAssert), heightPerpoint: CGFloat(quotaHeightPerPoint), totalHeight: scrollView.height * CGFloat(orignIndicatorOrignY + orignIndicatorScale), lineWidth: 1, lineColor: QuotaDEACOLOR, wireType: .MACDDEA, klineWiretype: .Sub)
        layer!.addSublayer(deaLayer!)
        if diffLayer != nil {
            diffLayer!.removeFromSuperlayer()
        }
        diffLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaMaxAssert), heightPerpoint: CGFloat(quotaHeightPerPoint), totalHeight: scrollView.height * CGFloat(orignIndicatorOrignY + orignIndicatorScale), lineWidth: 1, lineColor: QuotaDIFCOLOR, wireType: .MACDDIF, klineWiretype: .Sub)
        layer!.addSublayer(diffLayer!)
    }
    func drawPresetVOL() {
        if volLayer != nil {
            volLayer!.removeFromSuperlayer()
        }
        volLayer = KlineQuotaColumnLayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaVolMaxAssert), minValue: CGFloat(quotaVolMinAssert), heightPerpoint: CGFloat(quotaVolHeightPerPoint), qutoaHeight: scrollView.height * CGFloat(orignIndicatorOrignY), klineIndexype: .VOL)
        layer!.addSublayer(volLayer!)
    }
    func drawPresetKD() {
        if kLineLayer != nil {
            kLineLayer!.removeFromSuperlayer()
        }
        kLineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaMaxAssert), heightPerpoint: CGFloat(quotaHeightPerPoint), totalHeight: scrollView.height * CGFloat(orignIndicatorOrignY + orignIndicatorScale), lineWidth: 1, lineColor: QuotaKCOLOR, wireType: .KDJ_K, klineWiretype: .Sub)
        layer!.addSublayer(kLineLayer!)
        if dLineLayer != nil {
            dLineLayer!.removeFromSuperlayer()
        }
        dLineLayer = KlineMALayer(dataArr: currentDisplayArray, candleWidth: candleWidth, candleSpace: candleSpace, startIndex: leftPostion, maxValue: CGFloat(quotaMaxAssert), heightPerpoint: CGFloat(quotaHeightPerPoint), totalHeight: scrollView.height * CGFloat(orignIndicatorOrignY + orignIndicatorScale), lineWidth: 1, lineColor: QuotaDCOLOR, wireType: .KDJ_D, klineWiretype: .Sub)
        layer!.addSublayer(dLineLayer!)
    }
}
