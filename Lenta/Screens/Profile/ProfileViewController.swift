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
    
    @IBOutlet weak var avatarImageView: WebImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var dateRegisterLabel: UILabel!
    
    
    //MARK: - Variables
    
    var presenter: ProfileViewOutput!
    var saveButton: UIBarButtonItem!
    lazy var imagePicker = ImagePicker(view: self, delegate: self)
    
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
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
//        avatarImageView.clipsToBounds = true
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heidKboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func saveButtonPress() {
        nameTextField.resignFirstResponder()
        presenter.saveButtonPress(name: nameTextField.text!, image: avatarImageView.image)
    }
    
    @objc private func heidKboard() {
        nameTextField.resignFirstResponder()
    }
    
    @objc private func chooseImage() {
        imagePicker.chooseImage()
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
            avatarImageView.isUserInteractionEnabled = true
            nameTextField.text = currentUserModel.name
            postsCountLabel.text = currentUserModel.postsCount
            dateRegisterLabel.text = currentUserModel.dateRegister
            if currentUserModel.avatar != "" {
                avatarImageView.load(by: currentUserModel.avatar) { }
            } else {
                avatarImageView.image = UIImage(named: "avatar")
                avatarImageView.tintColor = #colorLiteral(red: 0, green: 0.5138283968, blue: 1, alpha: 1)
            }
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        } else {
            nameTextField.isEnabled = false
            avatarImageView.isUserInteractionEnabled = false
            avatarImageView.image = UIImage(named: "avatar")
            avatarImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            nameTextField.text = ""
            postsCountLabel.text = "--"
            dateRegisterLabel.text = "--.--.----"
            logInOutBarButtonItem = UIBarButtonItem(image: UIImage(named: "login"), style: .plain, target: self, action: #selector(logInOutButtonPress))
        }
        
        navigationItem.rightBarButtonItem = logInOutBarButtonItem
    }
}

//MARK: - ImagePickerDelegate

extension ProfileViewController: ImagePickerDelegate {
    
    func selectImage(_ image: UIImage) {
        self.avatarImageView.image = image
        presenter.didSelectNewAvatar()
    }
}
