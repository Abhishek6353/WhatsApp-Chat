//
//  Utility.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation
import UIKit
import SVProgressHUD

class Utility: NSObject {
    
    //MARK: -  Loading View
    class func showLoadingView() {
        SVProgressHUD.show()
    }
    
    
    class func hideLoadingView() {
        SVProgressHUD.dismiss()
    }
    

    // manage data, time and their format
    class func currentDate(_ format: String = "yyyy-MM-dd-HH-mm-ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    
    // to manage Userdefault
    class func setValuefor(_ value: Any, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func valueFor(forKey key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) as Any
    }
    
    class func removeValueFor(forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    
    // to mask mobile number
    class func maskPhoneNumber(phoneNumber: String) -> String {
        let phoneNumberLength = phoneNumber.count
        
        // Check if phone number is less than or equal to 4 digits
        if phoneNumberLength <= 4 {
            return phoneNumber // No masking needed, return as is
        }
        
        // Extract the first two digits
        let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 2)
        let firstTwoDigits = String(phoneNumber[..<startIndex])
        
        // Extract the last two digits
        let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -2)
        let lastTwoDigits = String(phoneNumber[endIndex...])
        
        // Mask the middle part
        let maskedPartLength = phoneNumberLength - 4
        let maskedPart = String(repeating: "*", count: maskedPartLength)
        
        // Combine the parts
        let maskedPhoneNumber = firstTwoDigits + maskedPart + lastTwoDigits
        
        return maskedPhoneNumber
    }

    // to validate phone number
    class func isvalidatePhoneHavingDigitsOnly(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }

    //get current time
    class func getCurrentTime() -> Int64 {
        let date = Date().timeIntervalSince1970 * 1000
        return Int64(date)
    }

    
    class func getPrivateChannelId(otherUserId : String,loginUserId : String) -> String {
        var idArray : [String] = []
        idArray = [otherUserId,loginUserId]
        idArray.sort(){$0 < $1}
        return "\(idArray.first!)_\(idArray.last!)"
    }


}
