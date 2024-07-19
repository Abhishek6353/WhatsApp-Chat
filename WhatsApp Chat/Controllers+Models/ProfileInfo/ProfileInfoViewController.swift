//
//  ProfileInfoViewController.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 12/07/24.
//

import UIKit

class ProfileInfoViewController: UIViewController {
    
    //MARK: - Variables
    let viewModel: ProfileInfoViewModel
    
    
    //MARK: - Outlets
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var btnAddProfile: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    
    //MARK: - init
    init(viewModel: ProfileInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: ProfileInfoViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        viewModel.responseHandler = { result in
            switch result {
            case .success(let message):
                self.view.makeToast(message, position: .top)
                self.viewModel.router.redirectToHome()
                
            case .failure(let error):
                self.view.makeToast(error.localizedDescription, position: .top)
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        btnNext.layer.cornerRadius = 3
        btnAddProfile.layer.cornerRadius = btnAddProfile.frame.height / 2
        profileImageVIew.layer.cornerRadius = profileImageVIew.frame.height / 2
    }
    
    
    //MARK: - Button Actions
    @IBAction func addProfileImageButtonAction(_ sender: UIButton) {
        showImagePickerOptions()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if let name = nameTextField.text, name.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let about = aboutTextField.text ?? "Hey there! I am using Whatsapp"
            viewModel.updateProfile(name: name, about: about)
        }
    }
    
    
    //MARK: - Functions
    private func configure() {
        
    }
    
    private func showImagePickerOptions() {
        let alertVC = UIAlertController(title: Constants.pickPhotoStr, message: Constants.chooseFromStr, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: Constants.cameraStr, style: .default) { [weak self] action in
            guard let self else { return }
            
            viewModel.checkCameraPermission { granted in
                if granted {
                    self.openCamera()
                }
            }
        }
        
        let libraryAction = UIAlertAction(title: Constants.libraryStr, style: .default) { [weak self] action in
            guard let self else { return }
            
            viewModel.checkPhotoLibraryPermission { granted in
                if granted {
                    self.openImagePicker()
                }
            }
        }

        let cancelAction = UIAlertAction(title: Constants.cancelStr, style: .cancel)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true)
    }
    
    private func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true)
    }
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    
}



extension ProfileInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            viewModel.selectedProfileImage = selectedImage
            profileImageVIew.image = selectedImage
            btnAddProfile.setImage(nil, for: .normal)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
