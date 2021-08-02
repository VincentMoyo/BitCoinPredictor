//
//  BalanceData.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/02.
//

import Foundation

struct BalanceData {
    private var initialBalance = 0.0
    private var initialEquity = 0.0
    private var initialFreeMargin = 0.0
    private var initialBitcoin = 0.0
    
    var balance: Double {
        get {
            return initialBalance
        }
        set {
            initialBalance = newValue
        }
    }
    
    var equity: Double {
        get {
            return initialEquity
        }
        set {
            initialEquity = newValue
        }
    }
    
    var freeMargin: Double {
        get {
            return initialFreeMargin
        }
        set {
            initialFreeMargin = newValue
        }
    }
    
    var bitcoin: Double {
        get {
            return initialBitcoin
        }
        set {
            initialBitcoin = newValue
        }
    }
}
