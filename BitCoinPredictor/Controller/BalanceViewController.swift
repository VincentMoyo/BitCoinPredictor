//
//  BalanceViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/31.
//

import UIKit

class BalanceViewController: UIViewController {
    
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var equityLabel: UILabel!
    @IBOutlet private weak var freeMargin: UILabel!
    @IBOutlet private weak var bitcoinLabel: UILabel!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    private var balanceViewModel = BalanceViewModel()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateActivityIndicatorView()
        startTimer()
        bindBalanceViewModel()
    }
    
    @objc func updateTimer() {
        bindBalanceViewModelErrors()
        balanceViewModel.updateTimer()
        bindBalanceViewModel()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func bindBalanceViewModel() {
        balanceViewModel.didBalanceViewModelLoad = { result in
            if result {
                self.balanceViewModel.balanceArray.forEach { accountBalance in
                    self.balanceLabel.text = accountBalance.balance
                    self.equityLabel.text = accountBalance.equity
                    self.freeMargin.text = accountBalance.freeMargin
                    self.bitcoinLabel.text = accountBalance.bitcoin
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func bindBalanceViewModelErrors() {
        balanceViewModel.balanceViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
        }
    }
}
