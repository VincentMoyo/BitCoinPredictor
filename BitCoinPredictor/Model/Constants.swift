//
//  Constants.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/09.
//

import Foundation

struct Constants {
    
    static let dateFormatterGet = DateFormatter()
    
    struct News {
        static let kIdentifier = "Cell"
        static let kCellNibName = "NewsTableViewCell"
        static let kApiKey = "2f6fc28af88f4ad0955e7e4568e26c37"
        static let kHeadline = "Bitcoin"
    }
    
    struct Database {
        static let kBitCoinDatabaseName = "ByteCoins"
        static let kPredictedPriceDatabaseName = "PredictedPricesDatabase"
        static let kPredictedPriceDocumentName = "prices"
        static let kDate = "date"
        static let kRate = "rate"
        static let kPrice = "price"
        
        static let kBalanceDatabaseName = "AccountBalanceDatabase"
        static let kBalanceDocumentName = "balances"
        static let kBalance = "balance"
        static let kEquity = "equity"
        static let kFreeMargin = "freeMargin"
        static let kBitboin = "bitboin"
    }
    
    struct Authentication {
        static let kRegisterSegue = "register"
        static let kLoginSegue = "login"
    }
}
