//
//  Vendor_MenuItemCell.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import UIKit

class Vendor_MenuItemCell:  UITableViewCell{
    
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var ItemPrice: UILabel!
    
    func configureCell(menuItemVM: MenuItemVM) {
        self.ItemName.text = menuItemVM.name
        self.ItemDescription.text = menuItemVM.description
        self.ItemPrice.text = menuItemVM.price
    }
}
