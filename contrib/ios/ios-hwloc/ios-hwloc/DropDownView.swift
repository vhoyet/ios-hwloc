//
//  DropDownView.swift
//  ios-hwloc
//
//  Created by vhoyet on 12/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import Foundation
import UIKit

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : modeProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.lightGray
        self.backgroundColor = UIColor.lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    /* Change ViewController mode when a view is clicked on */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.modeChangeFunction(mode: dropDownOptions[indexPath.row])
    }

}
