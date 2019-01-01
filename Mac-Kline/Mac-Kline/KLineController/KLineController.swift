//
//  KLineController.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/18.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa
import SwiftyJSON

class KLineController: NSViewController {
    lazy var klineView: AbuKlineView = {
        let klineView = AbuKlineView(frame: .zero)
        return klineView
    }()
    var klineMeun: KlineMenu = {
        let config = MenuConfig()
        config.titleColor = NSColor.lightGray
        config.titleSelectedColor = NSColor.red
        config.indicatorColor = NSColor.blueColor
        config.borderColor = NSColor.purple
        config.borderSelectedColor = NSColor.red
        config.titleFont = NSFont.PingFang.regular.font(13)
        config.klineTypes = [.MIN1,.MIN5,.MIN15,.MIN30,.HOUR1,.HOUR4,.DAY,.WEEK,.MONTH,.YEAR]
        let meun = KlineMenu(frame: .zero, titles: ["1M","5M","15M","30M","1H","4H","1D","1W","1MN","1Y"], config: config)
        return meun
    }()
    private var currentRequestType: String = "M"
    private var currentKlineType:KLINETYPE = .MIN1
    var dataSource = [KLineModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view = klineView
        view.addSubview(klineMeun)
        klineMeun.delegate = self
        addConstraint()
        requestKlineListWithKlineType(type: currentKlineType)
    }
    
    func addConstraint(){
        klineMeun.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().offset(-priceWidth)
            make.height.equalTo(40)
        }
    }
    
    func requestKlineListWithKlineType(type:KLINETYPE) {
        var resource: String = ""
        var requestType: String = ""
        switch type {
        case .MIN1:
            resource = "stock1"
            requestType = "M"
        case .MIN5:
            resource = "stock5"
            requestType = "M"
        case .MIN15:
            resource = "stock15"
            requestType = "M"
        case .MIN30:
            resource = "stock30"
            requestType = "M"
        case .HOUR1:
            resource = "stock60"
            requestType = "M"
        case .HOUR4:
            resource = "stock5"
            requestType = "M"
        case .DAY:
            resource = "stockDay"
            requestType = "D"
        case .WEEK:
            resource = "stock15"
            requestType = "W"
        case .MONTH:
            resource = "stock30"
            requestType = "MN"
        case .YEAR:
            resource = "stock60"
            requestType = "MN"
        default:
            break
        }
        currentRequestType = requestType
        let path = Bundle.main.path(forResource: resource, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            if self.dataSource.count > 0 {
                self.dataSource.removeAll()
            }
            for (index,dic) in json["d"]["p"].arrayValue.enumerated() {
                let model: KLineModel = KLineModel(json: dic)!
                model.timestamp = updateTime(time: model.date)
                model.timeStr = updateTime(timestamp: model.timestamp)
                model.xPoint = index
                if (index % 16 == 0)
                {
                    model.isDrawDate = true
                }
                self.dataSource.append(model)
            }
            self.dataSource = KLineIndexCalculate.sharedManager.initializeQuotaDataWithArray(dataArray: self.dataSource, type: .VOL)
            DispatchQueue.main.async {
                self.klineView.updateDataSourece(datasource: self.dataSource, mainType: .MA,subTypes:[.VOL,.MACD], precision: 2)
            }
        } catch  {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTime(time: String) -> Int {
        let datefmatter = DateFormatter()
        
        datefmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        let timeArray = time.components(separatedBy: "T")
        let dateArray = timeArray.first?.components(separatedBy: "-")
        var dateString: String = ""
        for (index,str) in (dateArray?.enumerated())! {
            if index == 0 {
                dateString = dateString + str + "年"
            } else if index == 1 {
                dateString = dateString + str + "月"
            } else if index == 2 {
                dateString = dateString + str + "日 "
            }
        }
        let date = datefmatter.date(from: dateString + timeArray.last!)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        
        let dateStr:Int = Int(dateStamp)
        
        return dateStr
    }
    
    func updateTime(timestamp: Int) -> String {
        let timeInterval: TimeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformater = DateFormatter()
        if currentRequestType.contains("D") || currentRequestType.contains("W") || currentRequestType.contains("MN"){
            dformater.dateFormat = "MM月dd日"
        } else if currentRequestType.contains("M") {
            dformater.dateFormat = "MM月dd日 HH:mm"
        }
        return dformater.string(from: date)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

extension KLineController: KlineMenuDelegate {
    
    func didSelectedIndex(klineType: KLINETYPE) {
        print(klineType)
        currentKlineType = klineType
        requestKlineListWithKlineType(type: currentKlineType)
    }
}
