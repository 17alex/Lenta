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

final class LoginViewController: UIViewController {
    
    //MARK: - Propertis
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChangeTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChangeTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textLoginTitlelabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLoginlabel: UILabel = {
        let label = UILabel()
        label.text = "Login:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textPasswordlabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
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
    
    var presenter: LoginViewOutput!
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController init")
        
        view.backgroundColor = .white
        
        setupUI()
        
        loginButton.isEnabled = false
        loginTextField.becomeFirstResponder()
    }
    
    deinit {
        print("LoginViewController deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
    }
    
    //MARK: - Metods
    
    private func setupUI() {
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(textLoginTitlelabel)
        view.addSubview(textLoginlabel)
        view.addSubview(textPasswordlabel)
        view.addSubview(activityIndicator)
        
        textPasswordlabel.setContentHuggingPriority(.init(500), for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textPasswordlabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            textPasswordlabel.firstBaselineAnchor.constraint(equalTo: passwordTextField.firstBaselineAnchor),
            textPasswordlabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -8),
            
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16),
            
            loginTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -16),
            
            textLoginlabel.leadingAnchor.constraint(equalTo: textPasswordlabel.leadingAnchor),
            textLoginlabel.trailingAnchor.constraint(equalTo: textPasswordlabel.trailingAnchor),
            textLoginlabel.firstBaselineAnchor.constraint(equalTo: loginTextField.firstBaselineAnchor),
            
            textLoginTitlelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLoginTitlelabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -34),
            
            registerButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            registerButton.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -36),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }

    //MARK: - IBAction
    
    @objc private func registerButtonPress() {
        presenter.registerButtonPress()
    }
    
    @objc private func valueChangeTextField() {
        if loginTextField.text != "" && passwordTextField.text != "" {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = #colorLiteral(red: 0, green: 0.4773686528, blue: 0.8912271857, alpha: 1)
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = .systemGray5
        }
    }
        
    @objc private func loginButtonPress() {
        loginButton.isHidden = true
        activityIndicator.startAnimating()
        presenter.logIn(login: loginTextField.text!, password: passwordTextField.text!)
    }
}

//MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    
    func userNotLoginned(message: String) {
        activityIndicator.stopAnimating()
        loginButton.isHidden = false
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
