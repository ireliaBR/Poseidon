//
//  CGPoint+Additional.swift
//  Poseidon
//
//  Created by fdd on 2024/1/31.
//

import Foundation

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }

    func normalize() -> CGPoint {
        let len = length()
        if len != 0 {
            return CGPoint(x: x / len, y: y / len)
        } else {
            return self
        }
    }
}
