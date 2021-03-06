//
//  SettingsViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet private weak var firstNameLabel: UIButton!
    @IBOutlet private weak var lastNameLabel: UIButton!
    @IBOutlet private weak var profilePictureImage: UIImageView!
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    private var settingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoader.isHidden = true
        settingsViewModel.loadUserSettings()
        bindSettingsViewModel()
        bindSignOutSettingsViewModel()
        bindSettingsViewModelErrors()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        settingsViewModel.signOutUser()
        activateActivityIndicatorView()
    }
    
    @IBAction func setProfilePicturePressed(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func setFirstNamePressed(_ sender: UIButton) {
        setupProfileNames(firstNameLabel, isFirstName: true)
    }
    
    @IBAction func setLastNamePressed(_ sender: UIButton) {
        setupProfileNames(lastNameLabel, isFirstName: false)
    }
    
    @IBAction func dateOfBirthPressed(_ sender: UIDatePicker) {
        Constants.FormatForDate.dateFormatterGet.dateFormat = Constants.FormatForDate.DateFormate
        let dateResult = Constants.FormatForDate.dateFormatterGet.string(from: datePicker.date)
        settingsViewModel.updateDateOfBirth(dateResult)
    }
    
    @IBAction func genderIndexChangedPressed(_ sender: Any) {
        guard let selectedGender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) else { return }
        settingsViewModel.updateGender(selectedGender)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        profilePictureImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func bindSignOutSettingsViewModel() {
        settingsViewModel.didSignOutUserLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.Authentication.kWelcomeSegue, sender: self)
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    private func bindSettingsViewModel() {
        settingsViewModel.didLoadUserSetting = { result in
            if result {
                self.settingsViewModel.userSettingsList.forEach { settings in
                    self.firstNameLabel.setTitle(settings.firstName, for: .normal)
                    self.lastNameLabel.setTitle(settings.lastName, for: .normal)
                    Constants.FormatForDate.dateFormatterGet.dateFormat = Constants.FormatForDate.DateFormate
                    guard let dateResult = Constants.FormatForDate.dateFormatterGet.date(from: settings.dateOfBirth) else { return }
                    self.datePicker.setDate(dateResult, animated: true)
                }
                self.activityLoader.stopAnimating()
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

// MARK: - Alerts
extension SettingsViewController {
    
    private func setupProfileNames(_ nameLabel: UIButton, isFirstName firstName: Bool) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Set Name", message: "Set your username to complete your profile account setup", preferredStyle: .alert)
        let actions = UIAlertAction(title: "Change", style: .default, handler: { (_) in
            if firstName {
                nameLabel.setTitle(textField.text, for: .normal)
                self.settingsViewModel.updateFirstName(textField.text ?? "Not Set")
            } else {
                nameLabel.setTitle(textField.text, for: .normal)
                self.settingsViewModel.updateLastName(textField.text ?? "Not Set")
            }
        })
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New Name"
            textField = alertTextField
        }
        alert.addAction(actions)
        present(alert, animated: true, completion: nil)
    }
}
