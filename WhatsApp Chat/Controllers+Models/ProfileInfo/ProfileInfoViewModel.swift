//
//  ProfileInfoViewModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 12/07/24.
//

import Foundation
import Photos
import FirebaseStorage
import FirebaseAuth

protocol ProfileInfoProtocol {
    
    var router: RouterProtocol { get }
    var selectedProfileImage: UIImage? { get set }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void)
    func checkCameraPermission(completion: @escaping (Bool) -> Void)
    func uploadImageToDatabase(completion: @escaping (URL) -> Void)
    
    var responseHandler: ((Result<String, Error>) -> ())? { get }
}

class ProfileInfoViewModel: ProfileInfoProtocol {
    
    let router: RouterProtocol
    let storageRef = Storage.storage().reference()
    
    var selectedProfileImage: UIImage?

    var responseHandler: ((Result<String, Error>) -> ())?
    
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func uploadImageToDatabase(completion: @escaping (URL) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = storageRef.child("Images/Profile/profile_\(userID)_\(Utility.getCurrentTime()).jpeg")
        
        if let imageData = (selectedProfileImage?.jpegData(compressionQuality: 0.8)) {
            
            ref.putData(imageData, metadata: nil) {  metaData, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    Utility.hideLoadingView()
                    return
                }
                
                ref.downloadURL { url, error in
                    if let error = error  {
                        print("Error URL of Uploaded image: \(error.localizedDescription)")
                        Utility.hideLoadingView()
                        return
                    }
                    
                    guard let url else {
                        print("URL not found")
                        Utility.hideLoadingView()
                        return
                    }
                    
                    completion(url)
                }
                
            }
        }
        
    }
    
    func updateProfile(name: String, about: String) {
        if selectedProfileImage != nil {
            Utility.showLoadingView()
            
            uploadImageToDatabase { [weak self] imageURL in
                guard let self else { return }
                self.updatePrfileDataToFirestore(name: name, about: about, imageURL: "\(imageURL)")
            }
        } else {
            self.updatePrfileDataToFirestore(name: name, about: about, imageURL: "https://firebasestorage.googleapis.com/v0/b/whatsapp-chat-d83e5.appspot.com/o/Images%2FProfile%2Fperson.png?alt=media&token=d2612f68-bbc2-4c70-be72-3ed7919501d1")
        }
    }
    
    func updatePrfileDataToFirestore(name: String, about: String, imageURL: String = "") {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let dict: [String: Any] = [
            "name": name,
            "about": about,
            "profile_photo_url": imageURL
        ]
        
        userReference.document(userID).updateData(dict) { [weak self ] error in
            guard let self else { return }
            Utility.hideLoadingView()
            
            if let error = error {
                self.responseHandler?(.failure(NSError(domain: "Error updating profile data: \(error.localizedDescription)", code: -1)))
                print("Error updating profile data: \(error.localizedDescription)")
                return
            }
            
            self.responseHandler?(.success("Profile uploadeed sucessfully"))
        }
    }
    
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for:.video) {
        case.authorized:
            completion(true)
        case.notDetermined:
            AVCaptureDevice.requestAccess(for:.video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case.authorized:
            completion(true)
        case.notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        default:
            completion(false)
        }
    }

}
