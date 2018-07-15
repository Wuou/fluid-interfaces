//
//  Pip.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class PipInterfaceViewController: InterfaceViewController {
    
    private lazy var pipView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0xF2F23A)
        view.bottomColor = UIColor(hex: 0xF7A51C)
        view.cornerRadius = 16
        return view
    }()
    
    private var pipPositionViews = [PipPositionView]()
    
    private let panRecognizer = UIPanGestureRecognizer()
    
    private var pipPositions: [CGPoint] {
        return pipPositionViews.map { $0.center }
    }
    
    private let pipWidth: CGFloat = 86
    private let pipHeight: CGFloat = 130
    
    private let horizontalSpacing: CGFloat = 23
    private let verticalSpacing: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topLeftView = addPipPositionView()
        topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        topLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let topRightView = addPipPositionView()
        topRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        topRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let bottomLeftView = addPipPositionView()
        bottomLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        bottomLeftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        let bottomRightView = addPipPositionView()
        bottomRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        view.addSubview(pipView)
        pipView.translatesAutoresizingMaskIntoConstraints = false
        pipView.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        pipView.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(pipPanned(recognizer:)))
        pipView.addGestureRecognizer(panRecognizer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pipView.center = pipPositions.last ?? .zero
    }
    
    private func addPipPositionView() -> PipPositionView {
        let view = PipPositionView()
        self.view.addSubview(view)
        pipPositionViews.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        return view
    }
    
    private var initialOffset: CGPoint = .zero
    
    @objc private func pipPanned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - pipView.center.x, y: touchPoint.y - pipView.center.y)
        case .changed:
            pipView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            ()
        default: break
        }
    }
    
}

class PipPositionView: UIView {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(white: 0.3, alpha: 1).cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private let lineWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: bounds.minX + lineWidth / 2, y: bounds.minY + lineWidth / 2, width: bounds.width - lineWidth, height: bounds.height - lineWidth), cornerRadius: 16).cgPath
    }
    
}

///// Distance traveled after decelerating to zero velocity at a constant rate.
//func project(initialVelocity: Float, decelerationRate: Float) -> Float {
//    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
//}

// After the PiP is thrown, determine the best corner and re-target it there.
// (put this is pan gesture ended)

//let decelerationRate = UIScrollView.DecelerationRate.normal
//
//let projectedPosition = (
//    x: x.value + project(initialVelocity: x.velocity, decelerationRate: decelerationRate)
//    y: y.value + project(initialVelocity: y.velocity, decelerationRate: decelerationRate),
//)
//
//let nearestCornerPosition = nearestCornerTo(projectedPosition)
//
//x.target = nearestCornerPosition.x
//y.traget = nearestCornerPosition.y
