//
//  ViewController.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewController: BaseVC {

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
            guard let email = usernameTextField.text, let password = passwordTextField.text else {
                print("Invalid email or password")
                Utility.showPopup(with: "Invalid email or password", on: self)
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                }

                // Sign-in successful, update UI or perform other actions
                print("User signed in successfully!")
                preferenceHelper.setUserId(authResult?.user.email ?? "user 007")
                self.performSegue(withIdentifier: SEGUE.INTRO_TO_HOME, sender: self)

                
            }
        }
  
    
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.INTRO_TO_SIGNUP, sender: self)
    }
    
    
    
        
        @IBAction func resetPasswordButtonTapped(_ sender: Any) {
            // Handle reset password logic here
            guard let email = usernameTextField.text else {
                print("Invalid email or password")
                Utility.showPopup(with: "Invalid email", on: self)
                
                return
            }
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                guard self != nil else { return }
                if let error = error {
                    print("Error resetting password: \(error.localizedDescription)")
                    return
                }
                Utility.showPopup(with: "Password reset email sent successfully!", on: self!)
                // Password reset email sent successfully, update UI or perform other actions
                print("Password reset email sent successfully!")
                
            }
        }
        
        // MARK: - Private methods
        
        private func configureTextFields() {
            usernameTextField.placeholder = "Email"
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
        
        private func configureButtons() {
            loginButton.setTitle("Login", for: .normal)
            loginButton.backgroundColor = .systemBlue
            loginButton.layer.cornerRadius = 10
            resetPasswordButton.setTitle("Reset Password", for: .normal)
            resetPasswordButton.setTitleColor(.systemBlue, for: .normal)
            resetPasswordButton.layer.cornerRadius = 10
            
            
            
        }
}

