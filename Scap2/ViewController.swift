//
//  ViewController.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mainSV: UIStackView!
    @IBOutlet weak var UserNameSV: UIStackView!
    @IBOutlet weak var PasswordSV: UIStackView!
    
    @IBOutlet weak var SignUpSV: UIStackView!
    @IBOutlet weak var LoginSV: UIStackView!
    
        @IBOutlet weak var usernameTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var passwordVisibilityButton: UIButton!
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var resetPasswordButton: UIButton!
        
        // MARK: - Properties
        
        private var isPasswordHidden = true
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureTextFields()
            configureButtons()
        }
        
        // MARK: - Actions
        
        @IBAction func passwordVisibilityButtonTapped(_ sender: Any) {
            isPasswordHidden.toggle()
            let image = isPasswordHidden ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
            passwordVisibilityButton.setImage(image, for: .normal)
            passwordTextField.isSecureTextEntry = isPasswordHidden
        }
        
        @IBAction func loginButtonTapped(_ sender: Any) {
            // Handle login logic here
        }
        
        @IBAction func resetPasswordButtonTapped(_ sender: Any) {
            // Handle reset password logic here
        }
        
        // MARK: - Private methods
        
        private func configureTextFields() {
            usernameTextField.placeholder = "Username"
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
        
        private func configureButtons() {
            loginButton.setTitle("Login", for: .normal)
            loginButton.backgroundColor = .systemBlue
            loginButton.layer.cornerRadius = 10
            resetPasswordButton.setTitle("Reset Password", for: .normal)
            resetPasswordButton.setTitleColor(.systemBlue, for: .normal)
        }
}

