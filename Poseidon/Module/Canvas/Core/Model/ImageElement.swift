//
//  ImageElement.swift
//  Poseidon
//
//  Created by fdd on 2024/2/2.
//

import Foundation
import UIKit
import OpenGLES

struct ImageElement: Element {
    
    
    var identifier: String = UUID().uuidString
    
    var transform: CATransform3D = CATransform3DIdentity
    var convertTransform: CATransform3D = CATransform3DIdentity
    var size: CGSize
    
    var image: UIImage
    
    var vertices: [Float]
    var indices: [Int32]
    var texCoords: [Float]
    
    var renderBuffer = ElementRenderBuffer()
    var shaderName: String = "Image"
    
    static func image(_ image: UIImage) -> ImageElement {
        let vertices: [Float] = [
            0.5,  0.5, 0.0,  // top right
            0.5, -0.5, 0.0,  // bottom right
            -0.5, -0.5, 0.0,  // bottom left
            -0.5,  0.5, 0.0,  // top left
        ]
        let indices: [Int32] = [
            0, 1, 3,  // first Triangle
            1, 2, 3,   // second Triangle
        ]
        let texCoords: [Float] = [
            // texture coords
            1.0, 1.0, // top right
            1.0, 0.0, // bottom right
            0.0, 0.0, // bottom left
            0.0, 1.0  // top left
        ]
        let element = ImageElement(size: CGSize(width: 150, height: 150), image: image, vertices: vertices, indices: indices, texCoords: texCoords)
        return element
    }
    
    func inside(point: CGPoint) -> Bool {
        let sizeTrans = CGAffineTransform(scaleX: size.width, y: size.height)
        let affineModel = CGAffineTransform(a: CGFloat(transform.m11),
                                            b: CGFloat(transform.m12),
                                            c: CGFloat(transform.m21),
                                            d: CGFloat(transform.m22),
                                            tx: CGFloat(transform.m41),
                                            ty: CGFloat(transform.m42))
        let mvp = sizeTrans.concatenating(affineModel)
        
        var points = [CGPoint]()
        for i in stride(from: 0, to: vertices.count, by: 3) {
            let point = CGPoint(x: CGFloat(vertices[i]), y: CGFloat(-vertices[i + 1]))
            points.append(point.applying(mvp))
        }
        
        // 根据四边形的四个点创建一个路径
        let path = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        // 判断点是否在路径内
        let p = CGPoint(x: point.x, y: point.y)
        return path.contains(p)
    }
    
    mutating func initialRenderData() {
        if renderBuffer.program == 0 {
            let vsPath = Bundle.main.path(forResource: shaderName, ofType: "vs")!
            let fsPath = Bundle.main.path(forResource: shaderName, ofType: "fs")!
            let vsSource = try! String(contentsOfFile: vsPath, encoding: .utf8).utf8CString
            let fsSource = try! String(contentsOfFile: fsPath, encoding: .utf8).utf8CString
            let vsPointer = vsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            let fsPointer = fsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            CanvasRenderData.createProgram(&renderBuffer, vsPointer, fsPointer)
        }
        
        if renderBuffer.VAO == 0 {
            CanvasRenderData.createImageVAO(&renderBuffer, &vertices, MemoryLayout<Float>.size * vertices.count, &indices, MemoryLayout<Int32>.size * indices.count, &texCoords, MemoryLayout<Float>.size * texCoords.count)
        }
        
        if renderBuffer.texture == 0 {
            guard let cgImage = image.cgImage else {
                return
            }
            let width = GLsizei(cgImage.width)
            let height = GLsizei(cgImage.height)
            size = CGSize(width: 150, height: Int(height * 150 / width))
            
            guard let imageData = calloc(Int(width * height) * 4, MemoryLayout<GLubyte>.size) else {
                print("Failed to allocate memory for image data.")
                return
            }
            
            let context = CGContext(data: imageData,
                                    width: Int(width),
                                    height: Int(height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: Int(width) * 4,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
            context?.translateBy(x: 0, y: CGFloat(height))
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
            CanvasRenderData.createTexture(&renderBuffer, imageData, Int32(width), Int32(height))
            free(imageData)
        }
    }
    
    func convertModel() -> ConvertElement {
        var element = ConvertElement()
        let convertId = identifier.utf8CString
        let idPointer = convertId.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        element.identifier = idPointer
        element.type = Image
        
        element.renderBuffer = renderBuffer
        element.renderCount = UInt32(indices.count)
        
        let sizeTrans = CATransform3DMakeScale(size.width * CanvasControl.scale, size.height * CanvasControl.scale, 1)
        
        let transform = CATransform3DConcat(sizeTrans, convertTransform)
        
        element.transform = glm.mat4()
        element.transform[0][0] = Float(transform.m11)
        element.transform[0][1] = Float(transform.m12)
        element.transform[0][2] = Float(transform.m13)
        element.transform[0][3] = Float(transform.m14)
        
        element.transform[1][0] = Float(transform.m21)
        element.transform[1][1] = Float(transform.m22)
        element.transform[1][2] = Float(transform.m23)
        element.transform[1][3] = Float(transform.m24)
        
        element.transform[2][0] = Float(transform.m31)
        element.transform[2][1] = Float(transform.m32)
        element.transform[2][2] = Float(transform.m33)
        element.transform[2][3] = Float(transform.m34)
        
        element.transform[3][0] = Float(transform.m41)
        element.transform[3][1] = Float(transform.m42)
        element.transform[3][2] = Float(transform.m43)
        element.transform[3][3] = Float(transform.m44)
        return element
    }
}
