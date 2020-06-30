//
//  ViewController.swift
//  ios-hwloc
//
//  Created by vhoyet on 10/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol modeProtocol {
    func modeChangeFunction(mode: String)
    func showTopologyList(topologies: Topologies)
    func createPickerMenu()
}

class ViewController: UIViewController, modeProtocol, UIScrollViewDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var button = DropDownButton()
    public var scrollView = UIScrollView()
    public var viewContainer = UIView()
    let screenSize = UIScreen.main.bounds
    var importMenu : ImportMenu!
    
    var txtFile = ""
    var xmlFile = ""
    var url = ""
    
    var mode = "Graphics"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topController = self
        txtFile = self.getDocumentsDirectory().appendingPathComponent("topology.txt").path
        xmlFile = self.getDocumentsDirectory().appendingPathComponent("topology.xml").path
        url = "https://hwloc-xmls.herokuapp.com"
        
        /* Set ScrollView as main container to allow scroll and zoom in the app */
        setScrollView()
        /* Create navigation menu */
        setNavMenu()
        /* Create import menu to use it later */
        setImportMenu()
        
        _lstopo(1, nil);
    }
    
    func setScrollView() {
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        //self.scrollView.maximumZoomScale = 2.0
        self.scrollView.minimumZoomScale = 2.0
        self.scrollView.isScrollEnabled = true
        self.scrollView.delegate = self
        self.viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.viewContainer)
    }
    
    func setNavMenu() {
        button = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle(self.mode, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        button.dropView.dropDownOptions = ["XML", "Graphics", "Text", "Import"]
        button.dropView.delegate = self
        
        let icon = UIImage(systemName: "square.and.arrow.up")!
        let shareButton = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.9)), y: -13, width: Int(Float(screenSize.width * 0.1)), height: Int(Float(screenSize.height * 0.1))))
        shareButton.setImage(icon, for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        shareButton.tintColor = UIColor.white
        self.view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
    }
    
    func setImportMenu() {
        self.importMenu = ImportMenu.init(frame: CGRect(x: Int(Float(screenSize.width * 0.1)), y: Int(Float(screenSize.height * 0.1)), width: Int(Float(screenSize.width * 0.8)), height: Int(Float(screenSize.height * 0.8))))
        self.importMenu.delegate = self
    }

    /* Handle navigation in the app*/
    func modeChangeFunction(mode: String) {
        
        /* button effects on click */
        self.button.setTitle(mode == "API" ? "Import" : mode, for: .normal)
        self.button.dismissDropDown()
        self.scrollView.contentSize = CGSize(width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
        
        /* Delete all view from lstopo */
        for view in self.viewContainer.subviews {
                view.removeFromSuperview()
        }
        
        for line in self.viewContainer.layer.sublayers ?? [] {
            line.removeFromSuperlayer()
        }
        
        switch(mode) {
        case "Default",
             "Graphics":
            _lstopo(1, nil)
            self.scrollView.contentSize = CGSize(width: self.viewContainer.subviews[0].frame.width, height: self.viewContainer.subviews[0].frame.height)
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
        case "Import":
            self.viewContainer.addSubview(self.importMenu)
            importMenu.addSubview(importMenu.buttonSynthetic)
            importMenu.addSubview(importMenu.buttonXML)
            break
        case "API":
            _lstopo(2, xmlFile);
            break
        default:
            print("Something went wrong...")
        }
    }
    
    func showTopologyList(topologies: Topologies) {
        var y = navBarHeight
        var label : UILabel
        
        for topology in topologies.xml {
            label = UILabel(frame: CGRect(x: screenSize.width * 0.1, y: CGFloat(y), width: screenSize.width * 0.8, height: screenSize.height * 0.1))
            label.text = topology.title
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapEventHandler(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
            
            self.viewContainer.addSubview(label)
            y += Int(screenSize.height * 0.1)
        }
        self.scrollView.contentSize = CGSize(width: screenSize.width, height: CGFloat(y))
    }
    
    @objc func tapEventHandler(_ sender: UITapGestureRecognizer) {
        let label : UILabel = sender.view as! UILabel
        let str = self.url + "/xml/" + label.text!
        let url = URL(string: str)!
            
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.downloadUrl(url: url) { data in
                self.writeFile(data: data, file: self.xmlFile)
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.modeChangeFunction(mode: "API")
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.scrollView.contentSize = CGSize(width: self.viewContainer.subviews[0].frame.width, height: self.viewContainer.subviews[0].frame.height)
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

        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.writeFile(data: String(data: data, encoding: .utf8)!, file: file)
        }.resume()
    }
    
    func downloadUrl(url: URL, completion: @escaping (String) -> Void) {
        URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    completion(string)
                }
            } else {
                print("error with url")
            }
        }.resume()
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func createPickerMenu() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeXML)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        writeFile(data: readFile(file: myURL.path), file: xmlFile)
        modeChangeFunction(mode: "API")
    }


    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func share(_ sender: UIButton) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image as AnyObject)

        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.viewContainer
        present(activityViewController, animated: true, completion: nil)
        
        return
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

