//
//  OTPViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth

protocol OTPProtocol {
    var router: RouterProtocol { get }
    var phoneNumber: String { get }
    var coutryPhoneCode: String { get }
    
    func signIn(otp: String, completion: @escaping (Result<String, Error>) -> Void)
}

class OTPViewModel: OTPProtocol {
    
    var router: RouterProtocol
    var phoneNumber: String
    var coutryPhoneCode: String
    
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
            
            completion(.success("Login Successfull!"))
        }
    }
}
