//
//  Element.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import Foundation
import UIKit

protocol Element {
    
    var identifier: String { get set }
    
    var transform: CATransform3D { get set }
    var convertTransform: CATransform3D { get set }
    
    var VAO: UInt32? { get set }
    var program: UInt32? { get set }
    var shaderName: String { get set }
    
    var vertices: [Float] { get set }
    var indices: [Int32] { get set }
    
    func convertModel() -> ConvertElement
}

extension Element {
    
    var screenScale: CGFloat {
        UIScreen.main.scale
    }
    
    mutating func scale(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        //        let trans = CATransform3DMakeScale(sx, sy, sz)
        //        convertTransform = CATransform3DConcat(convertTransform, trans)
        //        transform = CATransform3DConcat(transform, trans)
        convertTransform = CATransform3DScale(convertTransform, sx, sy, sz)
        transform = CATransform3DScale(transform, sx, sy, sz)
    }
    
    mutating func translate(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        convertTransform = CATransform3DConcat(convertTransform, CATransform3DMakeTranslation(tx * screenScale, ty * screenScale, tz * screenScale))
        transform = CATransform3DConcat(transform, CATransform3DMakeTranslation(tx, ty, tz))
        //        convertTransform = CATransform3DTranslate(convertTransform, tx * screenScale, ty * screenScale, tz * screenScale)
        //                transform = CATransform3DTranslate(transform, tx, ty, tz)
    }
    
    mutating func rotate(angle: CGFloat, _ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        //        convertTransform = CATransform3DConcat(convertTransform, CATransform3DMakeRotation(angle, x, y, -z))
        //        transform = CATransform3DConcat(transform, CATransform3DMakeRotation(angle, x, y, z))
        convertTransform = CATransform3DRotate(convertTransform, angle, x, y, -z)
        transform = CATransform3DRotate(transform, angle, x, y, z)
    }
}
