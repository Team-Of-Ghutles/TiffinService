//
//  Vendor_ViewOrdersByClients.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit

class Vendor_ViewOrdersByClientVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
    @IBOutlet weak var ordersByClientTable: UITableView!
    
    var networker = OrderNetworker()
    var dataSource = [OrderVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersByClientTable.delegate = self
        ordersByClientTable.dataSource = self
        self.networker.getAllByPeople(date: "03-20-2017")
    }
    
    func itemsDidAdd() {
        let vmAdded = self.networker.viewModelsFetched[0]
        self.networker.viewModelsFetched.remove(at: 0)
        self.dataSource.append(vmAdded)
        self.ordersByClientTable.reloadData()
    }
    
    func itemsDidChange() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.ordersByClientTable.dequeueReusableCell(withIdentifier: "OrdersByCustomers") as? Vendor_OrderPerClientCell {
            cell.configureCell(orderVM: dataSource[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
