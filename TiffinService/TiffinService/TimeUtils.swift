//
//  TimeUtils.swift
//  TiffinService
//
//  Created by Srikant Viswanath on 4/22/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import Foundation

func getCurrentTime() -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: Date())
}

