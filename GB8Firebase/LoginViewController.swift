//
//  LoginViewController.swift
//  GB8Firebase
//
//  Created by Александр Арсенюк on 10.12.2021.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "login", sender: nil)
                self.loginTextField.text = nil
                self.passwordTextField.text = nil
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction func sigInButtonPressed(_ sender: Any) {
        guard let email = loginTextField.text,
              let password = passwordTextField.text,
              email.count > 0,
              password.count > 0 else {
                  self.showAlert(title: "Error", message: "Invalid data")
                  return
              }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] data, error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter login"
        }
        
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Enter password"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passwordTextField = alert.textFields?[1],
                  let email = emailField.text,
                  let password = passwordTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
