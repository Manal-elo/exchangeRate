//
//  Currency.swift
//  Currencies
//
//  Created by Manal El Ouardani on 1/8/2021.
//

import SwiftUI

struct Currency: Identifiable {
    var id = UUID().uuidString
    var currencyName: String
    var currencyValue: Double
    
 
}
var currencies = ["USD", "EUR", "INR", "JPY", "AUD", "RUB", "LYD", "BTN", "ANG", "MMK", "ETB","AWG","GMD","ZAR","LBP"]



