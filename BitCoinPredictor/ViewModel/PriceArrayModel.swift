//
//  PriceListModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import Foundation

struct PriceArrayModel {
    let rate: String
    let date: String
    
    init(priceList: PriceArray) {
        self.rate = priceList.rate
        self.date = priceList.date
    }
}
