//
//  Conversion.swift
//  Currencies
//
//  Created by Manal El Ouardani on 1/8/2021.
//

import SwiftUI

struct Conversion: Decodable {
    var rates : [String: Double]
    var date: String
    var base: String
}


