//
//  LoginViewController.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginViewInput: class {
    func userNotLoginned()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var presenter: LoginViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController init")
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
        
    @IBAction func signInPress(_ sender: UIButton) {
        print("press Sign In")
        presenter.logIn(login: loginTextField.text!, password: passwordTextField.text!)
    }
}

extension LoginViewController: LoginViewInput {
    
    func userNotLoginned() {
        let alertController = UIAlertController(title: "Error", message: "not pair login and password", preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}
