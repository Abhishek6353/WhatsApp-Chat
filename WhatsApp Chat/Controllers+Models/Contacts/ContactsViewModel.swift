//
//  ContactsViewModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 07/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ContactsProtocol {
    var router: RouterProtocol { get }
    var contacts: [UserModel] { get }
    
    
    func fetchAllUsers(completion: @escaping (String?) -> Void)
}

class ContactsViewModel: ContactsProtocol {
    
    var router: RouterProtocol
    var contacts: [UserModel] = []
    
    let db = Firestore.firestore()
    
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    
    func fetchAllUsers(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
        let usersCollection = db.collection("users").whereField("user_id", isNotEqualTo: uid)
        
        usersCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion("No documents found.")
                return
            }
            
            // Map documents to ContactModel objects
            var fetchedContacts: [UserModel] = []
            
            for document in documents {
                do {
                    // Attempt to decode document into ContactModel
                    let contact = try document.data(as: UserModel.self)
                    fetchedContacts.append(contact)
                    
                } catch {
                    completion("Error decoding user data for document \(document.documentID): \(error.localizedDescription)")
                }
            }
            self.contacts = fetchedContacts
            completion(nil)
        }
    }
    
}
