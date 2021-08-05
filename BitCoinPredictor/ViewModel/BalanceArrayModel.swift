//
//  BalanceListModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/30.
//

import Foundation

struct BalanceArrayModel {
    let balance: String
    let equity: String
    let freeMargin: String
    let bitcoin: String
    
    init(balanceList: BalanceArray) {
        self.balance = balanceList.balance
        self.equity = balanceList.equity
        self.freeMargin = balanceList.freeMargin
        self.bitcoin = balanceList.bitcoin
    }
}
