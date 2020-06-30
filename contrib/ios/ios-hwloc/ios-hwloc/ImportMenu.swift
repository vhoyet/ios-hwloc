//
//  ImportMenu.swift
//  ios-hwloc
//
//  Created by vhoyet on 23/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ImportMenu : UIView {
    
    let screenSize = UIScreen.main.bounds
    
    var delegate : modeProtocol!
    
    var buttonSynthetic = UIButton()
    var buttonSyntheticLstopo = UIButton()
    var buttonXML = UIButton()
    var buttonXMLOnline = UIButton()
    var buttonXMLLocal = UIButton()
    var buttonSearch = UIButton()
    var syntheticInputField = UITextField()
    var searchInputField = UITextField()
    var pickers : [SelectView] = []
    var tags : TopologyTags!
    var searchTags : AnyObject!
    var offline = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let group = DispatchGroup()
        group.enter()
        
        self.getTags() { result in
            switch (result) {
            case .success(let tags):
                self.tags = tags
                self.setUpImportMenu()
                break
            case .failure(let error):
                switch (error) {
                case .badURL:
                    print("Bad Url")
                    break
                case .requestFailed:
                    self.offline = true
                    self.setUpImportMenu()
                    print("request failed")
                    break
                case .unknown:
                    print("Unknown error")
                    break
                }
            }
        }
        
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImportMenu(){
        setUpElementsPosition()
        setUpElementsColor()
        setUpElementsText()
        setUpButtonsEvent()
        if (!offline) {
            setUpPickers()
        }
    }
    
    func setUpElementsColor() {
        buttonSynthetic.backgroundColor = UIColor.lightGray
        buttonXML.backgroundColor = UIColor.lightGray
        buttonSyntheticLstopo.backgroundColor = UIColor.lightGray
        buttonXMLLocal.backgroundColor = UIColor.lightGray
        buttonXMLOnline.backgroundColor = UIColor.lightGray
        buttonSearch.backgroundColor = UIColor.lightGray
        syntheticInputField.backgroundColor = UIColor.white
        searchInputField.backgroundColor = UIColor.white
    }
    
    func setUpElementsPosition() {
        buttonSynthetic = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.1)), y: Int(Float(screenSize.height * 0.2)), width: Int(Float(screenSize.width * 0.25)), height: Int(Float(screenSize.height * 0.1))))
        buttonXML = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.45)), y: Int(Float(screenSize.height * 0.2)), width: Int(Float(screenSize.width * 0.25)), height: Int(Float(screenSize.height * 0.1))))
        syntheticInputField = UITextField(frame: CGRect(x: Int(Float(screenSize.width * 0.2)), y: Int(Float(screenSize.height * 0.4)), width: Int(Float(screenSize.width * 0.4)), height: Int(Float(screenSize.height * 0.05))))
        buttonSyntheticLstopo = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.3)), y: Int(Float(screenSize.height * 0.5)), width: Int(Float(screenSize.width * 0.2)), height: Int(Float(screenSize.height * 0.1))))
        buttonXMLOnline = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.5)), y: Int(Float(screenSize.height * 0.5)), width: Int(Float(screenSize.width * 0.2)), height: Int(Float(screenSize.height * 0.1))))
        buttonXMLLocal = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.1)), y: Int(Float(screenSize.height * 0.5)), width: Int(Float(screenSize.width * 0.2)), height: Int(Float(screenSize.height * 0.1))))
        searchInputField = UITextField(frame: CGRect(x: Int(Float(screenSize.width * 0.05)), y: Int(Float(screenSize.height * 0.05)), width: Int(Float(screenSize.width * 0.4)), height: Int(Float(screenSize.height * 0.05))))
        buttonSearch = UIButton(frame: CGRect(x: Int(Float(screenSize.width * 0.5)), y: Int(Float(screenSize.height * 0.05)), width: Int(Float(screenSize.width * 0.2)), height: Int(Float(screenSize.height * 0.05))))
    }
    
    func setUpElementsText(){
        buttonSynthetic.setTitle("Synthetic", for: .normal)
        buttonXML.setTitle("XML", for: .normal)
        buttonSyntheticLstopo.setTitle("Draw !", for: .normal)
        buttonXMLLocal.setTitle("Local", for: .normal)
        buttonXMLOnline.setTitle("Online", for: .normal)
        buttonSearch.setTitle("Go !", for: .normal)
        syntheticInputField.placeholder = "synthetic string"
        searchInputField.placeholder = "search string"
    }
    
    func setUpButtonsEvent() {
        buttonSynthetic.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
        buttonSyntheticLstopo.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
        buttonXML.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
        buttonXMLLocal.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
        buttonXMLOnline.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
        buttonSearch.addTarget(self, action: #selector(buttonEventHandler(_:)), for: .touchUpInside)
    }
    
    func setUpPickers(){
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.05)), y: Int(Float(screenSize.height * 0.1)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.architecture, title: "Architecture"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.05)), y: Int(Float(screenSize.height * 0.27)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.sub_architecture, title: "Sub-Architecture"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.05)), y: Int(Float(screenSize.height * 0.44)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.cpu_model, title: "CPU Model"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.05)), y: Int(Float(screenSize.height * 0.61)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.cpu_family, title: "CPU Family"))
        
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.45)), y: Int(Float(screenSize.height * 0.44)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.uname_architecture, title: "Uname-Architecture"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.45)), y: Int(Float(screenSize.height * 0.61)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.nbpackages.map{String($0)}, title: "Packages"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.45)), y: Int(Float(screenSize.height * 0.1)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.nbcores.map{String($0)}, title: "Cores"))
        pickers.append(SelectView(x: Int(Float(screenSize.width * 0.45)), y: Int(Float(screenSize.height * 0.27)), width: Int(Float(screenSize.width * 0.3)), height: Int(Float(screenSize.height * 0.2)), data: ["No filter"] + tags.NUMA.map{String($0)}, title: "NUMA"))
    }
    
    @objc func buttonEventHandler(_ sender: UIButton) {
        switch (sender) {
        case buttonXML:
            buttonSyntheticLstopo.removeFromSuperview()
            syntheticInputField.removeFromSuperview()
            
            if (!offline) {
               self.addSubview(buttonXMLOnline)
            }
            self.addSubview(buttonXMLLocal)
            break
        case buttonSynthetic:
            buttonXMLLocal.removeFromSuperview()
            buttonXMLOnline.removeFromSuperview()
            
            self.addSubview(syntheticInputField)
            self.addSubview(buttonSyntheticLstopo)
            break
        case buttonSyntheticLstopo:
            if (syntheticInputField.text != "") {
                _lstopo(5, syntheticInputField.text)
            }
            break
        case buttonXMLOnline:
            buttonXML.removeFromSuperview()
            buttonXMLLocal.removeFromSuperview()
            buttonXMLOnline.removeFromSuperview()
            buttonSynthetic.removeFromSuperview()
            
            self.addSubview(searchInputField)
            self.addSubview(buttonSearch)
            for picker in pickers {
                self.addSubview(picker.title)
                self.addSubview(picker)
            }
            
            break
        case buttonXMLLocal:
            self.buttonXMLLocal.removeFromSuperview()
            self.buttonXMLOnline.removeFromSuperview()
            
            self.delegate.createPickerMenu()
            break
        case buttonSearch:
            let jsonObject: [String: Any?] = [
                "architecture": pickers[0].getValue() != "No filter" ? pickers[0].getValue()! : nil,
                "sub-Architecture": pickers[1].getValue() != "No filter" ?  pickers[1].getValue()! : nil,
                "uname-Architectre": pickers[4].getValue() != "No filter" ?  pickers[4].getValue()! : nil,
                "cpu-vendor": pickers[2].getValue() != "No filter" ?  pickers[2].getValue()! : nil,
                "cpu-family": pickers[3].getValue() != "No filter" ?  pickers[3].getValue()! : nil,
                "core": pickers[6].getValue() != "No filter" ?  pickers[6].getValue()! : nil,
                "package": pickers[5].getValue() != "No filter" ?  pickers[5].getValue()! : nil,
                "NUMA": pickers[7].getValue() != "No filter" ?  pickers[7].getValue()! : nil
            ]
            
            let str = "https://hwloc-xmls.herokuapp.com/tags/" + JSONStringify(value: jsonObject as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            self.getTopologies(from: str) { result in
                switch (result) {
                case .success(let topologies):
                    self.delegate.showTopologyList(topologies: topologies)
                    break
                case .failure(let error):
                    switch (error) {
                    case .badURL:
                        print("Bad Url")
                        break
                    case .requestFailed:
                        print("request failed")
                        break
                    case .unknown:
                        print("Unknown error")
                        break
                    }
                }
            }
            
            for picker in pickers {
                picker.title.removeFromSuperview()
                picker.removeFromSuperview()
            }
            buttonSearch.removeFromSuperview()
            searchInputField.removeFromSuperview()
            self.removeFromSuperview()
            break
        default:
            print("Something went wrong...")
        
        }
    }
    
    func getTags(completion: @escaping (Result<TopologyTags, NetworkError>) -> Void) {
        let str = "https://hwloc-xmls.herokuapp.com/tags"
        let url = URL(string: str)!
        
        URLSession.shared.dataTask(with: url) { tags, response, error in
            DispatchQueue.main.async {
                if let tags = tags {
                    do {
                        let returnTags = try JSONDecoder().decode(TopologyTags.self, from: tags)
                        completion(.success(returnTags))
                    } catch {
                        print(error)
                        completion(.failure(.requestFailed))
                    }
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
    
    func getTopologies(from urlString: String, completion: @escaping (Result<Topologies, NetworkError>) -> Void) {
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    do {
                        let topologiesTitle = try JSONDecoder().decode(Topologies.self, from: data)
                        completion(.success(topologiesTitle))
                    } catch {
                        print(error)
                    }
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                print(error)
            }

        }
        return ""
    }
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
