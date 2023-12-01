//
//  AgeSlider.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

class AgeSlider1: UIView {
    let lineHeight: CGFloat = 4
    let squareWidth: CGFloat = 32
    let radius = 4
    
    var squareLayers: [CAShapeLayer] = []
    
    func setupLayers() {
        guard squareLayers.isEmpty else { return }
        
        layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
      
        let layer1 = drawSquareInCoords()
        let layer2 = drawSquareInCoords()
        layer2.frame = .init(x: frame.width - squareWidth, y: 0, width: squareWidth, height: squareWidth)
        layer1.frame = .init(x: 0, y: 0, width: squareWidth, height: squareWidth)
        
        let layer3 = drawLineLayer(color: Colors.bgColor.cgColor)
        layer3.frame = .init(x: 0, y: (frame.height - lineHeight) / 2, width: frame.width, height: lineHeight)
        layer.addSublayer(layer3)
        
        let layer4 = drawLineLayer(color: Colors.sliderColor.cgColor)
        layer4.frame = .init(x: 0, y: (frame.height - lineHeight) / 2, width: frame.width, height: lineHeight)
        layer.addSublayer(layer4)
        
        layer.addSublayer(layer1)
        layer.addSublayer(layer2)
        
        squareLayers.append(contentsOf: [layer1, layer2])
        
        squareLayers.forEach{ print("layer frame = \($0.frame)") }
    }
    
    func drawLineLayer(color: CGColor) -> CAShapeLayer {
        let lineHeight: CGFloat = 4
        let cornerRadius: CGFloat = 2
        
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: .init(x: cornerRadius, y: 0))
        path.addLine(to: .init(x: frame.width - cornerRadius, y: 0))
        path.addArc(withCenter: .init(x: frame.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        path.addLine(to: .init(x: cornerRadius, y: lineHeight))
        path.addArc(withCenter: .init(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        path.close()
        
        layer.path = path.cgPath
        layer.fillColor = color
        
        return layer
    }
    
    func drawSquareInCoords() -> CAShapeLayer {
        let width: CGFloat = 32
        let corderRadius: CGFloat = 4
        
        let squareLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let pi2 = CGFloat.pi / 2
        
        path.move(to: .init(x: corderRadius, y: 0))
        path.addLine(to: .init(x: width - corderRadius, y: 0))
        path.addArc(withCenter: .init(x: width - corderRadius, y: corderRadius), radius: corderRadius, startAngle: -pi2, endAngle: 0, clockwise: true)
        path.addLine(to: .init(x: width, y: width - 4))
        path.addArc(withCenter: .init(x: width - corderRadius, y: width - corderRadius), radius: corderRadius, startAngle: 0, endAngle: pi2, clockwise: true)
        path.addLine(to: .init(x: corderRadius, y: width))
        path.addArc(withCenter: .init(x: corderRadius, y: width - corderRadius), radius: corderRadius, startAngle: pi2, endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: .init(x: 0, y: corderRadius))
        path.addArc(withCenter: .init(x: corderRadius, y: corderRadius), radius: corderRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
        path.close()
        
        squareLayer.path = path.cgPath
        squareLayer.fillColor = Colors.mainBlue.cgColor
        
       return squareLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    var selectedLayer: CAShapeLayer?
    
    init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panno))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1

        self.addGestureRecognizer(pan)
    }

    @objc private func panno(gesture: UIPanGestureRecognizer) {
        let location: CGPoint = gesture.location(in: self)

//        print("location = \(location)")
        
        switch gesture.state {
        case .began:
            for layer in squareLayers {
                print("layer.frame = \(layer.frame) and contains = \(layer.frame.contains(location))")
                if layer.frame.contains(location) {
                    print("isContains location = \(layer.path?.contains(location)) ,, path = \(layer)")
                    selectedLayer = layer
                }
            }
        case .changed:
            print("CaLayer.frame = ", selectedLayer?.frame)
            let translation = gesture.translation(in: self)
            print("translation = \(translation)")
//            guard translation.x > 0 else { return }
            
            guard let selectedLayer = selectedLayer else { return }
//            selectedLayer.frame = CGRect(origin: .init(x: translation.x, y: selectedLayer.frame.origin.y), size: selectedLayer.frame.size)
            selectedLayer.transform = CATransform3DMakeTranslation(translation.x, 0, 0)
        case .ended:
            selectedLayer = nil
        default:
            break
        }

//        previousPoint = currentPoint
//        self.setNeedsDisplay()
    }
}
