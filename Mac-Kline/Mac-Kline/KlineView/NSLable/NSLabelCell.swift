//
//  NSLabelCell.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/28.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa

extension NSLabel: CALayerDelegate {
    public func draw(_: CALayer, in ctx: CGContext) {
        draw(context: ctx)
    }
    
    open override func makeBackingLayer() -> CALayer {
        return NSLayer()
    }
    
    open override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        let scale = window?.backingScaleFactor ?? 1.0
        let isRetina = scale >= 2.0
        shouldSmoothFonts = true
        shouldAntialias = true
        shouldSubpixelPositionFonts = !isRetina
        shouldSubpixelQuantizeFonts = !isRetina
        layer?.contentsScale = scale
        layer?.rasterizationScale = scale
        setNeedsDisplayLayer()
    }
    
    open override var isFlipped: Bool {
        return false
    }
}
