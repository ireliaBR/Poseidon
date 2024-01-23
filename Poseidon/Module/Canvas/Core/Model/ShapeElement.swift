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
    
    var vertices: [Float]
    var indices: [Int]
    
}
