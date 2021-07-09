//
//  TimerViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/05.
//

import UIKit
import Charts
import FirebaseFirestore

class TimerViewController: UIViewController, ChartViewDelegate {

    var dataManager = APIManager()
    var timerSeconds = 0
    let apiClass = APIClass()
    var database = DatabaseManager()
    var priceList: [PriceList] = []
    var lineChart = LineChartView()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func updateTimer(){
    }
}
