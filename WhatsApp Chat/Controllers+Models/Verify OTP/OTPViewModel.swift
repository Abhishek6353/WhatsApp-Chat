//
//  OTPViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol OTPProtocol {
    var router: RouterProtocol { get }
    var phoneNumber: String { get }
    var coutryPhoneCode: String { get }
    
    func signIn(otp: String, completion: @escaping (Result<String, Error>) -> Void)
    func verifyNumber(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void)
}

class OTPViewModel: OTPProtocol {
    
    var router: RouterProtocol
    var phoneNumber: String
    var coutryPhoneCode: String
    
    let db = Firestore.firestore()
    
    init(router: RouterProtocol, phoneNumber: String, coutryPhoneCode: String) {
        self.router = router
        self.phoneNumber = phoneNumber
        self.coutryPhoneCode = coutryPhoneCode
    }
    
    
    func signIn(otp: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let verificationID = Utility.valueFor(forKey: PreferenceKeys.verificationID.rawValue) as? String else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        
        Auth.auth().signIn(with: credential) { authData, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.updateUseretails { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let message):
                    completion(.success(message))
                }
            }
        }
    }
    
    func verifyNumber(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.async {
            Utility.showLoadingView()
        }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            Utility.hideLoadingView()
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let verificationID = verificationID else {
                completion(.failure(NSError(domain: "Something went wrong", code: -1)))
                return
            }
            
            Utility.setValuefor(verificationID, forKey: PreferenceKeys.verificationID.rawValue)
            completion(.success(verificationID))
        }
    }
    
    func updateUseretails(completion: @escaping (Result<String, Error>) -> Void) {
        guard let authID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userData: [String: Any] = [
            "user_id": authID,
            "name": "Aarya",
            "country_code": coutryPhoneCode,
            "phone_number": phoneNumber,
            "profile_photo_url": "https://firebasestorage.googleapis.com/v0/b/whatsapp-chat-d83e5.appspot.com/o/ProfileImages%2FDefaultProfile.png?alt=media&token=3375f757-318e-4384-9bd0-66f7fd790172"
        ]
        
        let userRef = db.collection("users").document(authID)
        
        userRef.setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            Utility.setValuefor(true, forKey: PreferenceKeys.isLogin.rawValue)
            completion(.success("Login Successful!"))
        }
    }
}
