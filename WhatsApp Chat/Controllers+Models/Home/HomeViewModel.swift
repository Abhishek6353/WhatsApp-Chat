//
//  HomeViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth


protocol HomeProtocol {
    var router: RouterProtocol { get }
    
    func signOut(completion: @escaping (Result<String, Error>) -> Void)
}

class HomeViewModel: HomeProtocol {
    
    var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func signOut(completion: @escaping (Result<String, Error>) -> Void) {
        do {
          try Auth.auth().signOut()
            Utility.removeValueFor(forKey: PreferenceKeys.isLogin.rawValue)
            completion(.success("You have been successfully signed out."))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
}
