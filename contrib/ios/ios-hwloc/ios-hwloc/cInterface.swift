//
//  cInterface.swift
//  ios-hwloc
//
//  Created by vhoyet on 17/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import Foundation
import UIKit

var width_scale: Float = 0
var height_scale: Float = 0
var navBarHeight : Int = 40;
var topController : UIViewController? = nil

@_silgen_name("_iosbox")
public func _iosbox(r: CInt, g: CInt, b: CInt, x: CInt, y: CInt, width: CInt, height: CInt, gp_index: CInt, info: UnsafePointer<CChar>) {
        
    let rect = CGRect(x: Int(Float(x) * width_scale), y: Int(Float(Int(y)) * height_scale) + navBarHeight, width: Int(Float(width) * width_scale), height: Int(Float(height) * height_scale))
    let myView = UIView(frame: rect)
    myView.backgroundColor = UIColor(red: CGFloat(Float(r)/Float(255)), green: CGFloat(Float(g)/Float(255)), blue: CGFloat(Float(b)/Float(255)), alpha: 1.0)
    myView.layer.borderColor = UIColor.black.cgColor
    myView.layer.borderWidth = CGFloat(1)
    
    topController?.view.addSubview(myView)
}

@_silgen_name("_iostext")
public func _iostext(text: UnsafePointer<CChar>, gp_index: CInt, x: CInt, y: CInt, fontsize: CInt) {
    let rect = CGRect(x: Int(Float(x) * width_scale), y: Int(Float(Int(y)) * height_scale) + navBarHeight, width: 0, height: 0)
    let myText = UILabel(frame: rect)
    myText.text = String(cString: text)
    myText.sizeToFit()
    myText.font = myText.font.withSize(11)
    topController?.view.addSubview(myText)
}

 @_silgen_name("_iosline")
public func _iosline(x1: CInt, y1: CInt, x2: CInt, y2: CInt) {
    let rect = CGRect(x: Int(Float(x1) * width_scale), y: Int(Float(Int(y1) + navBarHeight) * height_scale), width: Int(Float(x2) * width_scale), height: Int(Float(Int(y2)) * height_scale) + navBarHeight)
    let line = LineView(frame: rect)
    topController?.view.addSubview(line)
}

@_silgen_name("_prepare")
public func _prepare(width: UnsafeMutableRawPointer?, height: UnsafeMutableRawPointer?) {
    let hwloc_screen_width = Int(bitPattern: width)
    let hwloc_screen_height = Int(bitPattern: height)
    
    let screenSize = UIScreen.main.bounds
    width_scale =  Float(screenSize.width) / Float(hwloc_screen_width)
    height_scale = Float(Int(screenSize.height) - navBarHeight) / Float(hwloc_screen_height)
}
