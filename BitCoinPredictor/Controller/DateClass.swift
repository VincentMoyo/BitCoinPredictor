//
//  DateClass.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/29.
//

import Foundation

struct DateClass {
    func getCurrentDate() -> Date {
        let date = Date()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = dateFormatterGet.string(from: date)
        let newDate = dateFormatterGet.date(from: result)
        return newDate!
    }
}
