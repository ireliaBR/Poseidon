//
//  CanvasController.swift
//  Poseidon
//
//  Created by fdd on 2024/1/29.
//

import Foundation
import GLKit
import SwiftUI

class CanvasController: UIViewController, GLKViewDelegate {
    
    lazy var glkView = {
        let view = GLKView()
        view.context = EAGLContext(api: .openGLES3)!
        view.drawableDepthFormat = .format24
        view.delegate = self
        EAGLContext.setCurrent(view.context)
        return view
    }()
    
    let canvasControl = CanvasControl()
    let shapeElement = ShapeElement(size: CGSizeZero, color: .red)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = glkView
    }

    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        canvasControl.viewPort(width: view.drawableWidth, height: view.drawableHeight)
        canvasControl.addElement(shapeElement)
    }
}

struct CanvasView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CanvasController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
