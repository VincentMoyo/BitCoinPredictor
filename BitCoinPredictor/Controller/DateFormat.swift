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
        K.dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = K.dateFormatterGet.string(from: date)
        let newDate = K.dateFormatterGet.date(from: result)
        return newDate!
    }
}
