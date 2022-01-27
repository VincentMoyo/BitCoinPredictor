//
//  PredictViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit

class PredictViewController: UIViewController, ErrorReporting, DisplayingSuccessMessage {
    
    private var predictViewModel = PredictViewModel()
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var predictPriceLabel: UILabel!
    @IBOutlet private weak var tenIncrementButton: UIButton!
    @IBOutlet private weak var hundredIncrementButton: UIButton!
    @IBOutlet private weak var thousandIncrementButton: UIButton!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateActivityIndicatorView()
        predictViewModel.loadPriceData()
        bindPredictViewModel()
    }
    
    private func bindPredictViewModel() {
        predictViewModel.didPredictViewModelLoad = { result in
            if result {
                self.priceLabel.text = String(self.predictViewModel.bitcoinPrice.price)
                self.predictPriceLabel.text = String(self.predictViewModel.bitcoinPrice.price)
                self.predictViewModel.predictedBitcoinPrice.currentPrice = self.predictViewModel.bitcoinPrice.price
                self.activityLoader.stopAnimating()
            }
        }
    }
    
    @IBAction func incrementPriceButtonPressed(_ sender: UIButton) {
        predictViewModel.predictedBitcoinPrice.currentPrice = predictViewModel
            .incrementByInterval(predictViewModel.predictedBitcoinPrice.currentPrice, predictViewModel.intervalValue, true)
        predictPriceLabel.text = String(predictViewModel.predictedBitcoinPrice.currentPrice)
    }
    
    @IBAction func decrementPriceButtonPressed(_ sender: UIButton) {
        predictViewModel.predictedBitcoinPrice.currentPrice = predictViewModel
            .incrementByInterval(predictViewModel.predictedBitcoinPrice.currentPrice, predictViewModel.intervalValue, false)
        predictPriceLabel.text = String(predictViewModel.predictedBitcoinPrice.currentPrice)
    }
    
    @IBAction func incrementChanged(_ sender: UIButton) {
        tenIncrementButton.isSelected = false
        hundredIncrementButton.isSelected = false
        thousandIncrementButton.isSelected = false
        sender.isSelected = true
        predictViewModel.intervalValue = Double(sender.currentTitle!)!
    }
    
    @IBAction func predictButtonPressed(_ sender: UIButton) {
        predictViewModel.insertPredictedPriceIntoDatabase(self, self)
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
}
