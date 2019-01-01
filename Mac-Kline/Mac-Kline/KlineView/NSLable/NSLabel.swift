//
//  NSLabel.swift
//  Mac-KLine
//
//  Created by yskj21.5 on 2018/12/28.
//  Copyright © 2018年 阿布. All rights reserved.
//

import Cocoa
import Foundation

public typealias Rect = NSRect
public typealias Size = NSSize
public typealias EdgeInsets = NSEdgeInsets
public typealias Font = NSFont
public typealias View = NSView
public typealias Color = NSColor
public typealias LineBreakMode = NSLineBreakMode
public typealias LayoutPriority = NSLayoutConstraint.Priority

class NSLabel: NSView {

    private static var sizeCache = [String: Rect]()
    internal var shouldAntialias = true
    internal var shouldSmoothFonts = true
    internal var shouldSubpixelPositionFonts = false
    internal var shouldSubpixelQuantizeFonts = false
    
    public init() {
        super.init(frame: Rect.zero)
        commonInit()
    }
    
    public override init(frame _: Rect) {
        super.init(frame: Rect.zero)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        #if os(iOS)
        let isRetina = UIScreen.main.scale >= 2.0
        shouldSubpixelPositionFonts = !isRetina
        shouldSubpixelQuantizeFonts = !isRetina
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        #elseif os(OSX)
        wantsLayer = true
        canDrawConcurrently = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        #endif
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        labelLayer?.drawsAsynchronously = true
        labelLayer?.delegate = self
    }
    
    internal func draw(context: CGContext) {
        context.textMatrix = .identity
        context.setAllowsAntialiasing(true)
        context.setAllowsFontSmoothing(true)
        context.setAllowsFontSubpixelPositioning(true)
        context.setAllowsFontSubpixelQuantization(true)
        
        context.setShouldAntialias(shouldAntialias)
        context.setShouldSmoothFonts(shouldSmoothFonts)
        context.setShouldSubpixelPositionFonts(shouldSubpixelPositionFonts)
        context.setShouldSubpixelQuantizeFonts(shouldSubpixelQuantizeFonts)
        
        #if os(iOS)
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)
        #endif
        
        let leftX = drawingRect.minX + insets.left
        let rightX = drawingRect.maxX - insets.right
        let topY = drawingRect.maxY - insets.top
        let bottomY = drawingRect.minY + insets.bottom
        
        switch textAlignment {
        case .right:
            context.translateBy(x: bounds.maxX - insets.right - rightX, y: 0)
        case .center:
            context.translateBy(x: bounds.midX - drawingRect.width / 2, y: 0)
        default: break
        }
        
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: leftX, y: bottomY))
        mutablePath.addLine(to: CGPoint(x: rightX, y: bottomY))
        mutablePath.addLine(to: CGPoint(x: rightX, y: topY))
        mutablePath.addLine(to: CGPoint(x: leftX, y: topY))
        mutablePath.closeSubpath()
        var attributedString = NSAttributedString(string:"")
        if (text?.isEmpty) != nil  && attributedText == nil{
            attributedString = NSAttributedString(string:text ?? "", attributes: defaultAttributedDict)
        } else if attributedText != nil {
            attributedString = attributedText!
        }
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attributedString.length), mutablePath, nil)
        CTFrameDraw(frame, context)
    }
    
    internal func calculateRect() {
        defer {
            setNeedsDisplayLayer()
        }
        
        let cacheKey = ("\(text ?? "")-\(font.fontName)-\(font.pointSize)-" +
            "\(textAlignment.rawValue)-\(lineSpacing)-\(numberOfLines)-" +
            "\(lineBreakMode)-\(preferredMaxLayoutWidth ?? bounds.width)-" +
            "\(insets)")
        
        if let cachedSize = NSLabel.sizeCache[cacheKey] {
            drawingRect = cachedSize
            return
        }
        
        let width = max(0, (preferredMaxLayoutWidth ?? bounds.width) - insets.left - insets.right)
        var attributedString = NSAttributedString(string:"")
        if (text?.isEmpty) != nil  && attributedText == nil{
            attributedString = NSAttributedString(string:text ?? "", attributes: defaultAttributedDict)
        } else if attributedText != nil  {
            attributedString = attributedText!
            print("attributedString ---->",attributedText!)
        }
        
        let setter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        var size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRange(location: 0, length: attributedString.length), nil,
                                                                CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)
        if numberOfLines > 0 {
            let path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
            let ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, nil)
            let currentLines = CFArrayGetCount(CTFrameGetLines(ctFrame)) as Int
            let calculatedHeight = (size.height / CGFloat(currentLines)) * CGFloat(numberOfLines)
            size.height = calculatedHeight <= size.height ? calculatedHeight : size.height
        }
        
        drawingRect.size.width = ceil(size.width + insets.left + insets.right)
        drawingRect.size.height = ceil(size.height + insets.top + insets.bottom)
        NSLabel.sizeCache[cacheKey] = drawingRect
    }
    
    internal func setNeedsDisplayLayer() {
        labelLayer?.setNeedsDisplay()
    }
    
    private var defaultAttributedDict: [NSAttributedString.Key: Any] {
        var attributes = [
            NSAttributedString.Key.font: self.font,
            NSAttributedString.Key.foregroundColor: self.textColor,
            NSAttributedString.Key.backgroundColor: self.textBackground,
            NSAttributedString.Key.paragraphStyle: self.drawingParagraphStyle,
            NSAttributedString.Key.kern: self.kerning,
            ] as [NSAttributedString.Key: Any]
        
        if let shadow = textShadow {
            attributes[NSAttributedString.Key.shadow] = shadow
        }
        return attributes
    }
    
    
    
    open override var intrinsicContentSize: Size {
        return drawingRect.size
    }
    
    open var drawingParagraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing
        return style
    }
    
    internal var labelLayer: NSLayer? {
        return layer as? NSLayer
    }
    
    open override var frame: Rect {
        didSet {
            if oldValue.size.equalTo(frame.size) { return }
            calculateRect()
        }
    }
    
    open override var bounds: Rect {
        didSet {
            if oldValue.size.equalTo(bounds.size) { return }
            calculateRect()
        }
    }
    
    private var drawingRect: CGRect = .zero {
        didSet {
            if oldValue.equalTo(drawingRect) { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable open var text: String? {
        didSet {
            if oldValue == text { return }
            calculateRect()
        }
    }
    
    @IBInspectable open var attributedText: NSAttributedString? {
        didSet {
            if oldValue == attributedText { return }
            calculateRect()
        }
    }
    
    
    @IBInspectable open var textColor = Color.black {
        didSet {
            if oldValue == textColor { return }
            setNeedsDisplayLayer()
        }
    }
    
    @IBInspectable open var textBackground = Color.clear {
        didSet {
            if oldValue == textBackground { return }
            setNeedsDisplayLayer()
        }
    }
    
    open var textShadow: NSShadow? {
        didSet {
            setNeedsDisplayLayer()
        }
    }
    
    @IBInspectable open var font = Font.systemFont(ofSize: 14) {
        didSet {
            if oldValue == font { return }
            calculateRect()
        }
    }
    
    open var textAlignment: NSTextAlignment = .left {
        didSet {
            if oldValue == textAlignment { return }
            calculateRect()
        }
    }
    
    @IBInspectable open var numberOfLines = 1 {
        didSet {
            if oldValue == numberOfLines { return }
            calculateRect()
        }
    }
    
    open var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            if oldValue == preferredMaxLayoutWidth { return }
            calculateRect()
        }
    }
    
    @IBInspectable open var lineSpacing: CGFloat = 0.0 {
        didSet {
            if oldValue == lineSpacing { return }
            calculateRect()
        }
    }
    
    @IBInspectable open var kerning: CGFloat = 0.0 {
        didSet {
            if oldValue == kerning { return }
            calculateRect()
        }
    }
    
    open var lineBreakMode: LineBreakMode = .byTruncatingTail {
        didSet {
            if oldValue == lineBreakMode { return }
            calculateRect()
        }
    }
    
    open var insets: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            calculateRect()
        }
    }
}

