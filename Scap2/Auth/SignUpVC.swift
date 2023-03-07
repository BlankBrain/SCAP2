//
//  SignUpVC.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignUpVC: BaseVC {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    private var isPasswordHidden = true

    @IBOutlet weak var passwordVisibilityButton: UIButton!
    @IBOutlet weak var passwordVisibilityButton2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    @IBAction func SignupClicked(_ sender: Any) {
        
        guard let email = usernameTextField.text, let password = passwordTextField.text, let confirmPassword = passwordTextField2.text else {
             print("Invalid email or password")
             Utility.showPopup(with: "Invalid email or password", on: self)
             return
         }

         // Check if password and confirm password match
         if password != confirmPassword {
             print("Password and Confirm Password don't match")
             Utility.showPopup(with: "Password and Confirm Password don't match", on: self)
             return
         }

         Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
             guard self != nil else { return }
             if let error = error {
                 print("Error creating user: \(error.localizedDescription)")
                 return
             }

             // User created successfully, update UI or perform other actions
             print("User created successfully!")
             if let navController = self?.navigationController {
                 navController.popToRootViewController(animated: true)
             }
         }
    }
    
    @IBAction func passwordVisibilityButtonTapped(_ sender: Any) {
        isPasswordHidden.toggle()
        let image = isPasswordHidden ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        passwordVisibilityButton.setImage(image, for: .normal)
        passwordTextField.isSecureTextEntry = isPasswordHidden
    }
    @IBAction func passwordVisibilityButton2Tapped(_ sender: Any) {
        isPasswordHidden.toggle()
        let image = isPasswordHidden ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        passwordVisibilityButton.setImage(image, for: .normal)
        passwordTextField.isSecureTextEntry = isPasswordHidden
    }
    private func configureTextFields() {
        usernameTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField2.placeholder = "Confirm Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField2.isSecureTextEntry = true

    }

}
