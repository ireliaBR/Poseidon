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
    
    func deleteElement(_ element: Element) {
        elements.removeAll { $0.identifier == element.identifier }
    }
    
    func addElement(_ element: Element) {
        var copyElement = element
        if copyElement.program == nil {
            let vsPath = Bundle.main.path(forResource: element.shaderName, ofType: "vs")!
            let fsPath = Bundle.main.path(forResource: element.shaderName, ofType: "fs")!
            let vsSource = try! String(contentsOfFile: vsPath, encoding: .utf8).utf8CString
            let fsSource = try! String(contentsOfFile: fsPath, encoding: .utf8).utf8CString
            let vsPointer = vsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            let fsPointer = fsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            copyElement.program = convertControl.createProgram(vsPointer, fsPointer)
        }
        
        if copyElement.VAO == nil {
            copyElement.VAO = convertControl.createVAO(&copyElement.vertices, MemoryLayout<Float>.size * copyElement.vertices.count, &copyElement.indices, MemoryLayout<Int32>.size * copyElement.indices.count)
        }
        
        elements.append(copyElement)
    }
}
