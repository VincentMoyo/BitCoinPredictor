//
//  PriceData.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/02.
//

import Foundation

struct PriceData {
    private var initialPrice = 0.0
    private var initialDate = 0.0
    
    var price: Double {
        get {
            return initialPrice
        }
        set {
            initialPrice = newValue
        }
    }
    
    var date: Double {
        get {
            return initialDate
        }
        set {
            initialDate = newValue
        }
    }
}
