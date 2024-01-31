//
//  SelectBackgroundView.swift
//  Poseidon
//
//  Created by fdd on 2024/1/30.
//

import Foundation
import UIKit
import SnapKit

class SelectBackgroundView: UIView {
    
    let selectView = {
        let view = UIView()
        return view
    }()
    
    let bgView = {
        let view = UIView()
        return view
    }()
    
    let borderView = {
        let view = UIView()
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white), for: .normal)
        return button
    }()
    
//    let rotateButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "rectangle.portrait.rotate", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white), for: .normal)
//        return button
//    }()
    
    weak var delegate: SelectBackgroundViewDelegate?
    var element: Element
    
    var previousTranslation = CGPoint(x: 0, y: 0)
    var previousAngle: CGFloat = 0
    var previousScale: CGFloat = 1
    
    init(element: Element) {
        self.element = element
        super.init(frame: CGRectZero)
        setupView()
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgViewTap)))
        
        selectView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panView(gesture:))))
        selectView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationView(gesture:))))
        selectView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleView(gesture:))))
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rotateButtonPanGesture(_:)))
//        rotateButton.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.left)
            make.centerY.equalTo(snp.top)
            make.width.equalTo(element.size.width)
            make.height.equalTo(element.size.height)
        }
        selectView.layer.transform = element.transform
        
        selectView.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(selectView.snp.left)
            make.top.equalTo(selectView.snp.top)
        }
        
//        selectView.addSubview(rotateButton)
//        rotateButton.snp.makeConstraints { make in
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
    }
    
    func refreshSelectView(transform: CATransform3D) {
        selectView.layer.transform = transform
//        deleteButton.layer.transform = transform
    }
    
    @objc func bgViewTap() {
        delegate?.cancelSelected()
    }
    
    @objc func panView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        if gesture.state == .changed {
            let x = translation.x - previousTranslation.x
            let y = translation.y - previousTranslation.y
            element.translate(tx: x, ty: y, tz: 0)
            refreshSelectView(transform: element.transform)
            previousTranslation = translation
            delegate?.operationSelectView(element: element)
        } else {
            previousTranslation = CGPoint(x: 0, y: 0)
        }
    }
    
    @objc func rotationView(gesture: UIRotationGestureRecognizer) {
        if gesture.state == .changed {
            let rotationAngle: CGFloat = gesture.rotation - previousAngle
            element.rotate(angle: rotationAngle, 0, 0, 1)
            refreshSelectView(transform: element.transform)
            previousAngle = gesture.rotation
            delegate?.operationSelectView(element: element)
        } else if gesture.state == .ended {
            previousAngle = 0
        }
    }
    
    @objc func scaleView(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale - previousScale
            element.scale(sx: 1 + scale * 0.5, sy: 1 + scale * 0.5, sz: 1)
            refreshSelectView(transform: element.transform)
            previousScale = gesture.scale
            delegate?.operationSelectView(element: element)
        } else if gesture.state == .ended {
            previousScale = 1
        }
    }
    
    @objc func deleteButtonClick() {
        delegate?.deleteBtnDidClick(element: element)
    }
    
//    var previousRotateCenterPoint = CGPointZero
//    @objc func rotateButtonPanGesture(_ gesture: UIPanGestureRecognizer) {
//        guard let button = gesture.view as? UIButton else { return }
//        
//        // 获取拖动手势的位置
//        let translation = gesture.translation(in: selectView)
//        let buttonCenter = convert(button.center, to: selectView)
//        let selectViewCenter = selectView.center
//        let rotationAngle = atan2(translation.y, translation.x)
////        print("previousRotateCenterPoint: \(translation), \(rotationAngle)")
//        
//        switch gesture.state {
//        case .changed:
//                    print("\(calculateAngleBetweenPoints(point1: previousRotateCenterPoint, point2: translation))")
//        default:
//            break
//        }
//        previousRotateCenterPoint = translation
//    }
//    func calculateAngleBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
//        let deltaX = point2.x - point1.x
//        let deltaY = point2.y - point1.y
//        return atan2(deltaY, deltaX)
//    }
}

protocol SelectBackgroundViewDelegate: AnyObject {
    
    func operationSelectView(element: Element)
    func deleteBtnDidClick(element: Element)
    func cancelSelected()
}
