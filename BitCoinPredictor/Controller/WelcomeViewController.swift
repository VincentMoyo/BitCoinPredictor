//
//  WelcomeViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var welcomeViewModel = WelcomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if welcomeViewModel.sigInInUser() {
            self.performSegue(withIdentifier: Constants.Authentication.kLoginSegue, sender: self)
        }
    }
}
