//
//  ComparisonViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit
import Charts

class ComparisonViewController: UIViewController {
    
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var predictedPricelLabel: UILabel!
    @IBOutlet weak var chartComparisonPrices: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    private let comparisonViewModel = ComparisonViewModel()
    var candleChart1 = CandleStickChartView()
    private var timer = Timer()
    private lazy var predictedPrice = 0.0
    private lazy var predictedTime = 0.0
    var prevPrice = 600000.12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateActivityIndicatorView()
        updateTimer()
        loadScreenView()
        timer.invalidate()
        print("first: \(comparisonViewModel.predictedPriceData.currentDate)")
    }
    
    @IBAction func liveGraphSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                         selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    private func loadScreenView() {
        comparisonViewModel.didComparisonViewModelLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.comparisonViewModel.priceData.date = 0
                    self.actualPriceLabel.text = String(self.comparisonViewModel.priceData.price)
                    self.predictedPricelLabel.text = String(self.comparisonViewModel.predictedPriceData.currentPrice)
                    self.candleChart1.delegate = self
                    self.modifyChart()
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    @objc func updateTimer() {
        bindViewModelError()
        comparisonViewModel.updateTimer()
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    func modifyChart() {
        candleChart1.dragEnabled = true
        candleChart1.setScaleEnabled(true)
        candleChart1.pinchZoomEnabled = true
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        candleChart1.zoomOut()
    }
    
}

// MARK: - User Alert section
extension ComparisonViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    private func bindViewModelError() {
        comparisonViewModel.comparisonViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
        }
    }
}

// MARK: - Chart View Delegate section
extension ComparisonViewController: ChartViewDelegate {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartComparisonPrices.addSubview(candleChart1)
        setChartFrame()
        let set = CandleChartDataSet(entries: setChartEntries())
        let set2 = CandleChartDataSet(entries: [
            CandleChartDataEntry(x: comparisonViewModel.predictedPriceData.currentDate,
                                 shadowH: comparisonViewModel.predictedPriceData.currentPrice,
                                 shadowL: comparisonViewModel.predictedPriceData.currentPrice,
                                 open: comparisonViewModel.predictedPriceData.currentPrice,
                                 close: comparisonViewModel.predictedPriceData.currentPrice)
        ])
        
        setPropertiesOfSet1(set)
        setPropertiesOfSet2(set2)
        
        let data = CandleChartData(dataSet: set)
         data.addDataSet(set2)
        candleChart1.data =  data
    }
    
    private func setChartFrame() {
        candleChart1.frame = CGRect(x: 0, y: 0,
                                 width: self.chartComparisonPrices.frame.size.width,
                                 height: self.chartComparisonPrices.frame.size.height)
        candleChart1.xAxis.drawLabelsEnabled = false
    }
    
    private func setChartEntries() -> [CandleChartDataEntry] {
        var entries = [CandleChartDataEntry]()
        comparisonViewModel.priceList.forEach { price in
            comparisonViewModel.priceData.date += 1
            entries.append(CandleChartDataEntry(x: comparisonViewModel.priceData.date,
                                                shadowH: Double(price.rate)! > prevPrice ? ((Double(price.rate)! - prevPrice) / 5) +  Double(price.rate)! :
                                                    ((prevPrice - Double(price.rate)!) / 5) + prevPrice,
                                                shadowL: Double(price.rate)! > prevPrice ? prevPrice - ((Double(price.rate)! - prevPrice) / 5):
                                                    Double(price.rate)! - ((prevPrice - Double(price.rate)!) / 5),
                                                open: prevPrice,
                                                close: Double(price.rate)!))
            prevPrice = Double(price.rate)!
        }
        return entries
    }
    
    private func setPropertiesOfSet1(_ set1: CandleChartDataSet) {
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
    
    private func setPropertiesOfSet2(_ set2: CandleChartDataSet) {
        set2.highlightEnabled = true
        set2.highlightColor = .red
        set2.highlightLineWidth = 4
        set2.highlightLineDashLengths = [4, 2]
        set2.drawHorizontalHighlightIndicatorEnabled = true
        set2.drawVerticalHighlightIndicatorEnabled = true
    }
}
