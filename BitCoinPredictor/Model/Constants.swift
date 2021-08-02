//
//  Constants.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/09.
//

import Foundation

struct Constants {
    
    struct News {
        static let kIdentifier = "Cell"
        static let kCellNibName = "NewsTableViewCell"
        static let kApiKey = "2f6fc28af88f4ad0955e7e4568e26c37"
        static let kHeadline = "bitcoin"
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
        static let kBitcoin = "bitboin"
    }
    
    struct Authentication {
        static let kRegisterSegue = "register"
        static let kLoginSegue = "login"
    }
    
    struct APIS {
        static let kBaseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
        static let kApiKey1 = "4645E475-133C-458A-AA48-2EB70A347301"
        static let kApiKey2 = "6FE19785-42B1-4D8E-92B3-EC4FDBE3DB75"
        static let kApiKey3 = "4ADA8654-C36C-448C-A383-3A2B2E5FE169"
        static let kApiKey4 = "ED0E63CD-0577-4190-8C24-BC1F2A276C21"
        static let kApiKey5 = "30EEDBD2-1710-4A2F-97E6-1EF66EF32F47"
        static let kApiKey6 = "279DBB07-FF50-4819-94DB-579005BD3BCD"
        static let kApiKey7 = "CDD3FE7D-2AE7-47F3-85CE-B9904F8EE477"
        
        static let kCurrency = "ZAR"
    }
    
    struct FormatForDate {
        static let dateFormatterGet = DateFormatter()
        static let DateFormate = "yyyy-MM-dd HH:mm:ss"
    }
    
}
