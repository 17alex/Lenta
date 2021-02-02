//
//  LoginViewController.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginViewInput: class {
    func userNotLoginned(message: String)
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var presenter: LoginViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController init")
        loginTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.isEnabled = false
        loginTextField.becomeFirstResponder()
    }
    
    deinit {
        print("LoginViewController deinit")
    }

    @IBAction func registerButtonPress(_ sender: UIButton) {
        presenter.registerButtonPress()
    }
    
    @IBAction func valueChangeTextField(_ sender: UITextField) {
        if loginTextField.text != "" && passwordTextField.text != "" {
            self.signInButton.isEnabled = true
        } else {
            self.signInButton.isEnabled = false
        }
    }
        
    @IBAction func logInPress() {
        print("press LogIn")
        presenter.logIn(login: loginTextField.text!, password: passwordTextField.text!)
    }
}

extension LoginViewController: LoginViewInput {
    
    func userNotLoginned(message: String) {
        let alertController = UIAlertController(title: "Error loginned", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }
        
        return true
    }
}
