//
//  OrderNetworker.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

func parseMenuItemsSnapshot(menuItemsSS: FIRDataSnapshot) -> [MenuItem]{
    var menuItemObjsFetched = [MenuItem]()
    if let jsonItems = menuItemsSS.children.allObjects as? [FIRDataSnapshot] {
        for jsonItem in jsonItems {
            let menuItem = Mapper<MenuItem>().map(JSON: jsonItem.value as! [String: Any])!
            menuItem.itemID = jsonItem.key
            menuItemObjsFetched.append(menuItem)
        }
    }
    return menuItemObjsFetched
}

class MenuItemNetworker {
    
    static var REF_INVENTORY = FIRDatabase.database().reference().child("MenuItems")
    
    var delegate: NetworkDelegate?
    var viewModelsFetched = [MenuItemVM]()
    
    func getAll() {
        MenuItemNetworker.REF_INVENTORY.observeSingleEvent(of: .value, with: { menuItemsSS in
            let models = parseMenuItemsSnapshot(menuItemsSS: menuItemsSS)
            for model in models {
                self.viewModelsFetched.append(MenuItemVM(menuItem: model))
            }
            self.delegate?.itemsDidAdd()
        })
    }
    
    /**
     method for writing an instance of MenuItem class to Firebase, by
     converting to JSON.
     :update: if set to true indicates updating a pre-existing node at Firebase
     */
    func writeToDB(viewModel: MenuItemVM, is update:Bool=false, completed: @escaping ()->()) {
        let jsonItem = Mapper().toJSON(viewModel.model)
        if !update {
            let newMenuItemRef = MenuItemNetworker.REF_INVENTORY.childByAutoId()
            newMenuItemRef.updateChildValues(jsonItem) {_,_ in completed()}
        } else {
            MenuItemNetworker.REF_INVENTORY.child(viewModel.model.itemID).updateChildValues(jsonItem) { _, _ in completed()}
        }
    }
    
}

class PublishedMenuNetworker {
    
    static var REF_PUBLISHED = FIRDatabase.database().reference().child("PublishedMenu")
    static var REF_PUBLISHED_TODAY = PublishedMenuNetworker.REF_PUBLISHED.child(getCurrentDate())
    
    var delegate: NetworkDelegate?
    var viewModelsFetched = [PublishedMenuVM]()
    
    func getMenu(for date:String=getCurrentDate()) {
        PublishedMenuNetworker.REF_PUBLISHED.child(date).observe(.value, with: { publishedMenuSS in
            let menuItems = parseMenuItemsSnapshot(menuItemsSS: publishedMenuSS)
            let publishedMenuObj = PublishedMenu(publishDate: date, menuItems: menuItems)
            self.viewModelsFetched = [PublishedMenuVM(publishedMenu: publishedMenuObj)]
            self.delegate?.itemsDidAdd()
        })
    }
    
    /**
     Method to write an instance of PublishedMenu to Firebase. It is always writen to today's date child node
     */
    func writeToDB(viewModel: PublishedMenuVM, is update:Bool=false, completed: @escaping ()->()) {
        var dataToWrite = [String: Any]()
        for menuItem in viewModel.model.containees {
            dataToWrite[menuItem.itemID] = Mapper().toJSON(menuItem)
        }
        PublishedMenuNetworker.REF_PUBLISHED_TODAY.updateChildValues(dataToWrite) {_, _ in completed()}
    }
    
    
    
}
