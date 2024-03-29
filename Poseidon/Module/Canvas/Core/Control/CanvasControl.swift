//
//  Canvas.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import Foundation
import GLKit

class CanvasControl {
    
    static var scale: CGFloat = 3
    static var screenWidth: CGFloat = 0
    static var screenHeight: CGFloat = 0
    
    var elements = [Element]()
    
    let ctx = {
        let ctx = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(ctx)
        return ctx
    }()
    
    private var convertControl = CanvasConvertControl()
    private var filterManager = FilterManager()
    
    func viewPort(width: Int, height: Int) {
        CanvasControl.screenWidth = CGFloat(width)
        CanvasControl.screenHeight = CGFloat(height)
        convertControl.configScreen(Float(width), Float(height))
    }
    
    func draw() {
        let convertElements = elements.map { $0.convertModel() }
        let point = convertElements.withUnsafeBufferPointer { UnsafePointer<ConvertElement>($0.baseAddress) }
        convertControl.draw(point, elements.count)
        ctx?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    func refreshElement(_ element: Element) {
        if let index = elements.firstIndex(where: { $0.identifier == element.identifier }) {
            elements[index] = element
        }
    }
    
    func filter(element: Element, filter: FilterType) {
        guard var ele = element as? ImageElement else { return }
        ele.addFilter(filter: filter)
        if let index = elements.firstIndex(where: { $0.identifier == ele.identifier }) {
            elements[index] = ele
        }
    }
    
    func filterIntensity(element: Element, filterIntensity: Float) {
        guard let ele = element as? ImageElement else { return }
        guard var currentElement = elements.filter({ $0.identifier == ele.identifier }).first else { return }
        currentElement.intensity = filterIntensity
        if let index = elements.firstIndex(where: { $0.identifier == ele.identifier }) {
            elements[index] = currentElement
        }
    }
    
    func deleteElement(_ element: Element) {
        var element = element;
        element.release()
        elements.removeAll { $0.identifier == element.identifier }
    }
    
    func addElement(_ element: Element) {
        var copyElement = element
        copyElement.initialRenderData()
        elements.append(copyElement)
    }
}
