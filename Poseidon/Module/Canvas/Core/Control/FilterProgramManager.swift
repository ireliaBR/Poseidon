//
//  FilterProgramManager.swift
//  Poseidon
//
//  Created by fdd on 2024/2/23.
//

import Foundation

class FilterProgramManager {
    
    public static let shared = FilterProgramManager()
    
    var programMap: [FilterType: UInt32] = [:]
    
    init() {
        createProgram(vs: "Image", fs: "Image", type: .default)
        createProgram(vs: "Filter", fs: "Contrast", type: .contrast)
        createProgram(vs: "Filter", fs: "Saturation", type: .saturation)
        createProgram(vs: "Filter", fs: "Luminance", type: .luminance)
    }
    
    private func createProgram(vs: String, fs: String, type: FilterType) {
        let vsPath = Bundle.main.path(forResource: vs, ofType: "vs")!
        let fsPath = Bundle.main.path(forResource: fs, ofType: "fs")!
        let vsSource = try! String(contentsOfFile: vsPath, encoding: .utf8).utf8CString
        let fsSource = try! String(contentsOfFile: fsPath, encoding: .utf8).utf8CString
        let vsPointer = vsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        let fsPointer = fsSource.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
        let program = CanvasRenderData.createProgram(vsPointer, fsPointer)
        programMap[type] = program
    }
}
        
enum FilterType: CaseIterable {
    case `default`
    case contrast // 对比度
    case saturation // 饱和度
    case luminance // 亮度
//    case sharpen // 锐化
}

extension FilterType {
    
    var name: String {
        switch self {
        case .default:
            "默认"
        case .contrast:
            "对比度"
        case .saturation:
            "饱和度"
        case .luminance:
            "亮度"
//        case .sharpen:
//            "锐化"
        }
    }
}
