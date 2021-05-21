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

final class RegisterViewController: UIViewController {
    
    //MARK: - Propertis
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "avatar"), for: .normal)
        button.addTarget(self, action: #selector(addAvatarButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(logInButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .sentences
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var presenter: RegisterViewOutput!
    private var avatarImage: UIImage?
    lazy var imagePicker = ImagePicker(view: self, delegate: self)
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController init")
        
        view.backgroundColor = .white
        
        setupUI()
        
        registerButton.isEnabled = false
        nameTextField.becomeFirstResponder()
    }
    
    deinit {
        print("RegisterViewController deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerButton.layer.cornerRadius = registerButton.bounds.height / 2
        avatarButton.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.clipsToBounds = true
    }
    
    //MARK: - Metods
        
    private func setupUI() {
        view.addSubview(avatarButton)
        view.addSubview(logInButton)
        view.addSubview(registerButton)
        view.addSubview(nameTextField)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(textRegisterLabel)
        view.addSubview(textNameLabel)
        view.addSubview(textLoginLabel)
        view.addSubview(textPasswordLabel)
        view.addSubview(activityIndicator)
        
        textPasswordLabel.setContentHuggingPriority(.init(500), for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textPasswordLabel.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor),
            textPasswordLabel.firstBaselineAnchor.constraint(equalTo: passwordTextField.firstBaselineAnchor),
            textPasswordLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -8),
            
            passwordTextField.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -16),
            
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -16),
            loginTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            nameTextField.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -16),
            nameTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            textLoginLabel.trailingAnchor.constraint(equalTo: textPasswordLabel.trailingAnchor),
            textLoginLabel.firstBaselineAnchor.constraint(equalTo: loginTextField.firstBaselineAnchor),
            
            textNameLabel.trailingAnchor.constraint(equalTo: textPasswordLabel.trailingAnchor),
            textNameLabel.firstBaselineAnchor.constraint(equalTo: nameTextField.firstBaselineAnchor),
            
            textRegisterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textRegisterLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -32),
            
            avatarButton.heightAnchor.constraint(equalToConstant: 60),
            avatarButton.widthAnchor.constraint(equalToConstant: 60),
            avatarButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -16),
            avatarButton.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: -16),
            
            logInButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -32),
            logInButton.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor)
        ])
    }
    
    //MARK: - IBAction
    
    @objc private func addAvatarButtonPress() {
        imagePicker.chooseImage()
    }
    
    @objc private func logInButtonPress() {
        presenter.signInButtonPress()
    }
    
    @objc private func didChangeText() {
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
    
    @objc private func registerButtonPress() {
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
