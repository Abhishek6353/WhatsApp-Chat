//
//  LoginViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth

protocol LoginProtocol {
    var router: RouterProtocol { get }
    var kdsdk: String { get }
    
    func verifyNumber(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void)
}

class LoginViewModel: LoginProtocol {
    
    var router: RouterProtocol
    var kdsdk: String = ""
    
    init(router: RouterProtocol) {
        self.router = router
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
}
