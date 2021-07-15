//
//  PriceList.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/23.
//

import Foundation

struct PriceList {
    let rate: String
    let date: String
}

struct CoinData: Decodable {
    let rate: Double
}
