//
//  SettingsViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    var settingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoader.isHidden = true
        bindSettingsViewModel()
        bindSettingsViewModelErrors()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        settingsViewModel.signOutUser()
        activateActivityIndicatorView()
    }
    
    private func bindSettingsViewModel() {
        settingsViewModel.didSignOutUserLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.Authentication.kWelcomeSegue, sender: self)
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.isHidden = false
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func bindSettingsViewModelErrors() {
        settingsViewModel.signOutViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
            self.activityLoader.stopAnimating()
        }
    }
}
