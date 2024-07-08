//
//  HomeViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


protocol HomeProtocol {
    var router: RouterProtocol { get }
    var friendsList: [FriendsDataModel] { get }
    
    func signOut(completion: @escaping (Result<String, Error>) -> Void)
    func fetchFriendListner(completion: @escaping () -> Void)
}

class HomeViewModel: HomeProtocol {
    
    var router: RouterProtocol
    var friendsList: [FriendsDataModel] = []
    
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
    
    func fetchFriendListner(completion: @escaping () -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        chatChannelReference.whereField(Keys.memberIds, arrayContains: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.friendsList = documents.compactMap { document in
                return FriendsDataModel(document: document.data())
            }
            
            self.getFiiendsProfileData {
                completion()
            }
        }
    }
    
    func getFiiendsProfileData(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        for index in 0..<friendsList.count {
            userReference.document(friendsList[index].receiverId).getDocument { document, error in
                if let error = error {
                    print("Error fetching friend's profile: \(error.localizedDescription)")
                    return
                }
                
                guard let document else {
                    return
                }
                
                
                guard let name = document["name"] as? String,
                      let photoURLStr = document["profile_photo_url"] as? String else {
                    return
                }
                
                self.friendsList[index].name = name
                self.friendsList[index].profilePhotoUrl = photoURLStr
                
                if index == self.friendsList.count - 1 {
                    completion()
                }
            }
        }
       
    }
}
