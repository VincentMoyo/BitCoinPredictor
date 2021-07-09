//
//  Controller.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/14.
//

import Foundation

struct CrementClass {
    func incrementByInterval(_ byteCoinPrice: Double, _ incrementValue: Double, _ increment: Bool) -> Double{
        var finalPrice = 0.0
        if incrementValue > 0 {
            if (increment){
                finalPrice = byteCoinPrice + incrementValue
            } else {
                finalPrice = byteCoinPrice - incrementValue
            }
        }
        return finalPrice
    }
}
