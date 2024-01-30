//
//  CanvasController.swift
//  Poseidon
//
//  Created by fdd on 2024/1/29.
//

import Foundation
import GLKit
import SwiftUI
import Combine

class MessageViewModel: ObservableObject {
    @Published var element: Element?
}

class CanvasController: GLKViewController {
    
    private var cancellables = Set<AnyCancellable>()
    let messageViewModel: MessageViewModel
    
    let canvasControl = CanvasControl()
    var shapeElement = {
        var element = ShapeElement(size: CGSizeMake(100, 200), color: .red)
        element.rotate(angle: 3.14 / 4, 0, 0, 1)
        element.scale(sx: 1.5, sy: 1.5, sz: 1)
        element.translate(tx: 200, ty: 200, tz: 0)
        return element
    }()
    
    init(messageViewModel: MessageViewModel) {
        self.messageViewModel = messageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES3)!
        glkView.drawableDepthFormat = .format24
        EAGLContext.setCurrent(glkView.context)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panView(gesture:))))
        view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationView(gesture:))))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleView(gesture:))))
        
        // 使用 Combine 监听 @Published 属性的更改
        messageViewModel.$element
            .sink { [weak self] element in
                if element != nil {
                    self?.canvasControl.addElement(element!)
                }
            }
            .store(in: &cancellables)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        canvasControl.viewPort(width: view.drawableWidth, height: view.drawableHeight)
//        canvasControl.addElement(shapeElement)
        canvasControl.draw()
    }
    
    var previousTranslation = CGPoint(x: 0, y: 0)
    @objc func panView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .changed {
            let x = translation.x - previousTranslation.x
            let y = translation.y - previousTranslation.y
            shapeElement.translate(tx: x, ty: y, tz: 0)
            previousTranslation = translation
        } else {
            previousTranslation = CGPoint(x: 0, y: 0)
        }
    }
    
    var previousAngle: CGFloat = 0
    @objc func rotationView(gesture: UIRotationGestureRecognizer) {
        if gesture.state == .changed {
            let rotationAngle: CGFloat = gesture.rotation - previousAngle
            shapeElement.rotate(angle: rotationAngle, 0, 0, 1)
            previousAngle = gesture.rotation
        } else if gesture.state == .ended {
            previousAngle = 0
        }
    }
    
    var previousScale: CGFloat = 1
    @objc func scaleView(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale - previousScale
            shapeElement.scale(sx: 1 + scale * 0.5, sy: 1 + scale * 0.5, sz: 1)
            previousScale = gesture.scale
        } else if gesture.state == .ended {
            previousScale = 1
        }
    }
}

struct CanvasView: UIViewControllerRepresentable {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let ctrl = CanvasController(messageViewModel: messageViewModel)
        return ctrl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
