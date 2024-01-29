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
    var size: CGSize
    
    var color: UIColor
    
    var vertices: [Float] = [
        0.5,  0.5, 0.0,  // top right
        0.5, -0.5, 0.0,  // bottom right
        -0.5, -0.5, 0.0,  // bottom left
        -0.5,  0.5, 0.0,  // top left
    ]
    var indices: [Int32] = [
        0, 1, 3,  // first Triangle
        1, 2, 3,   // second Triangle
    ]
    
    var VAO: UInt32?
    var program: UInt32?
    
    var vsSource: String = {
        let vsPath = Bundle.main.path(forResource: "Shape", ofType: "vs")!
        let vsSource = try! String(contentsOfFile: vsPath, encoding: .utf8)
//        let vsPointer = vsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        return vsSource
    }()
    
    var fsSource: String = {
        let fsPath = Bundle.main.path(forResource: "Shape", ofType: "fs")!
        let fsSource = try! String(contentsOfFile: fsPath, encoding: .utf8)
//        let fsPointer = fsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        return fsSource
    }()
    
}
