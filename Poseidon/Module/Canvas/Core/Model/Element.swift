//
//  Element.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import Foundation
import UIKit

protocol Element {
    
    var transform: CATransform3D { get set }
    
    var VAO: UInt32? { get set }
    var program: UInt32? { get set }
    var vsSource: String { get }
    var fsSource: String { get set }
    
    var vertices: [Float] { get set }
    var indices: [Int32] { get set }
}
