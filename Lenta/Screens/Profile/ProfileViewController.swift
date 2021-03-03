//
//  ProfileViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewInput: class {
    func userLoginned(_ currentUserModel: CurrentUserModel?)
    func didChangeProfile(_ change: Bool)
    func didUpdateProfile(message: String)
}

final class ProfileViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var dateRegisterLabel: UILabel!
    
    
    //MARK: - Variables
    
    var presenter: ProfileViewOutput!
    var saveButton: UIBarButtonItem!
    
    //MARK: - LiveCycles
    
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
    
    //MARK: - IBAction
    
    @IBAction func avatarButtonPress() {
        chooseImage()
    }
    
    @objc private func logInOutButtonPress() {
        presenter.logInOutButtonPress()
    }
    
    @IBAction func nameTextChange() {
        presenter.change(name: nameTextField.text!)
    }
    
    //MARK: - Metods
    
    private func setup() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPress))
        navigationItem.leftBarButtonItem = saveButton
        saveButton.isEnabled = false
        avatarButton.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heidKboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func saveButtonPress() {
        nameTextField.resignFirstResponder()
        presenter.saveButtonPress(name: nameTextField.text!, image: avatarButton.imageView?.image)
    }
    
    @objc private func heidKboard() {
        nameTextField.resignFirstResponder()
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

//MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {
    
    func didUpdateProfile(message: String) {
        let alertController = UIAlertController(title: "Profile", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func didChangeProfile(_ change: Bool) {
        saveButton.isEnabled = change
    }
    
    func userLoginned(_ currentUserModel: CurrentUserModel?) {
        let logInOutBarButtonItem: UIBarButtonItem
        if let currentUserModel = currentUserModel {
            nameTextField.isEnabled = true
            avatarButton.isEnabled = true
            nameTextField.text = currentUserModel.name
            postsCountLabel.text = currentUserModel.postsCount
            dateRegisterLabel.text = currentUserModel.dateRegister
            if currentUserModel.avatar != "",
               let url = URL(string: currentUserModel.avatar),
               let data = try? Data(contentsOf: url), //TODO: todo
               let avImage = UIImage(data: data) {
                avatarButton.setImage(avImage, for: .normal)
            }
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        } else {
            nameTextField.isEnabled = false
            avatarButton.isEnabled = false
            nameTextField.text = ""
            postsCountLabel.text = "--"
            dateRegisterLabel.text = "--.--.----"
            let avImage = UIImage(named: "avatar")
            avatarButton.setImage(avImage, for: .normal)
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "login"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        }
        
        navigationItem.rightBarButtonItem = logInOutBarButtonItem
    }
}
