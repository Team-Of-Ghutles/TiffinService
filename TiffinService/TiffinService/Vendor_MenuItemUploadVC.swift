//
//  MenuItemUploadVC.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit

class Vendor_MenuItemUploadVC: UIViewController, UITextFieldDelegate {
    
    var networker = MenuItemNetworker()
    
    @IBOutlet weak var ItemNameField: UITextField!
    @IBOutlet weak var ItemDescriptionField: UITextField!
    @IBOutlet weak var ItemPriceField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ItemPriceField.delegate = self
        self.ItemDescriptionField.delegate = self
        self.ItemNameField.delegate = self
    }
    
    @IBAction func uploadBtnPressed(sender: UIButton) {
        if (self.ItemNameField.text != "") && (self.ItemPriceField.text != "") && (self.ItemDescriptionField.text != "") {
            let newMenuItem = MenuItemVM(
                name: self.ItemNameField.text!, price: Int(self.ItemPriceField.text!)!,
                description: self.ItemDescriptionField.text!
            )
            self.networker.writeToDB(viewModel: newMenuItem) {
                self.performSegue(withIdentifier: "NewItemToInventory", sender: nil)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
