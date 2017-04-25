//
//  Vendor_OrderPerItemCell.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import UIKit

class Vendor_OrderPerItemCell: UITableViewCell {
    
    @IBOutlet weak var ItemCountLbl: UILabel!
    @IBOutlet weak var ItemNameLbl: UILabel!
    
    func configrueCell(viewModel: OrderItemVM) {
        self.ItemCountLbl.text = viewModel.quantity
        self.ItemNameLbl.text = viewModel.name
    }
    
}
