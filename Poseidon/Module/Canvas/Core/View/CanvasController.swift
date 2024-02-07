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
import OpenGLES

class MessageViewModel: ObservableObject {
    @Published var element: Element?
    @Published var cancelSelected: Bool?
    
    @Published var currentElement: Element?
    
    @Published var addFilter: [BaseFilter]?
}

class CanvasController: UIViewController, SelectBackgroundViewDelegate {
    
    private var cancellables = Set<AnyCancellable>()
    let messageViewModel: MessageViewModel
    
    var selectBGView: SelectBackgroundView?
    lazy var canvasControl = CanvasControl()
    lazy var gestureView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView(gesture:))))
        return view
    }()
    
    let glkLayer = {
        let layer = CAEAGLLayer()
        layer.isOpaque = true
        layer.contentsScale = CanvasControl.scale
        layer.drawableProperties = [
            kEAGLDrawablePropertyRetainedBacking: false,
            kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
        ]
        return layer
    }()
    
    var tapAction: (() -> Void)?
    
    init(messageViewModel: MessageViewModel) {
        self.messageViewModel = messageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        glkLayer.frame = view.bounds;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        canvasControl.viewPort(width: Int(view.frame.size.width * CanvasControl.scale), height: Int(view.frame.size.height * CanvasControl.scale))
        canvasControl.ctx?.renderbufferStorage(Int(GL_RENDERBUFFER), from: glkLayer)
        canvasControl.draw()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(glkLayer)
        view.addSubview(gestureView)
        gestureView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 使用 Combine 监听 @Published 属性的更改
        messageViewModel.$element
            .sink { [weak self] element in
                if element != nil {
                    self?.canvasControl.addElement(element!)
                    self?.canvasControl.draw()
                }
            }
            .store(in: &cancellables)
        messageViewModel.$cancelSelected
            .sink { [weak self] cancelSelected in
                if let cancelSelected, cancelSelected {
                    self?.selectBGView?.removeFromSuperview()
                    self?.selectBGView = nil
                }
            }
            .store(in: &cancellables)
        
    messageViewModel.$addFilter
        .sink { [weak self] filter in
            guard let filter, let element = self?.messageViewModel.currentElement else {
                return
            }
            self?.canvasControl.filter(element: element, filters: filter)
            self?.canvasControl.draw()
        }
        .store(in: &cancellables)
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
                messageViewModel.currentElement = element
                view.addSubview(selectBGView)
                selectBGView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                break
            }
        }
    }
   
    func operationSelectView(element: Element) {
        canvasControl.refreshElement(element)
        canvasControl.draw()
    }
    
    func deleteBtnDidClick(element: Element) {
        canvasControl.deleteElement(element)
        canvasControl.draw()
        selectBGView?.removeFromSuperview()
        selectBGView = nil
        messageViewModel.currentElement = nil
    }
    
    func cancelSelected() {
        selectBGView?.removeFromSuperview()
        selectBGView = nil
        messageViewModel.currentElement = nil
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
