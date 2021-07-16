//
//  PredictedPriceData.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import Foundation

class PredictedPriceData {
    
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
