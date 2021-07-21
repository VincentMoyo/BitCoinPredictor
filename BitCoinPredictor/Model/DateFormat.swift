//
//  DateClass.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/29.
//

import Foundation

struct DateFormat {
    func getCurrentDate() -> Date {
        let date = Date()
        Constants.dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = Constants.dateFormatterGet.string(from: date)
        let newDate = Constants.dateFormatterGet.date(from: result)
        return newDate!
    }
}
