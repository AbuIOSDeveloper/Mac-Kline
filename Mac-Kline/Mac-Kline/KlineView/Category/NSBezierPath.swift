//
//  NSBezierPath.swift
//  Mac-KLine
//
//  Created by 阿布 on 2018/12/22.
//  Copyright © 2018 阿布. All rights reserved.
//

import Cocoa

extension CGMutablePath {
    open class func drawWireLine(linesArray: [Dictionary<String, Double>]) -> CGMutablePath {
        let wireLinePath = CGMutablePath()
        for (index,postion) in linesArray.enumerated() {
            let point:NSPoint = NSPoint(x: postion["x"]!, y: postion["y"]!)
            if index == 0 {
                wireLinePath.move(to: NSPoint(x: point.x, y: point.y))
            } else {
                wireLinePath.addLine(to: NSPoint(x: point.x, y: point.y))
            }
        }
        return wireLinePath
    }
    open class func drawKLine(open: CGFloat, close: CGFloat, high: CGFloat, low: CGFloat, candleWidth: CGFloat, xPostion: CGFloat, lineWidth: CGFloat) -> CGMutablePath {
        let candlePath = CGMutablePath()
        let y = open > close ? close : open
        let height = CGFloat(abs(close - open))
        candlePath.move(to: NSPoint(x: xPostion, y: y))
        candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: y))
        if y > height {
            candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: high))
            candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: y))
        }
        candlePath.addLine(to: NSPoint(x: xPostion + candleWidth, y: y))
        candlePath.addLine(to: NSPoint(x: xPostion + candleWidth, y: y + height))
        candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: y + height))
        if (y + height) < low {
            candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: low))
            candlePath.addLine(to: NSPoint(x: xPostion + candleWidth / 2.0, y: y + height))
        }
        candlePath.addLine(to: NSPoint(x: xPostion , y: y + height))
        candlePath.addLine(to: NSPoint(x: xPostion, y: y))
        candlePath.closeSubpath()
        return candlePath
    }
}
