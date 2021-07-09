//
//  Constants.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/09.
//

import Foundation

struct K {
    struct News {
        static let identifier = "NewsTableCellViewController"
        static let apiKey = "2f6fc28af88f4ad0955e7e4568e26c37"
        static let headline = "bitcoin"
    }
    
    struct Database {
        static let BitCoinDatabaseName = "ByteCoins"
        static let PredictedPriceDatabaseName = "PredictedPricesDatabase"
        static let PredictedPriceDocumentName = "prices"
    }
}
