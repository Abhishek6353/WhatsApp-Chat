//
//  ContactsViewModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 07/07/24.
//

import Foundation
import FirebaseFirestore

protocol ContactsProtocol {
    var router: RouterProtocol { get }
    var contacts: [ContactModel] { get }
    
    
    func fetchAllUsers(completion: @escaping (String?) -> Void)
}

class ContactsViewModel: ContactsProtocol {
    
    var router: RouterProtocol
    var contacts: [ContactModel] = []
    
    let db = Firestore.firestore()
    
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    
    func fetchAllUsers(completion: @escaping (String?) -> Void) {

        let usersCollection = db.collection("users")
        
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
            var fetchedContacts: [ContactModel] = []
            
            for document in documents {
                do {
                    // Attempt to decode document into ContactModel
                    let contact = try document.data(as: ContactModel.self)
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
