//
//  ViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/04.
//

import UIKit
import Charts
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var chartViewPrices: UIView!
    @IBOutlet weak var liveGraphView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    private var candleChart = CandleStickChartView()
    private var timer = Timer()
    private var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.invalidate()
        activateActivityIndicatorView()
        startUpdateTimer()
        bindHomeViewModel()
    }
    
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func modifyChart() {
        candleChart.dragEnabled = true
        candleChart.setScaleEnabled(true)
        candleChart.pinchZoomEnabled = true
    }
    
    private func bindHomeViewModel() {
        homeViewModel.didHomeViewModelLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.bitCoinLabel.text = String(self.homeViewModel.priceData.price)
                    self.candleChart.delegate = self
                    self.modifyChart()
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        candleChart.zoomOut()
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        candleChart.zoomIn()
    }
    
    @objc func updateTimer() {
        bindHomeViewModelErrors()
        homeViewModel.updateTimer()
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func bindHomeViewModelErrors() {
        homeViewModel.homeViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
        }
    }
}

// MARK: - Chart View Delegate section
extension HomeViewController: ChartViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setChartFrame()
        liveGraphView.addSubview(candleChart)
        let set = CandleChartDataSet(entries: setChartEntries())
        setPropertiesOfSet(for: set)
        
        let data = CandleChartData(dataSet: set)
        candleChart.data = data
    }
    
    private func setChartFrame() {
        candleChart.frame = CGRect(x: 0, y: 0,
                                   width: self.liveGraphView.frame.size.width,
                                   height: self.liveGraphView.frame.size.height)
        candleChart.xAxis.drawLabelsEnabled = false
    }
    
    private func setChartEntries() -> [CandleChartDataEntry] {
        var entries = [CandleChartDataEntry]()
        homeViewModel.priceList.forEach { price in
            homeViewModel.priceData.date += 1
            entries.append(CandleChartDataEntry(x: homeViewModel.priceData.date,
                                                shadowH: setShadowHigh(for: Double(price.rate)!),
                                                shadowL: setShadowLow(for: Double(price.rate)!),
                                                open: homeViewModel.previousPrice,
                                                close: Double(price.rate)!))
            homeViewModel.previousPrice = Double(price.rate)!
        }
        return entries
    }
    
    private func setPropertiesOfSet(for set1: CandleChartDataSet) {
        set1.drawValuesEnabled = false
        set1.label = NSLocalizedString("BITCOIN_GRAPH", comment: "")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 1
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = .green
        set1.increasingFilled = true
        set1.neutralColor = .blue
    }
    
    private func setShadowHigh(for price: Double) -> Double {
        return price > homeViewModel.previousPrice ? ((price - homeViewModel.previousPrice) / 5) +  price :
            ((homeViewModel.previousPrice - price) / 5) + homeViewModel.previousPrice
    }
    
    private func setShadowLow(for price: Double) -> Double {
        return price > homeViewModel.previousPrice ? homeViewModel.previousPrice - ((price - homeViewModel.previousPrice) / 5):
            price - ((homeViewModel.previousPrice - price) / 5)
    }
}

// MARK: - User Alerts
extension UIViewController {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("ERROR", comment: ""),
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                                style: .default,
                                                handler: nil))
        
        present(alertController, animated: true)
    }
    
    func showUserSuccessMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("SUCCESS", comment: ""),
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                                style: .default,
                                                handler: nil))
        
        present(alertController, animated: true)
    }
}
