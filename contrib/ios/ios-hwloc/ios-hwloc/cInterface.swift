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
var fontSize : CGFloat = 0
var navBarHeight : Int = 40
var topController : ViewController? = nil

@_silgen_name("_iosbox")
public func _iosbox(r: CInt, g: CInt, b: CInt, x: CInt, y: CInt, width: CInt, height: CInt, gp_index: CInt, info: UnsafePointer<CChar>) {
        
    let rect = CGRect(x: Int(Float(x) * width_scale), y: Int(Float(Int(y)) * height_scale) + navBarHeight, width: Int(Float(width) * width_scale), height: Int(Float(height) * height_scale))
    let myView = UIView(frame: rect)
    myView.backgroundColor = UIColor(red: CGFloat(Float(r)/Float(255)), green: CGFloat(Float(g)/Float(255)), blue: CGFloat(Float(b)/Float(255)), alpha: 1.0)
    myView.layer.borderColor = UIColor.black.cgColor
    myView.layer.borderWidth = CGFloat(1)
    
    topController?.viewContainer.addSubview(myView)
}

@_silgen_name("_iostext")
public func _iostext(text: UnsafePointer<CChar>, gp_index: CInt, x: CInt, y: CInt, fontsize: CInt) {
    let rect = CGRect(x: Int(Float(x) * width_scale), y: Int(Float(Int(y)) * height_scale) + navBarHeight, width: 0, height: 0)
    let myText = UILabel(frame: rect)
    myText.text = String(cString: text)
    myText.font = myText.font.withSize(fontSize)
    myText.numberOfLines = 0
    myText.sizeToFit()
    topController?.viewContainer.addSubview(myText)
}

 @_silgen_name("_iosline")
public func _iosline(x1: CInt, y1: CInt, x2: CInt, y2: CInt) {
    let line = CAShapeLayer()
    let linePath = UIBezierPath()
    linePath.move(to: CGPoint(x: Int(Float(x1) * width_scale), y: Int(Float(Int(y1)) * height_scale)  + navBarHeight))
    linePath.addLine(to: CGPoint(x: Int(Float(x2) * width_scale), y: Int(Float(Int(y2)) * height_scale) + navBarHeight))
    line.path = linePath.cgPath
    line.strokeColor = UIColor.black.cgColor
    line.lineWidth = 1
    line.lineJoin = CAShapeLayerLineJoin.round
    topController?.viewContainer.layer.addSublayer(line)
}

@_silgen_name("_prepare")
public func _prepare(width: UnsafeMutableRawPointer?, height: UnsafeMutableRawPointer?) {
    let hwloc_screen_width = Int(bitPattern: width)
    let hwloc_screen_height = Int(bitPattern: height)
    
    let screenSize = UIScreen.main.bounds
    /* width_scale =  Float(screenSize.width) / Float(hwloc_screen_width)
    height_scale = Float(Int(screenSize.height) - navBarHeight) / Float(hwloc_screen_height) */
    width_scale =  2
    height_scale = 2
    
    if(width_scale > 0.5) {
        fontSize = 11
    } else if(width_scale < 0.5) {
        fontSize = 5
    }
}
