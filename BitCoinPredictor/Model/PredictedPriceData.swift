//
//  PredictedPriceData.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import Foundation

class PredictedPriceData {
    private var initialPredictedPrice = 0.0
    private var initialPredictedDate = 0.0
    
    var currentPrice: Double {
        get {
            return initialPredictedPrice
        }
        set {
            initialPredictedPrice = newValue
        }
    }
    
    var currentDate: Double {
        get {
            return initialPredictedDate
        }
        set {
            initialPredictedDate = newValue
        }
    }
}

class PriceData {
    private var initialPrice = 0.0
    var price: Double {
        get {
            return initialPrice
        }
        set {
            initialPrice = newValue
        }
    }
}
