//
//  Extensions.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation

extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }
    
    class var className: String {
        String(describing: self)
    }
}
