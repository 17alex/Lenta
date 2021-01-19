//
//  RegisterViewController.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterViewInput: class {
    func userNotRegister()
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logintextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var presenter: RegisterViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController init")
        registerButton.isEnabled = false
        nameTextField.becomeFirstResponder()
    }
    
    deinit {
        print("RegisterViewController deinit")
    }

    @IBAction func signInButtonPress(_ sender: UIButton) {
        presenter.signInButtonPress()
    }
    
    @IBAction func registerButtonpress(_ sender: UIButton) {
        
    }
}

extension RegisterViewController: RegisterViewInput {
 
    func userNotRegister() {
        let alertController = UIAlertController(title: "Error", message: "not register", preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}
