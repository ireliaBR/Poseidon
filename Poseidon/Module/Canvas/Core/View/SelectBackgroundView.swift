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
    
    let borderView = {
        let view = UIView()
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.black), for: .normal)
        return button
    }()
    
    weak var delegate: SelectBackgroundViewDelegate?
    var element: Element
    
    var previousTranslation = CGPoint(x: 0, y: 0)
    var previousAngle: CGFloat = 0
    var previousScale: CGFloat = 1
    
    init(element: Element) {
        self.element = element
        super.init(frame: CGRectZero)
        setupView()
        
        selectView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panView(gesture:))))
        selectView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationView(gesture:))))
        selectView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleView(gesture:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
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
            make.centerX.equalTo(selectView.snp.left)
            make.centerY.equalTo(selectView.snp.top)
        }
    }
    
    func refreshSelectView(transform: CATransform3D) {
        selectView.layer.transform = transform
//        deleteButton.layer.transform = transform
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
}

protocol SelectBackgroundViewDelegate: AnyObject {
    func operationSelectView(element: Element)
    func deleteBtnDidClick(element: Element)
}
