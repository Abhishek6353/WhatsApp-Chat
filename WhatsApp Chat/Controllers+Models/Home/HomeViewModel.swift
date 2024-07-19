//
//  HomeViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


import Foundation
import FirebaseAuth


protocol HomeProtocol {
    var router: RouterProtocol { get }
    var friendsList: [FriendsDataModel] { get }
    
    func signOut(completion: @escaping (Result<String, Error>) -> Void)
    func fetchFriendListener(completion: @escaping () -> Void)
}

class HomeViewModel: HomeProtocol {
    
    var router: RouterProtocol
    var friendsList: [FriendsDataModel] = []
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    
    //MARK: - Functions
    func signOut(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            Utility.removeValueFor(forKey: PreferenceKeys.isLogin.rawValue)
            completion(.success("You have been successfully signed out."))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
    
    func fetchFriendListener(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        chatChannelReference.whereField(Keys.memberIds, arrayContains: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.friendsList.removeAll()
            
            for document in documents {
                do {
                    // Attempt to decode document into ContactModel
                    let contact = try document.data(as: FriendsDataModel.self)
                    self.friendsList.append(contact)
                    
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
            
            self.getFriendsProfileData {
                completion()
            }
        }
    }
    
    
    func getFriendsProfileData(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        let friendsCount = friendsList.count
        
        for index in 0..<friendsCount {
            group.enter()
            
            userReference.document(friendsList[index].receiverId).getDocument { document, error in
                defer { group.leave() }
                
                if let error = error {
                    print("Error fetching friend's profile: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document else {
                    print("Document is nil")
                    return
                }
                
                do {
                    // Attempt to decode document into ContactModel
                    let contact = try document.data(as: UserModel.self)
                    self.friendsList[index].personalDetail = contact
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        }
        
        group.notify(queue: .main) {
            self.friendsList = self.friendsList.sorted(by: { $0.modifiedAt > $1.modifiedAt})
            completion()
        }
    }
    
}
