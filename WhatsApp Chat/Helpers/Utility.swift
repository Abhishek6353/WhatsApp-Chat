//
//  Utility.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation
import UIKit
import KRProgressHUD

class Utility: NSObject {
    
    //MARK: -  Loading View
    class func showLoadingView() {
        KRProgressHUD
            .set(activityIndicatorViewColors: [.primaryButton])
            .show()
    }
    
    class func showLoadingView(withTitle title: String) {
        KRProgressHUD
            .set(activityIndicatorViewColors: [.primaryButton])
            .show(withMessage: title)
    }
    
    class func hideLoadingView() {
        KRProgressHUD.dismiss()
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

}
