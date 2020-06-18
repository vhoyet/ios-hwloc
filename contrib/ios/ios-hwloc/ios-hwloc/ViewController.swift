//
//  ViewController.swift
//  ios-hwloc
//
//  Created by vhoyet on 10/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import UIKit

protocol modeProtocol {
    func modeChangeFunction(mode: String)
}

class ViewController: UIViewController, modeProtocol {
    
    var button = DropDownButton()
    
    var mode = "Default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topController = self
        //_lstopo()
        
        button = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle(self.mode, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        button.dropView.dropDownOptions = ["XML", "Draw", "Text", "Synthetic", "Lstopo examples"]
        button.dropView.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func modeChangeFunction(mode: String) {
        /* button effects on click */
        self.button.setTitle(mode, for: .normal)
        self.button.dismissDropDown()
        
        /* Delete all view from lstopo */
        for view in self.view.subviews {
            /* Don't delete nav bar */
            if !(view is UIButton || view is DropDownView) {
                print(view)
                view.removeFromSuperview()
            }
        }
        
        switch(mode) {
        case "Default",
             "Draw":
            _lstopo()
            break
        case "XML":
            break
        case "Text":
            break
        case "Synthetic":
            break
        case "Lstopo examples":
            break
        default:
            print("Something went wrong...")
        }
        
        view.bringSubviewToFront(button.dropView)
        
    }

}

