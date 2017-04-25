//
//  Vendor_OrderByClientCell.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import UIKit

class Vendor_OrderPerClientCell: UITableViewCell {
    
    @IBOutlet weak var UsernameLbl: UILabel!
    @IBOutlet weak var ItemsOrderedLbl: UILabel!
    
    func configureCell(orderVM: OrderVM) {
        self.UsernameLbl.text = orderVM.userName
        self.ItemsOrderedLbl.text = orderVM.containees.map{$0.quantity + " " + $0.name}.joined(separator: ", ")
    }
    
}

