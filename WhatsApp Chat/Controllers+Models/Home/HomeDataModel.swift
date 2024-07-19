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
    let modifiedAt: Double
    let receiverId: String
    let senderId: String
    
    var personalDetail: UserModel?
}
