//
//  DateUtils.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

///Return current date in mm-dd-yyyy format
func getCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter.string(from: date)
}

