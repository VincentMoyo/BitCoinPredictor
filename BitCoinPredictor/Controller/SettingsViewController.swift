//
//  SettingsViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var firstNameLabel: UIButton!
    @IBOutlet weak var lastNameLabel: UIButton!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
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
    
    @IBAction func setProfilePicturePressed(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        profilePictureImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setFirstNamePressed(_ sender: UIButton) {
        setupProfileNames(firstNameLabel)
    }
    
    @IBAction func setLastNamePressed(_ sender: UIButton) {
        setupProfileNames(lastNameLabel)
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

extension SettingsViewController {
    
    private func setupProfileNames(_ nameLabel: UIButton) { 
        var textField = UITextField()
        let alert = UIAlertController(title: "Set Name", message: "Set your username to complete your profile account setup", preferredStyle: .alert)
        let actions = UIAlertAction(title: "Change", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                nameLabel.setTitle(textField.text, for: .normal)
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
