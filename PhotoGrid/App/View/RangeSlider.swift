//
//  RangeSlider.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        // Clip
        let cornerRadius = bounds.height / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        // Fill the track
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Fill the highlighted range
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
        let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
        let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        ctx.fill(rect)
    }
}

class RangeSliderThumbLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    var isSelected: Bool = false
    
    var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var textValue: String = "0" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        let thumbPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4)
        
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        UIGraphicsPushContext(ctx)
        let font = UIFont.systemFont(ofSize: 15)
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

        let string = NSAttributedString(string: textValue, attributes: [
            NSAttributedString.Key.font: font,
            .foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        
        
        let rect = string.boundingRect(with: bounds.size, context: nil)
        string.draw(in: .init(origin: .init(x: (bounds.width - rect.width) / 2 , y: (bounds.height - rect.height) / 2), size: rect.size))
        UIGraphicsPopContext()
    }
}

public class RangeSlider: UIControl {
    public var minimumValue: Double = 0.0 {
        willSet(newValue) {
            assert(newValue < maximumValue, "RangeSlider: minimumValue should be lower than maximumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    public var maximumValue: Double = 1.0 {
        willSet(newValue) {
            assert(newValue > minimumValue, "RangeSlider: maximumValue should be greater than minimumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    public var lowerValue: Double = 0.2 {
        didSet {
            if lowerValue < minimumValue {
                lowerValue = minimumValue
            }
            
            lowerThumbLayer.textValue = "\(Int(lowerValue))"
            updateLayerFrames()
        }
    }
    
    public var upperValue: Double = 0.8 {
        didSet {
            if upperValue > maximumValue {
                upperValue = maximumValue
            }
            
            upperThumbLayer.textValue = "\(Int(upperValue))"
            updateLayerFrames()
        }
    }
    
    var gapBetweenThumbs: Double {
        return 1 * Double(thumbWidth) * (maximumValue - minimumValue) / Double(bounds.width - thumbWidth)
    }
    
    public var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    public var trackHeight: CGFloat = 4 {
        didSet {
            updateLayerFrames()
        }
    }
    
    fileprivate var previouslocation = CGPoint()
    
    fileprivate let trackLayer = RangeSliderTrackLayer()
    fileprivate let lowerThumbLayer = RangeSliderThumbLayer()
    fileprivate let upperThumbLayer = RangeSliderThumbLayer()
    
    fileprivate var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override public var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeLayers()
    }
    
    override public func layoutSublayers(of: CALayer) {
        super.layoutSublayers(of:layer)
        updateLayerFrames()
    }
    
    fileprivate func initializeLayers() {
        layer.backgroundColor = UIColor.clear.cgColor
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        lowerThumbLayer.textValue = "21"
        upperThumbLayer.textValue = "49"
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = .init(x: 0, y: (bounds.height - trackHeight) / 2, width: bounds.width, height: trackHeight)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth/2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth/2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(_ value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth/2.0)
    }
    
    func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    
    // MARK: - Touches
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previouslocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previouslocation) {
            lowerThumbLayer.isSelected = true
        } else if upperThumbLayer.frame.contains(previouslocation) {
            upperThumbLayer.isSelected = true
        }
        
        return lowerThumbLayer.isSelected || upperThumbLayer.isSelected
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previouslocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previouslocation = location
        
        // Update the values
        if lowerThumbLayer.isSelected {
            lowerValue = boundValue(lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: upperValue - gapBetweenThumbs)
        } else if upperThumbLayer.isSelected {
            upperValue = boundValue(upperValue + deltaValue, toLowerValue: lowerValue + gapBetweenThumbs, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isSelected = false
        upperThumbLayer.isSelected = false
    }
}
