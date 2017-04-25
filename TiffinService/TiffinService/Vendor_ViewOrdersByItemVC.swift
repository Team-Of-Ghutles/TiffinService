//
//  Vendor_ViewOrdersByItemVC.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit

class Vendor_ViewOrdersByItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
    @IBOutlet weak var OrdersByItemTable: UITableView!
    
    var networker = OrderItemNetworker()
    var dataSource = [OrderItemVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OrdersByItemTable.delegate = self
        self.OrdersByItemTable.dataSource = self
        self.networker.delegate = self
        self.networker.getItemsAdded()
        self.networker.getItemsChanged()
    }
    
    func itemsDidAdd() {
        let vmAdded = self.networker.viewModelsFetched[0]
        self.networker.viewModelsFetched.remove(at: 0)
        self.dataSource.append(vmAdded)
        self.OrdersByItemTable.reloadData()
    }
    
    func itemsDidChange() {
        let changedVM = self.networker.viewModelChanged
        let arrOfIds: [String] = self.dataSource.map {$0.itemID}
        let index = arrOfIds.index(of: (changedVM?.itemID)!)
        if (index != nil) {
            self.dataSource[index!] = changedVM!
        } else {
            self.dataSource.append(changedVM!)
        }
        self.OrdersByItemTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.OrdersByItemTable.dequeueReusableCell(withIdentifier: "OrdersByItemCell") as?  Vendor_OrderPerItemCell{
            cell.configrueCell(viewModel: self.dataSource[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
