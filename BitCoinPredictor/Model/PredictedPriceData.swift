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
        set{
            initialPredictedPrice = newValue
        }
        get {
            return initialPredictedPrice
        }
    }
    
    var currentDate: Double {
        set{
            initialPredictedDate = newValue
        }
        get {
            return initialPredictedDate
        }
    }
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
}
