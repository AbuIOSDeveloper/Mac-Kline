//
//  AbuKlineView.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

class AbuKlineView: NSView {

    var model: KLineModel?
    var dataSource = [KLineModel]()
    lazy  var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.hasHorizontalRuler = false
        scrollView.wantsLayer = true
        scrollView.backgroundColor = NSColor.blackColor
        scrollView.horizontalScrollElasticity = .none
        scrollView.verticalScrollElasticity = .none
        return scrollView
    }()
    var candleChartView: AbuKlineMainView = {
        let chartView = AbuKlineMainView(frame: .zero)
        chartView.wantsLayer = true
        return chartView
    }()
    lazy var priceView: KlinePriceView = {
        let priceView = KlinePriceView(frame: .zero, PriceArr: ["","","","","",""])
        priceView.backgroundColor(backColor: NSColor.blackColor)
        return priceView
    }()
    var quotaVolPriceView: KlinePriceView = {
        return KlinePriceView(frame: .zero, PriceArr: ["",""])
    }()
    var quotaPriceView: KlinePriceView = {
        return KlinePriceView(frame: .zero, PriceArr: ["",""])
    }()
    var leavView: KlineCurrentPriceView = {
        return KlineCurrentPriceView(frame: .zero, update: false)
    }()
    var verticalView: KlineVerticalView = {
        return KlineVerticalView(frame: .zero)
    }()
    var currentPriceView: KlineCurrentPriceView = {
        let currentPrice = KlineCurrentPriceView(frame: .zero, update: true)
        return currentPrice
    }()
    
    lazy var mainTitle: NSTextField = {
        let label = NSTextField()
        label.font = NSFont.PingFang.regular.font(12)
        label.backgroundColor(backColor: NSColor.clear)
        label.layer?.borderColor = NSColor.blueColor.cgColor
        label.layer?.borderWidth = 1
        label.isEditable = false
        label.isEnabled = false
        return label
    }()
    lazy var volSubTitle: NSTextField = {
        let label = NSTextField()
        label.font = NSFont.PingFang.regular.font(12)
        label.backgroundColor(backColor: NSColor.clear)
        label.layer?.borderColor = NSColor.blueColor.cgColor
        label.layer?.borderWidth = 1
        label.isEditable = false
        label.isEnabled = false
        return label
    }()
    lazy var subTitle: NSTextField = {
        let label = NSTextField()
        label.font = NSFont.PingFang.regular.font(12)
        label.backgroundColor(backColor: NSColor.clear)
        label.layer?.borderColor = NSColor.blueColor.cgColor
        label.layer?.borderWidth = 1
        label.isEditable = false
        label.isEnabled = false
        return label
    }()
    
    var subTypeArray: [KlineIndexType] = []
    var currentMainType: KlineIndexType = .MA
    var precisions: Int = 0
    var mouseTrackingArea: NSTrackingArea!
   
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.backgroundColor(backColor: NSColor.blackColor)
        setUI()
    }
    
    func setUI() {
        addSubview(scrollView)
        
        
        candleChartView.delegate = self
        
        initChartView()
    }
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        if oldSize.width <= 0 && oldSize.height <= 0 {
            return
        }
        self.candleChartView.height = oldSize.height - 60
        self.candleChartView.reloadKlineView()
    }
    
    func initChartView() {
        addSubview(priceView)
        addSubview(quotaVolPriceView)
        addSubview(quotaPriceView)
        addSubview(leavView)
        addSubview(verticalView)
        addSubview(currentPriceView)
        addSubview(mainTitle)
        addSubview(volSubTitle)
        addSubview(subTitle)
        addConstrains()
        
    }
    func addConstrains() {
        scrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
            make.right.equalToSuperview().offset(-priceWidth)
        }
        leavView.isHidden = true
        leavView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(timeheight)
        }
        
        verticalView.isHidden = true
        verticalView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(timeWidth)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.left.equalToSuperview()
        }
        currentPriceView.isHidden = true
        currentPriceView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(timeheight)
        }
        priceView.snp.makeConstraints { (make) in
            make.width.equalTo(priceWidth)
            make.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.top)
            make.height.equalTo(((NSScreen.main?.frame.size.height)! - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorOrignY))
        }
        
        quotaVolPriceView.snp.makeConstraints { (make) in
            make.width.equalTo(priceWidth)
            make.right.equalToSuperview()
            make.top.equalTo(priceView.snp.bottom).offset(midDistance)
            make.height.equalTo(((NSScreen.main?.frame.size.height)! - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorScale))
        }
        
        quotaPriceView.snp.makeConstraints { (make) in
            make.width.equalTo(priceWidth)
            make.right.equalToSuperview()
            make.top.equalTo(quotaVolPriceView.snp.bottom).offset(midDistance)
            make.height.equalTo(((NSScreen.main?.frame.size.height)! - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorScale))
        }
        
        mainTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(midDistance)
            make.width.equalTo(300)
        }
        volSubTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(priceView.snp.bottom)
            make.height.equalTo(midDistance)
            make.width.equalTo(300)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(quotaVolPriceView.snp.bottom)
            make.height.equalTo(midDistance)
            make.width.equalTo(300)
        }
    }
    
    func updateDataSourece(datasource:[KLineModel], mainType:KlineIndexType, subTypes: [KlineIndexType], precision: Int){
        dataSource = datasource
        precisions = precision
        currentMainType = mainType
        subTypeArray = subTypes
        if subTypeArray.count > 1 {
            quotaPriceView.isHidden = false
        } else {
            quotaPriceView.isHidden = true
        }
        DispatchQueue.main.async {
            self.candleChartView.updateDataSourece(datasource: datasource,mainType: mainType, subTypes: subTypes, precision: precision)
            self.candleChartView.width =  (self.candleChartView.candleWidth + self.candleChartView.candleSpace) * CGFloat(self.dataSource.count)
                self.candleChartView.height = (NSScreen.main?.frame.size.height)! - 80 - 80 - 80 - 40
            self.scrollView.documentView = self.candleChartView
            self.updtaePriceLayout()
            self.candleChartView.reloadKlineView()
        }
    }
    
    func updtaePriceLayout() {
        self.priceView.snp.updateConstraints({ (make) in
            make.height.equalTo((self.scrollView.height - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorOrignY))
        })
        self.priceView.updateFrameWithHeight(height: (self.scrollView.height - CGFloat(scrollViewTopDistance) * 2.0) * CGFloat(orignIndicatorOrignY))
        self.quotaVolPriceView.snp.updateConstraints({ (make) in
            make.height.equalTo((self.scrollView.height - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorScale))
        })
        self.quotaVolPriceView.updateFrameWithHeight(height: (self.scrollView.height - CGFloat(scrollViewTopDistance) * 2.0) * CGFloat(orignIndicatorScale))
        self.quotaPriceView.snp.updateConstraints({ (make) in
            make.height.equalTo((self.scrollView.height - CGFloat(scrollViewTopDistance)) * CGFloat(orignIndicatorScale))
        })
        self.quotaPriceView.updateFrameWithHeight(height: (self.scrollView.height - CGFloat(scrollViewTopDistance) * 2.0) * CGFloat(orignIndicatorScale))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if mouseTrackingArea != nil {
            self.scrollView.removeTrackingArea(mouseTrackingArea)
        }
        mouseTrackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited,.mouseMoved,.activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(mouseTrackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        let point = event.locationInWindow
        let oldPositionX:Double = 0.0
        if fabs(oldPositionX - Double(point.x)) < Double(candleChartView.candleWidth + candleChartView.candleSpace) / 2.0 || point.y > self.bounds.height - CGFloat(scrollViewTopDistance) {
            return
        }
        
        leavView.isHidden = false
        verticalView.isHidden = false
        
    }
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        let point = event.locationInWindow
        if candleChartView.currentDisplayArray.isEmpty  {
            return
        }
        if point.x >= scrollView.documentView!.visibleRect.width  || point.y > self.bounds.height - CGFloat(scrollViewTopDistance){
            verticalView.isHidden = true
            leavView.isHidden = true
            return
        }
        let klineModel = getLongPressModelPostionWithXPostion(postionx: point.x)
        let xPositoin = klineModel.closesPoint.x
        if klineModel.closesPoint.x <= 0 {
            return
        }
        let mainAttStr = StringTools.relaodIndexTitleWithModel(model: klineModel, indexType: currentMainType)
        mainTitle.attributedText = mainAttStr
        for (_,subtype) in subTypeArray.enumerated() {
            let attStr = StringTools.relaodIndexTitleWithModel(model: klineModel, indexType: subtype)
            reloadCurrentIndextitle(attributedString: attStr, SubType: subtype, mainOrSub: .Sub)
        }
        leavView.isHidden = false
        leavView.updateNewPrice(newPrice: "\(klineModel.closePrice)", backgroundColor: NSColor.blueColor, precision: precisions)
        leavView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset( self.bounds.height - point.y - 7)
        }
        verticalView.isHidden = false
        verticalView.updateTimeString(timeString: klineModel.timeStr)
        verticalView.updateVerticalLine(heigh: CFloat(self.scrollView.height))
        verticalView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(xPositoin - candleChartView.leftPostion + candleChartView.candleWidth / 2.0 - CGFloat(timeWidth / 2.0))
        }
        
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        leavView.isHidden = true
        verticalView.isHidden = true
    }
    
    func getLongPressModelPostionWithXPostion(postionx: CGFloat) -> KLineModel {
        let localPostion = postionx
        
        
        var startIndex = Int((localPostion) / (candleChartView.candleWidth + candleChartView.candleSpace))
        startIndex = startIndex > 0 ? Int(startIndex) : 0
        var klineModel:KLineModel = KLineModel()
        if startIndex > candleChartView.currentDisplayArray.count - 1 {
            return klineModel
        }
        klineModel = candleChartView.currentDisplayArray[startIndex]
        let lastModel = candleChartView.currentDisplayArray.last
        if (localPostion + candleChartView.leftPostion) >= (lastModel?.closesPoint.x)! {
            klineModel = lastModel!
        }
        let firstModel = candleChartView.currentDisplayArray.first
        if (localPostion + candleChartView.leftPostion) <= (firstModel?.closesPoint.x)! {
            klineModel = firstModel!
        }
        return klineModel
    }
    override var isFlipped: Bool  {
        return true
    }
}

extension AbuKlineView: AbuKlineMainViewDelegate {
    func currentScreenleftPostionx(leftPostionx: CGFloat, leftIndex: Int, klineCount: Int) {
        
    }
    
    func refreshLastModel(model: KLineModel) {
        var close:Double = 0.0
        close = Double(model.closesPoint.y)
        currentPriceView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(close + midDistance)
        }
        currentPriceView.isHidden = false
        currentPriceView.updateNewPrice(newPrice: String("\(model.closePrice)"), backgroundColor: NSColor.blueColor, precision: precisions)
    }
    
    func reloadPriceViewWithPriceArr(priceArray: [String]) {
        priceView.reloadPriceWithPriceArr(priceArr: priceArray, precision: precisions)
    }
    
    func reloadPriceViewWithQuotaMaxValue(maxValue: Double, minValue: Double) {
        quotaPriceView.reloadPriceWithPriceArr(priceArr: ["\(maxValue)","\(minValue)"], precision: precisions)
    }
    
    func reloadPriceViewWithVolQuotaMaxValue(maxValue: Double, minValue: Double) {
        quotaVolPriceView.reloadPriceWithPriceArr(priceArr: ["\(maxValue)","\(minValue)"], precision: precisions)
    }
    
    func reloadMoreData() {
        
    }
    
    func reloadCurrentIndextitle(attributedString: NSMutableAttributedString, SubType: KlineIndexType, mainOrSub: KlineWireSubOrMain) {
        if mainOrSub == .Sub {
            if SubType == .VOL {
                volSubTitle.attributedText = attributedString
            } else  {
                subTitle.attributedText = attributedString
            }
        } else {
            mainTitle.attributedText = attributedString
            currentMainType = SubType
        }
    }
    
    
}


