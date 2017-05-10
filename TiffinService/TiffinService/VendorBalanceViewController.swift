//
//  VendorBalanceViewController.swift
//  firebase-ios-auth
//
//  Created by Nitin Jami on 4/19/17.
//  Copyright © 2017 Nitin Jami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper

enum VendorBalanceSection: Int {
    case OverallBalance, CustomerBalance, Count
    
    static var count = {
        return VendorBalanceSection.Count.rawValue
    }
    
    static let sectionTitles = [
        OverallBalance: "Overall Balance",
        CustomerBalance: "Customers Balance"
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = VendorBalanceSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
}

struct CustomerBalance: Mappable {
    var id: String!
    var credit: Int!
    var debit: Int!
    var firstName: String!
    var lastName: String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        credit <- map["credit"]
        debit <- map["debit"]
        firstName <- map["firstname"]
        lastName <- map["lastname"]
    }
}

struct VendorBalance: Mappable {
    var credit: Int!
    var debit: Int!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        credit <- map["credit"]
        debit <- map["debit"]
    }
}

protocol WorkerDelegate {
    func displayFetchedList(of customerBalances: [VendorBalanceViewModel])
    func displayFetched(with vendorBalance: VendorBalanceOverviewViewModel)
}

class Worker {
    var customerBalanceViewModels: [VendorBalanceViewModel] = []
    var delegate: WorkerDelegate?
    
    func fetchCustomerBalances() {
        let ref = FIRDatabase.database().reference().child("Balances")
        NetworkService.fetchItems(from: ref) { (items) in
            for (key, value) in items {
                var balance = CustomerBalance(JSON: value)!
                balance.id = key
                self.customerBalanceViewModels.append(VendorBalanceViewModel(balanceModel: balance))
            }
            self.delegate?.displayFetchedList(of: self.customerBalanceViewModels)
        }
    }
    
    func fetchVendorBalance() {
        // TODO
        let ref = FIRDatabase.database().reference().child("VendorBalances").child((FIRAuth.auth()?.currentUser?.uid)!)
        NetworkService.fetchItem(from: ref) { (item) in
            let overview = VendorBalanceOverviewViewModel(vendorBalanceModel: VendorBalance(JSON: item)!)
            self.delegate?.displayFetched(with: overview)
        }
    }
}

struct VendorBalanceOverviewViewModel {
    private let vendorBalanceModel: VendorBalance
    
    init(vendorBalanceModel: VendorBalance) {
        self.vendorBalanceModel = vendorBalanceModel
    }
    
    private let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
    var creditText: String {
        return currencyFormatter.string(from: NSNumber(integerLiteral: vendorBalanceModel.credit))!
    }
    
    var debitText: String {
        return currencyFormatter.string(from: NSNumber(integerLiteral: vendorBalanceModel.debit))!
    }
}

struct VendorBalanceViewModel {
    private let balanceModel: CustomerBalance
    
    init(balanceModel: CustomerBalance) {
        self.balanceModel = balanceModel
    }
    
    private let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
    var balanceText: String {
        let bal: Int = balanceModel.credit - balanceModel.debit
        let owe: String = bal < 0 ? "Owes You " : "You Owe "
        return owe + currencyFormatter.string(from: NSNumber(integerLiteral: abs(bal)))!
    }
    
    var customerName: String {
        let name: String = balanceModel.firstName + balanceModel.lastName
        return name
    }
    
    var customerID: String {
        return balanceModel.id
    }
}

class VendorBalanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WorkerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var customerBalances: [VendorBalanceViewModel] = []
    var vendorBalanceOverview: VendorBalanceOverviewViewModel?
    var selectedRow: Int!
    
    var worker = Worker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.worker.delegate = self
        fetchCustomerBalancesOnLoad()
    }
    
    func fetchCustomerBalancesOnLoad() {
        // Tell Worker to fetch customer balances
        worker.fetchCustomerBalances()
        worker.fetchVendorBalance()
    }
    
    // MARK :- WorkerDelegate Protocol Method
    
    func displayFetchedList(of customerBalances: [VendorBalanceViewModel]) {
        self.customerBalances = customerBalances
        tableView.reloadData()
    }
    
    func displayFetched(with vendorBalance: VendorBalanceOverviewViewModel) {
        self.vendorBalanceOverview = vendorBalance
        tableView.reloadData()
    }
    
    @IBAction func LogoutHandler(_ sender: UIButton) {
        sender.logout()
    }
    
    // MARK :- UITableViewDataSource Protocol Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return VendorBalanceSection.count()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = VendorBalanceSection(rawValue: section) else {
            return ""
        }
        return section.sectionTitle()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = VendorBalanceSection(rawValue: section) else {
            return 1
        }
        switch section {
        case .OverallBalance: return 2
        case .CustomerBalance: return customerBalances.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = VendorBalanceSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .OverallBalance: return cellForOverallBalanceSection(ForRowAt: indexPath)
        case .CustomerBalance: return cellForCustomerBalancesSection(ForRowAt: indexPath)
        default: return UITableViewCell()
        }
    }
    
    // MARK :- UITableViewDataSource Protocol Helper Methods
    
    func cellForOverallBalanceSection(ForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "You Owe"
            cell.detailTextLabel?.text = "You Are Owed"
        case 1:
            cell.textLabel?.text = vendorBalanceOverview?.debitText ?? "0"
            cell.detailTextLabel?.text = vendorBalanceOverview?.creditText ?? "0"
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func cellForCustomerBalancesSection(ForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user cell", for: indexPath)
        cell.textLabel?.text = customerBalances[indexPath.row].customerName
        cell.detailTextLabel?.text = customerBalances[indexPath.row].balanceText
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK :- UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "TransactionHistorySegue", sender: self)
    }
    
    // MARK :- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TransactionHistoryViewController
        destVC.customerBalance = customerBalances[self.selectedRow]
    }
}
