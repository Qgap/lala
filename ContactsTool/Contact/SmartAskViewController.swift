//
//  SmartAskViewController.swift
//  Weather
//
//  Created by gap on 2017/12/11.
//  Copyright © 2017年 gq. All rights reserved.
//

import UIKit



class SmartAskViewController: UIViewController,UITextFieldDelegate {

    let textField = UITextField()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Smart Ask"
        
        self.textField.frame = CGRect.init(x: 50, y: 100, width: 300, height: 40)
        self.textField.returnKeyType = UIReturnKeyType.send
        self.textField.delegate = self
        self.textField.layer.backgroundColor = UIColor.gray.cgColor
        self.textField.layer.borderWidth = 1.0
        self.view.addSubview(self.textField)
        
        self.label.frame = CGRect.init(x: 50, y: 150, width: 300, height: 40)
        self.label.numberOfLines = 0
        self.label.layer.backgroundColor = UIColor.red.cgColor
        self.label.layer.borderWidth = 1.0
        self.view.addSubview(self.label)

    }
    
    func loadRequst() {
        print("self.text:\(self.textField.text) ")

        let url = URL.init(string: Smart.SmartAPI)!
        let parameters :[String: String] = ["question":self.textField.text!]
        let appCode: String = "APPCODE " + Smart.AppCode
        let headers = ["Authorization":appCode]

      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.textField.resignFirstResponder()
            self.loadRequst()
            return false
        }
        return true
    }

}
