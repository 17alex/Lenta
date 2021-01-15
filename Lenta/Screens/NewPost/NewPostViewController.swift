//
//  NewPostViewController.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewInput: class {
    
}

class NewPostViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    var presenter: NewPostViewOutput!
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "new Post"
//        descriptionTextView.text = "Hello, ..."
        let barButtonitem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addImage))
        navigationItem.rightBarButtonItem = barButtonitem
    }
    
    @objc
    private func addImage() {
        let actionSheet = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
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
    
    @IBAction func saveButtonPress(_ sender: UIButton) {
        let description = descriptionTextView.text ?? ""
        presenter.pressSendWith(description: description, image: image)
    }
}

extension NewPostViewController: NewPostViewInput {
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.image = image
        dismiss(animated: true, completion: nil)
    }
}
