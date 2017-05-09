//
//  Client_ViewMenuVC.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/21/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit

class Client_ViewMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var orderTotalLbl: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var publishedMenuNetworker = PublishedMenuNetworker()
    var orderItemNetworker = OrderItemNetworker()
    var orderNetworker = OrderNetworker()
    var transactionNetworker = TransactionNetworker()
    var balanceNetworker = BalanceNetworker()
    
    var dataSource = [OrderItemVM]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "Date")
        UserDefaults.standard.removeObject(forKey: OrderCaher.userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: TransactionCacher.userDefaultsKey)
        menuTable.delegate = self
        menuTable.dataSource = self
        self.orderTotalLbl.text = "$0"
        self.publishedMenuNetworker.delegate = self
        self.publishedMenuNetworker.getMenu()
        let usermodel: [String:String] = UserDefaults.standard.dictionary(forKey: "User") as! [String : String]
        username.text = usermodel["firstname"]
    }
    
    @IBAction func SubmitOrder(sender: UIButton) {
        let userId = USER
        let orderVM = OrderVM(userId: userId, userName: "PullaRao, M", orderTime: getCurrentTime(), orderDate: getCurrentDate(), orderItemVMs: self.dataSource)
        orderNetworker.writeToDB(viewModel: orderVM) {
            let transactionVM = TransactionVM(amount: self.orderTotalLbl.text!, type: "ORDER", userId: userId)
            self.transactionNetworker.writeToDB(viewModel: transactionVM) {
                BalanceNetworker.getBalancePerUser(userId: userId, userFN: "PullaRao", userLN: "Meka") { balanceVM in
                    balanceVM.updateBalance(newDeltaQty: self.orderTotalLbl.text!)
                    balanceVM.writeToDB()
                }
            }
        }
        orderItemNetworker.writeToDB(viewModels: orderVM.containees)
    }
    
    @IBAction func LogoutHandler(_ sender: UIButton) {
        sender.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = menuTable.dequeueReusableCell(withIdentifier: "MenuItemForClient") as? Client_OrderItemCell{
            let currentViewModel = self.dataSource[indexPath.row]
            cell.viewModelDelegate = currentViewModel
            cell.viewControllerDelegate = self
            cell.configureCell(orderItemVM: currentViewModel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func itemsDidAdd() {
        let menuItemVMs = self.publishedMenuNetworker.viewModelsFetched[0].containees
        for item in menuItemVMs! {
            self.dataSource.append(OrderItemVM(menuItemVM: item, quantity: 0))
        }
        self.menuTable.reloadData()
    }
    
    func itemsDidChange() {}
}
