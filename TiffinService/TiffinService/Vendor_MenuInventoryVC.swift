//
//  MenuInventoryVC.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit

class Vendor_MenuInventoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
    var networker = MenuItemNetworker() //primary networker
    var pubMenuNetworker = PublishedMenuNetworker() //secondary networker
    var orderItemNetworker = OrderItemNetworker()
    
    @IBOutlet weak var inventoryTable: UITableView!
    
    var dataSource = [MenuItemVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inventoryTable.delegate = self
        inventoryTable.dataSource = self
        self.networker.delegate = self
        self.networker.getAll()
        
    }
    
    func itemsDidAdd() {
        self.dataSource = self.networker.viewModelsFetched
        self.inventoryTable.reloadData()
    }
    func itemsDidChange() {}
    
    @IBAction func uploadItemBtnClicked(sender: UIButton) {
        performSegue(withIdentifier: "InventoryToUpload", sender: nil)
    }
    
    @IBAction func publishMenuBtnClicked(sender: UIButton) {
        let publishableItems = Array(self.dataSource[2...6]) //Replace with vendor selected menu
        let publishedMenuVM = PublishedMenuVM(pubDate: getCurrentDate(), menuItemVMs: publishableItems)
        pubMenuNetworker.writeToDB(viewModel: publishedMenuVM) {
            self.orderItemNetworker.writeToDB(viewModels: publishableItems.map {OrderItemVM(menuItemVM: $0, quantity: 0)}, initialize: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = inventoryTable.dequeueReusableCell(withIdentifier: "MenuItemCell") as? Vendor_MenuItemCell{
            cell.configureCell(menuItemVM: dataSource[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
