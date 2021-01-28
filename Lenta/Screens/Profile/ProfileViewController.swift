//
//  ProfileViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewInput: class {
    func userLoginned(_ currentUser: CurrentUser?)
    func didChangeProfile(_ change: Bool)
    func didUpdateProfile(_ success: Bool)
}

final class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: ProfileViewOutput!
    
    deinit {
        print("ProfileViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ProfileViewController init")
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.start()
    }
    
    @IBAction func avatarButtonPress() {
        chooseImage()
    }
    
    @objc private func logInOutButtonPress() {
        presenter.logInOutButtonPress()
    }
    
    @IBAction func nameTextChange() {
        presenter.change(name: nameTextField.text!)
    }
    
    @IBAction func saveButtonPress() {
        presenter.saveButtonPress(name: nameTextField.text!, image: avatarButton.imageView?.image)
    }
    
    private func setup() {
        saveButton.isEnabled = false
        avatarButton.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.clipsToBounds = true
    }
    
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
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.avatarButton.setImage(image, for: .normal)
        presenter.didSelectNewAvatar()
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileViewInput {
    
    func didUpdateProfile(_ success: Bool) {
        var message = ""
        if success {
            message = "update successfull"
        } else {
            message = "error update"
        }
        let alertController = UIAlertController(title: "Profile", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func didChangeProfile(_ change: Bool) {
        saveButton.isEnabled = change
    }
    
    func userLoginned(_ currentUser: CurrentUser?) {
        let logInOutBarButtonItem: UIBarButtonItem
        if let currentUser = currentUser {
            nameTextField.isEnabled = true
            avatarButton.isEnabled = true
            nameTextField.text = currentUser.name
            if let url = URL(string: "https://monsterok.ru/lenta/avatars/\(currentUser.avatarName)"),
            let data = try? Data(contentsOf: url),
            let avImage = UIImage(data: data) {
                avatarButton.setImage(avImage, for: .normal)
            }
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        } else {
            nameTextField.isEnabled = false
            avatarButton.isEnabled = false
            nameTextField.text = ""
            let avImage = UIImage(named: "defaultAvatar")
            avatarButton.setImage(avImage, for: .normal)
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "login"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        }
        
        navigationItem.rightBarButtonItem = logInOutBarButtonItem
    }
    
    
    
}
