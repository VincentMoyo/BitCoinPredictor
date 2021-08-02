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
        Constants.FormatForDate.dateFormatterGet.dateFormat = Constants.FormatForDate.DateFormate
        let result = Constants.FormatForDate.dateFormatterGet.string(from: date)
        let newDate = Constants.FormatForDate.dateFormatterGet.date(from: result)
        return newDate!
    }
}
