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
    private var lineChart = LineChartView()
    private var timer = Timer()
    private lazy var predictedPrice = 0.0
    private lazy var predictedTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateActivityIndicatorView()
        updateTimer()
        loadScreenView()
        timer.invalidate()
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
                    self.actualPriceLabel.text = String(self.comparisonViewModel.priceData.price)
                    self.predictedPricelLabel.text = String(self.comparisonViewModel.predictedPriceData.currentPrice)
                    self.lineChart.delegate = self
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
        chartComparisonPrices.addSubview(lineChart)
        setChartFrame()
        let set = LineChartDataSet(entries: setChartEntries())
        let set2 = LineChartDataSet(entries: [
            ChartDataEntry(x: comparisonViewModel.predictedPriceData.currentDate,
                           y: comparisonViewModel.predictedPriceData.currentPrice)
        ])
        
        setPropertiesOfSet1(set)
        setPropertiesOfSet2(set2)
        
        let data = LineChartData(dataSet: set)
        data.addDataSet(set2)
        lineChart.data =  data
    }
    
    private func setChartFrame() {
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.chartComparisonPrices.frame.size.width,
                                 height: self.chartComparisonPrices.frame.size.height)
        lineChart.xAxis.drawLabelsEnabled = false
    }
    
    private func setChartEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for price in comparisonViewModel.priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        return entries
    }
    
    private func setPropertiesOfSet1(_ set: LineChartDataSet) {
        set.colors = ChartColorTemplates.colorful()
        set.drawValuesEnabled = false
    }
    
    private func setPropertiesOfSet2(_ set2: LineChartDataSet) {
        set2.highlightEnabled = true
        set2.highlightColor = .red
        set2.highlightLineWidth = 4
        set2.highlightLineDashLengths = [4, 2]
        set2.drawHorizontalHighlightIndicatorEnabled = true
        set2.drawVerticalHighlightIndicatorEnabled = true
    }
}
