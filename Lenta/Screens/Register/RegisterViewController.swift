//
//  RegisterViewController.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterViewInput: class {
    func userNotRegister(message: String)
}

class RegisterViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logInButton: UIButton!
    
    //MARK: - Variables
    
    var presenter: RegisterViewOutput!
    private var avatarImage: UIImage?
    lazy var imagePicker = ImagePicker(view: self, delegate: self)
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController init")
        setup()
    }
    
    deinit {
        print("RegisterViewController deinit")
    }
    
    //MARK: - Metods
    
    private func setup() {
        registerButton.layer.cornerRadius = registerButton.bounds.height / 2
        avatarButton.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.clipsToBounds = true
        nameTextField.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
        registerButton.isEnabled = false
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: - IBAction
    
    @IBAction func addAvatarButtonPress(_ sender: UIButton) {
        imagePicker.chooseImage()
    }
    
    @IBAction func logInButtonPress(_ sender: UIButton) {
        presenter.signInButtonPress()
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        if nameTextField.text != "",
           loginTextField.text != "",
           passwordTextField.text != "" {
            self.registerButton.isEnabled = true
            self.registerButton.backgroundColor = #colorLiteral(red: 0, green: 0.4773686528, blue: 0.8912271857, alpha: 1)
        } else {
            self.registerButton.isEnabled = false
            self.registerButton.backgroundColor = .systemGray5
        }
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        registerButton.isHidden = true
        activityIndicator.startAnimating()
        presenter.registerButtonPress(name: nameTextField.text!, login: loginTextField.text!, password: passwordTextField.text!, avatarImage: avatarImage)
    }
}

//MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {
 
    func userNotRegister(message: String) {
        activityIndicator.stopAnimating()
        registerButton.isHidden = false
        //TODO: - alert to label
        let alertController = UIAlertController(title: "Error register", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: loginTextField.becomeFirstResponder()
        case loginTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }
        
        return true
    }
}

//MARK: - ImagePickerDelegate

extension RegisterViewController: ImagePickerDelegate {
    
    func selectImage(_ image: UIImage) {
        avatarImage = image
        avatarButton.setImage(image, for: .normal)
    }
}
