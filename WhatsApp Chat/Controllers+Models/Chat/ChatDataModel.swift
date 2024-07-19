//
//  ChatDataModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 18/07/24.
//

import Foundation


struct ChatMessage: Codable {
    var chatID: String
    var isDeleted: Bool
    var message: String
    var messageTime: TimeInterval
    var messageType: String
    var senderId: String
    var serverTime: Date
}

struct Chats: Codable {
    var date: TimeInterval
    var chatMessages: [ChatMessage]
    
}

struct GroupMessage: Codable {
    var channelId: String
    var createdAt: Int
    var isDeleted: Bool
    var memberIds: [String]
    var message: String
    var modifiedAt: Int
    var receiverId: String
    var senderId: String
    var chats: [Chats]? {
        didSet {
            self.chats = self.chats?.sorted(by: { $0.date < $1.date })
        }
    }
    
}


struct ChatMemberData: Codable {
    var isOnline: Bool
    var memberId: String
    var muteTill: Int
    var roomId: String
    var unreadCount: Int
}
