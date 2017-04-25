//
//  Client_OrderItemCell.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import UIKit

class Client_OrderItemCell : UITableViewCell {
    
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var QtyOrdered: UILabel!
    @IBOutlet weak var UnitPrice: UILabel!
    @IBOutlet weak var ItemTotal: UILabel!
    @IBOutlet weak var QtyStepper: UIStepper!
    
    var viewModelDelegate: OrderItemVM!
    var viewControllerDelegate: Client_ViewMenuVC!
    
    var preStepperQty: Int!
    
    @IBAction func QtyStepperPressed(sender: UIStepper) {
        let newQty = Int(sender.value).description
        self.QtyOrdered.text = newQty
        self.viewModelDelegate.quantity = newQty
        self.ItemTotal.text = self.viewModelDelegate.itemTotal
        self.updateVCItemTotal(oldQty: self.preStepperQty, newQty: Int(newQty)!)
    }
    
    
    func configureCell(orderItemVM: OrderItemVM){
        self.ItemName.text = orderItemVM.name
        self.ItemDescription.text = orderItemVM.description
        self.UnitPrice.text = orderItemVM.price
        self.QtyOrdered.text = orderItemVM.quantity
        self.QtyStepper.value = Double(orderItemVM.quantity)!
        self.preStepperQty = Int(orderItemVM.quantity)
        self.ItemTotal.text = orderItemVM.itemTotal
    }
    
    
    func updateVCItemTotal(oldQty: Int, newQty: Int) { ///Doesn't fit right. There should be a better/scalable way to update OrderConfirmVC.itemTotal
        var vcTotal = viewControllerDelegate.orderTotalLbl.text
        self.preStepperQty = newQty
        if !(newQty == 0 && oldQty == 0) {
            if newQty > oldQty {
                self.viewControllerDelegate.orderTotalLbl.text = "$" + "\(viewModelDelegate.model.price + Int(String(vcTotal!.characters.dropFirst()))!)"
            } else {
                self.viewControllerDelegate.orderTotalLbl.text = "$" + "\(Int(String(vcTotal!.characters.dropFirst()))! - viewModelDelegate.model.price)"
            }
        }
    }
    
}
