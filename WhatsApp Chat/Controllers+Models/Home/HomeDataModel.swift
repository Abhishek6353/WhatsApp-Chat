//
//  HomeDataModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 09/07/24.
//

import Foundation

struct FriendsDataModel: Codable {
    let channelId: String
    let createdAt: Int
    let isDeleted: Bool
    let memberIds: [String]
    let message: String
    let modifiedAt: Int
    let receiverId: String
    let senderId: String
    
    var name: String?
    var profilePhotoUrl: String?
    
    init?(document: [String: Any]) {
        guard let channelId = document["channelId"] as? String,
              let createdAt = document["createdAt"] as? Int,
              let isDeleted = document["isDeleted"] as? Bool,
              let memberIds = document["memberIds"] as? [String],
              let message = document["message"] as? String,
              let modifiedAt = document["modifiedAt"] as? Int,
              let receiverId = document["receiverId"] as? String,
              let senderId = document["senderId"] as? String else {
            return nil
        }
        
        self.channelId = channelId
        self.createdAt = createdAt
        self.isDeleted = isDeleted
        self.memberIds = memberIds
        self.message = message
        self.modifiedAt = modifiedAt
        self.receiverId = receiverId
        self.senderId = senderId
    }
}
