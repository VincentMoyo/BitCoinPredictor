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
    
    var candleChart = CandleStickChartView()
    var timer = Timer()
    var homeViewModel = HomeViewModel()
    var prevPrice = 0.0
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateActivityIndicatorView()
        updateTimer()
        loadScreenView()
        timer.invalidate()
        modifyChart()
    }
    
    func modifyChart() {
        candleChart.dragEnabled = false
        candleChart.setScaleEnabled(true)
        candleChart.pinchZoomEnabled = true
    }
    
    @IBAction func liveGraphChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                         selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    private func loadScreenView() {
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
    
    @objc func updateTimer() {
        bindViewModelError()
        homeViewModel.updateTimer()
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
}

// MARK: - User Alerts
extension HomeViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    private func bindViewModelError() {
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
        setPropertiesOfSet(set)
        
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
        homeViewModel.loadReleventAmountOfData()
        homeViewModel.priceList.forEach { price in
            entries.append(CandleChartDataEntry(x: Double(count + 1),
                                                shadowH: Double(price.rate)! > prevPrice ? ((Double(price.rate)! - prevPrice) / 5) +  Double(price.rate)! :
                                                    ((prevPrice - Double(price.rate)!) / 5) + prevPrice,
                                                shadowL: Double(price.rate)! > prevPrice ? prevPrice - ((Double(price.rate)! - prevPrice) / 5):
                                                    Double(price.rate)! - ((prevPrice - Double(price.rate)!) / 5),
                                                open: prevPrice,
                                                close: Double(price.rate)!))
            prevPrice = Double(price.rate)!
            count += 1
        }
        return entries
    }
    
    private func setPropertiesOfSet(_ set1: CandleChartDataSet) {
        set1.drawValuesEnabled = false
        set1.label = "Bitcoin Graph"
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
}
