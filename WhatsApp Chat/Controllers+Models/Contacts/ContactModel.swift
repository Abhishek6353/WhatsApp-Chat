//
//  UserModel.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 08/07/24.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let about: String
    let userID: String
    let profilePhotoUrl: String
    let countryCode: String
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case about
        case userID = "user_id"
        case profilePhotoUrl = "profile_photo_url"
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
    }
}
