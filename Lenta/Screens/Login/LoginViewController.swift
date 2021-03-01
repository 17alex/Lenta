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

    //MARK: - IBOutlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    //MARK: - Variables
    
    var presenter: LoginViewOutput!
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController init")
        setup()
    }
    
    deinit {
        print("LoginViewController deinit")
    }
    
    //MARK: - Metods
    
    private func setup() {
        logInButton.layer.cornerRadius = logInButton.bounds.height / 2
        loginTextField.delegate = self
        passwordTextField.delegate = self
        logInButton.isEnabled = false
        loginTextField.becomeFirstResponder()
    }

    //MARK: - IBAction
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        presenter.registerButtonPress()
    }
    
    @IBAction func valueChangeTextField(_ sender: UITextField) {
        if loginTextField.text != "" && passwordTextField.text != "" {
            self.logInButton.isEnabled = true
            self.logInButton.backgroundColor = #colorLiteral(red: 0, green: 0.4773686528, blue: 0.8912271857, alpha: 1)
        } else {
            self.logInButton.isEnabled = false
            self.logInButton.backgroundColor = .systemGray5
        }
    }
        
    @IBAction func logInPress() {
        print("press LogIn")
        presenter.logIn(login: loginTextField.text!, password: passwordTextField.text!)
    }
}

//MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    
    func userNotLoginned(message: String) {
        let alertController = UIAlertController(title: "Error loginned", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

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
