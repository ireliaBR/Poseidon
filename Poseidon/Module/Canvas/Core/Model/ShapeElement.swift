//
//  ShapeElement.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import Foundation
import UIKit

struct ShapeElement: Element {
    
    var identifier: String = UUID().uuidString
    
    var transform: CATransform3D = CATransform3DIdentity
    var convertTransform: CATransform3D = CATransform3DIdentity
    var size: CGSize
    
    var color: UIColor
    
    var vertices: [Float]
    var indices: [Int32]
    
    var VAO: UInt32?
    var program: UInt32?
    
    var shaderName: String = "Shape"
    
    static let square = {
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
        let element = ShapeElement(size: CGSize(width: 150, height: 150), color: .red, vertices: vertices, indices: indices)
        return element
    }()
    
    static var triangle = {
        let vertices: [Float] = [
            -0.5, -0.5, 0.0, // left
             0.5, -0.5, 0.0, // right
             0.0,  0.5, 0.0  // top
        ]
        let indices: [Int32] = [
            0, 1, 2
        ]
        let element = ShapeElement(size: CGSize(width: 150, height: 150), color: .red, vertices: vertices, indices: indices)
        return element
    }()
    
    func convertModel() -> ConvertElement {
        var element = ConvertElement()
        let idPointer = identifier.utf8CString.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        element.identifier = idPointer
        element.VAO = VAO ?? 0
        element.program = program ?? 0
        element.renderCount = UInt32(indices.count)
        element.color = glm.vec4()
        // 定义变量来存储 RGBA 值
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        // 获取颜色的 RGBA 值
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        element.color[0] = Float(red)
        element.color[1] = Float(green)
        element.color[2] = Float(blue)
        element.color[3] = Float(alpha)
        
        let sizeTrans = CATransform3DMakeScale(size.width * screenScale, size.height * screenScale, 1)
        
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
