//
//  Constants.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 08/07/24.
//

import Foundation
import FirebaseFirestore


let db = Firestore.firestore()
let userReference = db.collection(Keys.users)
let chatChannelReference = db.collection(Keys.channels)
let chatMemberData = db.collectionGroup(Keys.subNodeChatMemberData)
