//
//  SelectVIew.swift
//  ios-hwloc
//
//  Created by vhoyet on 24/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import Foundation
import UIKit
 
class SelectView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerData : [String]!
    var title : UILabel!
    let screenSize = UIScreen.main.bounds
    
    init(x: Int, y: Int, width: Int, height: Int, data: [String], title: String) {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        
        self.title = UILabel(frame: CGRect(x: x, y: Int(CGFloat(y) - 0.03 * screenSize.height) , width: width, height: height))
        self.title.text = title
        self.title.textAlignment = .center
        self.title.textColor = UIColor.lightGray
        
        self.pickerData = data
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets number of columns in picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
 
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
 
    // This function sets the text of the picker view to the content of the pickerData array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        
        label.font = UIFont (name: "Helvetica Neue", size: 15)
        label.text =  pickerData[row]
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    
    func getValue() -> String? {
        return self.pickerView(self, titleForRow: self.selectedRow(inComponent: 0), forComponent: 0)
    }
 
}
