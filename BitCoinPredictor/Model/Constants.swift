//
//  Constants.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/09.
//

import Foundation

struct K {
    
    static let dateFormatterGet = DateFormatter()
    
    struct News {
        static let identifier = "Cell"
        static let cellNibName = "NewsCell"
        static let apiKey = "2f6fc28af88f4ad0955e7e4568e26c37"
        static let headline = "Bitcoin"
    }
    
    struct Database {
        static let BitCoinDatabaseName = "ByteCoins"
        static let PredictedPriceDatabaseName = "PredictedPricesDatabase"
        static let PredictedPriceDocumentName = "prices"
        static let date = "date"
        static let rate = "rate"
        static let price = "price"
    }
    
    struct Authentication {
        static let registerSegue = "register"
        static let loginSegue = "login"
    }
}
