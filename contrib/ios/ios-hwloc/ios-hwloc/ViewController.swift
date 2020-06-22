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

class ViewController: UIViewController, modeProtocol, UIScrollViewDelegate {
    
    var button = DropDownButton()
    public var scrollView = UIScrollView()
    public var viewContainer = UIView()
    let screenSize = UIScreen.main.bounds
    
    var txtFile = ""
    var xmlFile = ""
    var url = ""
    
    var mode = "Default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topController = self
        txtFile = self.getDocumentsDirectory().appendingPathComponent("topology.txt").path
        xmlFile = self.getDocumentsDirectory().appendingPathComponent("topology.xml").path
        url = "https://hwloc-xmls.herokuapp.com"
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.isScrollEnabled = true
        self.scrollView.delegate = self
        self.viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.viewContainer)
    
        
        _lstopo(1, nil);
        
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
        self.scrollView.contentSize = CGSize(width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
        
        /* Delete all view from lstopo */
        for view in self.viewContainer.subviews {
                view.removeFromSuperview()
        }
        
        switch(mode) {
        case "Default",
             "Draw":
            _lstopo(1, nil)
            break
        case "XML":
            deleteFile(file: xmlFile)
            _lstopo(4, xmlFile);
            let topologyString = readFile(file: xmlFile)
            _prepare(width: UnsafeMutablePointer(bitPattern: Int(screenSize.width)), height: UnsafeMutablePointer(bitPattern: Int(screenSize.height)))
            _iostext(text: topologyString, gp_index: 0, x: 0, y: 0, fontsize: 0)
            self.scrollView.contentSize = CGSize(width: self.viewContainer.subviews[0].frame.width, height: self.viewContainer.subviews[0].frame.height)
            break
        case "Text":
            deleteFile(file: txtFile)
            _lstopo(3, txtFile);
            let topologyString = readFile(file: txtFile)
            _prepare(width: UnsafeMutablePointer(bitPattern: Int(screenSize.width)), height: UnsafeMutablePointer(bitPattern: Int(screenSize.height)))
            _iostext(text: topologyString, gp_index: 0, x: 0, y: 0, fontsize: 0)
            self.scrollView.contentSize = CGSize(width: self.viewContainer.subviews[0].frame.width, height: self.viewContainer.subviews[0].frame.height)
            break
        case "Synthetic":
            
            break
        case "Lstopo examples":
            loadFileFromUrl(url: url + "/xml/AMD-Opteron-MagnyCours-2pa2no6co.xml", file: xmlFile)
            _lstopo(2, xmlFile);
            break
        default:
            print("Something went wrong...")
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.viewContainer
    }
    
    func deleteFile(file: String) {
        let url = URL(fileURLWithPath: file)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readFile(file: String) -> String {
        var str = ""
        let url = URL(fileURLWithPath: file)
        
        do {
            str = try String(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
        
        return str
    }
    
    func writeFile(data: String, file: String) {
        let url = URL(fileURLWithPath: file)

        do {
            try data.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFileFromUrl(url : String, file: String) {
        let url = URL(string: url)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.writeFile(data: String(data: data, encoding: .utf8)!, file: file)
        }

        task.resume()
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

}

