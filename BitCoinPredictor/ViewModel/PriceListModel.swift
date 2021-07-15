//
//  PriceListModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import Foundation

struct PriceListModel {
    let rate: String
    let date: String
    
    init(priceList: PriceList) {
        self.rate = priceList.rate
        self.date = priceList.date
    }
}
