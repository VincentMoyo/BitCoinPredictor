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

class PriceData {
    
    private var initialPrice = 0.0
    var price: Double {
        set{
            initialPrice = newValue
        }
        get {
            return initialPrice
        }
    }
    
    private var initialPredictedPrice = 0.0
    var currentPrice: Double {
        set{
            initialPredictedPrice = newValue
        }
        get {
            return initialPredictedPrice
        }
    }
}
