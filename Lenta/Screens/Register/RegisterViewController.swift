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
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Variables
    
    var presenter: RegisterViewOutput!
    private var avatarImage: UIImage?
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController init")
        nameTextField.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
        registerButton.isEnabled = false
        nameTextField.becomeFirstResponder()
    }
    
    deinit {
        print("RegisterViewController deinit")
    }
    
    //MARK: - Metods
    
    private func chooseImage() {
        let actionSheet = UIAlertController(title: "Choose", message: "foto source", preferredStyle: .actionSheet)
        let fotoAction = UIAlertAction(title: "Foto", style: .default) { (_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.chooseImagePicker(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(fotoAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    //MARK: - IBAction
    
    @IBAction func addAvatarButtonPress(_ sender: UIButton) {
        chooseImage()
    }
    
    @IBAction func signInButtonPress(_ sender: UIButton) {
        presenter.signInButtonPress()
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        if nameTextField.text != "",
           loginTextField.text != "",
           passwordTextField.text != "" {
            self.registerButton.isEnabled = true
        } else {
            self.registerButton.isEnabled = false
        }
    }
    
    @IBAction func registerButtonpress(_ sender: UIButton) {
        print("press Register")
        presenter.registerButtonPress(name: nameTextField.text!, login: loginTextField.text!, password: passwordTextField.text!, avatarImage: avatarImage)
    }
}

//MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {
 
    func userNotRegister(message: String) {
        let alertController = UIAlertController(title: "Error register", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[.editedImage] as? UIImage else { return }
        self.avatarImage = image
        self.avatarButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
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
