//
//  LineView.swift
//  ios-hwloc
//
//  Created by vhoyet on 11/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import SwiftUI

class LineView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor.black.cgColor)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        context!.strokePath()
    }
}

