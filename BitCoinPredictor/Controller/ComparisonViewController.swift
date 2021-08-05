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
    @IBOutlet weak var predictedPriceLabel: UILabel!
    @IBOutlet weak var chartComparisonPrices: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    private let comparisonViewModel = ComparisonViewModel()
    private var candleChart = CandleStickChartView()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.invalidate()
        activateActivityIndicatorView()
        startUpdateTimer()
        bindComparisonViewModel()
    }
    
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func bindComparisonViewModel() {
        comparisonViewModel.didComparisonViewModelLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.comparisonViewModel.priceData.date = 0
                    self.actualPriceLabel.text = String(self.comparisonViewModel.priceData.price)
                    self.predictedPriceLabel.text = String(self.comparisonViewModel.predictedPriceData.currentPrice)
                    self.candleChart.delegate = self
                    self.modifyChart()
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    @objc func updateTimer() {
        bindComparisonViewModelErrors()
        comparisonViewModel.updateTimer()
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func modifyChart() {
        candleChart.dragEnabled = true
        candleChart.setScaleEnabled(true)
        candleChart.pinchZoomEnabled = true
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        candleChart.zoomIn()
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        candleChart.zoomOut()
    }
    private func bindComparisonViewModelErrors() {
        comparisonViewModel.comparisonViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
        }
    }
}

// MARK: - Chart View Delegate section
extension ComparisonViewController: ChartViewDelegate {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartComparisonPrices.addSubview(candleChart)
        setChartFrame()
        let firstSet = CandleChartDataSet(entries: chartEntriesForFirstSet())
        let secondSet = CandleChartDataSet(entries: chartEntriesForSecondSet())
        
        setPropertiesForFirstSet(firstSet)
        setPropertiesForSecondSet(secondSet)
        
        let data = CandleChartData(dataSet: firstSet)
        data.addDataSet(secondSet)
        candleChart.data =  data
    }
    
    private func setChartFrame() {
        candleChart.frame = CGRect(x: 0, y: 0,
                                   width: self.chartComparisonPrices.frame.size.width,
                                   height: self.chartComparisonPrices.frame.size.height)
        candleChart.xAxis.drawLabelsEnabled = false
    }
    
    private func chartEntriesForFirstSet() -> [CandleChartDataEntry] {
        var entries = [CandleChartDataEntry]()
        comparisonViewModel.priceArray.forEach { price in
            comparisonViewModel.priceData.date += 1
            entries.append(CandleChartDataEntry(x: comparisonViewModel.priceData.date,
                                                shadowH: setShadowHigh(for: Double(price.rate)!),
                                                shadowL: setShadowLow(for: Double(price.rate)!),
                                                open: comparisonViewModel.previousPrice,
                                                close: Double(price.rate)!))
            comparisonViewModel.previousPrice = Double(price.rate)!
        }
        return entries
    }
    
    private func chartEntriesForSecondSet() -> [CandleChartDataEntry] {
        return [CandleChartDataEntry(x: comparisonViewModel.predictedPriceData.currentDate,
                                     shadowH: comparisonViewModel.predictedPriceData.currentPrice,
                                     shadowL: comparisonViewModel.predictedPriceData.currentPrice,
                                     open: comparisonViewModel.predictedPriceData.currentPrice,
                                     close: comparisonViewModel.predictedPriceData.currentPrice)]
    }
    
    private func setPropertiesForFirstSet(_ firstSet: CandleChartDataSet) {
        firstSet.drawValuesEnabled = false
        firstSet.label = NSLocalizedString("BITCOIN_GRAPH", comment: "")
        firstSet.axisDependency = .left
        firstSet.setColor(UIColor(white: 80/255, alpha: 1))
        firstSet.drawIconsEnabled = false
        firstSet.shadowColor = .darkGray
        firstSet.shadowWidth = 1
        firstSet.decreasingColor = .red
        firstSet.decreasingFilled = true
        firstSet.increasingColor = .green
        firstSet.increasingFilled = true
        firstSet.neutralColor = .blue
    }
    
    private func setPropertiesForSecondSet(_ secondSet: CandleChartDataSet) {
        secondSet.label = nil
        secondSet.highlightEnabled = true
        secondSet.highlightColor = .red
        secondSet.highlightLineWidth = 4
        secondSet.highlightLineDashLengths = [4, 2]
        secondSet.drawHorizontalHighlightIndicatorEnabled = true
        secondSet.drawVerticalHighlightIndicatorEnabled = true
    }
    
    private func setShadowHigh(for price: Double) -> Double {
        return price > comparisonViewModel.previousPrice ? ((price - comparisonViewModel.previousPrice) / 5) +  price :
            ((comparisonViewModel.previousPrice - price) / 5) + comparisonViewModel.previousPrice
    }
    
    private func setShadowLow(for price: Double) -> Double {
        return price > comparisonViewModel.previousPrice ? comparisonViewModel.previousPrice - ((price - comparisonViewModel.previousPrice) / 5):
            price - ((comparisonViewModel.previousPrice - price) / 5)
    }
}
