//
//  BalanceViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/31.
//

import UIKit

class BalanceViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var equityLabel: UILabel!
    @IBOutlet weak var freeMargin: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    private var balanceViewModel = BalanceViewModel()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateActivityIndicatorView()
        startTimer()
        loadScreenView()
        
    }
    
    @objc func updateTimer() {
        bindViewModelError()
        balanceViewModel.updateTimer()
        loadScreenView()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func loadScreenView() {
        balanceViewModel.didBalanceViewModelLoad = { result in
            if result {
                self.balanceViewModel.balanceList.forEach { accountBalance in
                    DispatchQueue.main.async {
                        self.balanceLabel.text = accountBalance.balance
                        self.equityLabel.text = accountBalance.equity
                        self.freeMargin.text = accountBalance.freemargin
                        self.bitcoinLabel.text = accountBalance.bitcoin
                        self.activityLoader.stopAnimating()
                    }
                }
            }
        }
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
}

// MARK: - User Alerts
extension BalanceViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    private func bindViewModelError() {
        balanceViewModel.balanceViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
        }
    }
}
