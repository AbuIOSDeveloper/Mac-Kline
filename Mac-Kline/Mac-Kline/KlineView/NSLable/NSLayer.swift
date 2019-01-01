//
//  NSLayer.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/28.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa
import QuartzCore

internal class NSLayer: CALayer {
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        delegate?.draw?(self, in: ctx)
        ctx.restoreGState()
    }
}
