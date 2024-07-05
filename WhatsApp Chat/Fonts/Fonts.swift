//
//  Fonts.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation
import UIKit

enum Fonts: String {

    case robotoBlack = "Roboto-Black"
    case robotoBlackItalic = "Roboto-BlackItalic"
    case robotoBold = "Roboto-Bold"
    case robotoBoldItalic = "Roboto-BoldItalic"
    case robotoItalic = "Roboto-Italic"
    case robotoLight = "Roboto-Light"
    case robotoLightItalic = "Roboto-LightItalic"
    case robotoMedium = "Roboto-Medium"
    case robotoMediumItalic = "Roboto-MediumItalic"
    case robotoRegular = "Roboto-Regular"
    case robotoThin = "Roboto-Thin"
    case robotoThinItalic = "Roboto-ThinItalic"
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            assertionFailure("Font not loaded.")
            return .systemFont(ofSize: size)
        }
        return font
    }
}


