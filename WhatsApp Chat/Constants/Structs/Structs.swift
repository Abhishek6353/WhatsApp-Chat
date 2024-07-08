//
//  Structs.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation

struct Constants {
    static let termsAndPrivacyStr = "Read our Privacy Policy. Tap “Agree and continue” to accept the Teams of Service."
    static let privacyPolicyStr = "Privacy Policy."
    static let termsOfServiceStr = "Teams of Service."
    static let users = "users"
    static let channels = "channels"
    static let subNodeChatMemberData = "ChatMemberData"
    static let subNodeGroupMessage = "GroupMessages"
}

struct URLs {
    static let termsURLStr = "https://www.apple.com/"
    static let privacyURLStr = "https://www.google.com"
}

struct ToastMessages {
    static let enterNumber = "Please enter your phone number."
    static let invalidNumber = "Ensure you enter a valid phone number, for example, +91 1234567890."
}

struct Keys {
    static let users = "users"
    static let channels = "channels"
    static let GroupMessages = "GroupMessages"
    
    static let channelId = "channelId"
    static let createdAt = "createdAt"
    static let isDeleted = "isDeleted"
    static let memberIds = "memberIds"
    static let message = "message"
    static let messageTime = "messageTime"
    static let modifiedAt = "modifiedAt"
    static let receiverId = "receiverId"
    static let senderId = "senderId"
        
    static let chatID = "chatID"
    static let messageType = "messageType"
    static let serverTime = "serverTime"
}
