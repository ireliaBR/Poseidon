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

class CanvasController: GLKViewController, SelectBackgroundViewDelegate {
    
    private var cancellables = Set<AnyCancellable>()
    let messageViewModel: MessageViewModel
    
    var selectBGView: SelectBackgroundView?
    let canvasControl = CanvasControl()
    lazy var gestureView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView(gesture:))))
        return view
    }()
    
    var tapAction: (() -> Void)?
    
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
        
        view.addSubview(gestureView)
        gestureView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        canvasControl.draw()
    }
    
    @objc func tapView(gesture: UITapGestureRecognizer) {
        tapAction?()
        let location = gesture.location(in: view)
        guard canvasControl.elements.count > 0 else { return }
        for index in stride(from: canvasControl.elements.count - 1, through: 0, by: -1) {
            let element = canvasControl.elements[index]
            guard element.inside(point: location) else { continue }
            selectBGView = {
                let view = SelectBackgroundView(element: element)
                view.delegate = self
                return view
            }()
            if let selectBGView {
                view.addSubview(selectBGView)
                selectBGView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
   
    func operationSelectView(element: Element) {
        canvasControl.refreshElement(element)
    }
    
    func deleteBtnDidClick(element: Element) {
        canvasControl.deleteElement(element)
        selectBGView?.removeFromSuperview()
        selectBGView = nil
    }
    
    func cancelSelected() {
        selectBGView?.removeFromSuperview()
        selectBGView = nil
    }
}

struct CanvasView: UIViewControllerRepresentable {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    var tapAction: (() -> Void)?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let ctrl = CanvasController(messageViewModel: messageViewModel)
        ctrl.tapAction = tapAction
        return ctrl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
