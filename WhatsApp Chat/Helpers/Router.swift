//
//  Router.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 06/07/24.
//

import Foundation
import UIKit

protocol RouterProtocol {
    func goBack()
    func redirectToLogin()
    func redirectToOTP(phoneNumber: String, coutryPhoneCode: String)
    func redirectToHome()
    func redirectToChat()
}


class Router: RouterProtocol {
    func goBack() {
        SceneDelegate().sceneDelegate?.mainNav?.popViewController(animated: true)
    }
    
    func redirectToLogin() {
        let vc = LoginVC(loginViewModel: LoginViewModel(router: Router()))
        SceneDelegate().sceneDelegate?.mainNav?.pushViewController(vc, animated: true)
    }
    
    func redirectToOTP(phoneNumber: String, coutryPhoneCode: String) {
        let vc = OTPViewController(viewModel: OTPViewModel(router: Router(), phoneNumber: phoneNumber, coutryPhoneCode: coutryPhoneCode))
        SceneDelegate().sceneDelegate?.mainNav?.pushViewController(vc, animated: true)
    }
    
    func redirectToHome() {
        let vc = HomeViewController(viewModel: HomeViewModel(router: Router()))
        SceneDelegate().sceneDelegate?.mainNav?.pushViewController(vc, animated: true)
    }
    
    func redirectToChat() {
        let vc = ChatViewController(viewModel: ChatViewModel(router: Router()))
        SceneDelegate().sceneDelegate?.mainNav?.pushViewController(vc, animated: true)
    }
}
