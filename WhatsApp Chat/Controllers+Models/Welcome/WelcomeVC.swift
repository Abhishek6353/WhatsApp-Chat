//
//  WelcomeVC.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit

class WelcomeVC: UIViewController, UITextViewDelegate {
    
    
    //MARK: - Variables
    private let welcomeViewModel: WelcomeViewModel
    
    //MARK: - Outlets
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var txtViewPrivacyPolicy: UITextView!
    
    
    //MARK: - init
    init(welcomeViewModel: WelcomeViewModel) {
        self.welcomeViewModel = welcomeViewModel
        super.init(nibName: WelcomeVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        btnAgree.layer.cornerRadius = 4
    }
    
    
    //MARK: - Button Actions
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        welcomeViewModel.router.redirectToLogin()
    }
    
    
    //MARK: - Functions
    private func initialSetup() {
        getPrivacyPolicyAttributedText()
    }
    
    private func getPrivacyPolicyAttributedText() {
        let attributedString = NSMutableAttributedString(string: Constants.termsAndPrivacyStr)
        let privacyPolicyRange = (attributedString.string as NSString).range(of: Constants.privacyPolicyStr)
        let termsConditionsRange = (attributedString.string as NSString).range(of: Constants.termsOfServiceStr)
        
        attributedString.addAttribute(.font, value: Fonts.robotoRegular.font(size: 13), range:  NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.primaryText, range:  NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.backgroundColor, value: UIColor.primaryBackground, range:  NSRange(location: 0, length: attributedString.length))
        
        attributedString.addAttribute(.link, value: URLs.termsURLStr, range: termsConditionsRange)
        attributedString.addAttribute(.font, value: Fonts.robotoRegular.font(size: 13), range: termsConditionsRange)
        
        attributedString.addAttribute(.link, value: URLs.privacyURLStr, range: privacyPolicyRange)
        attributedString.addAttribute(.font, value: Fonts.robotoRegular.font(size: 13), range: privacyPolicyRange)
        
        txtViewPrivacyPolicy.linkTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.hyperLink]
        txtViewPrivacyPolicy.attributedText = attributedString
        txtViewPrivacyPolicy.delegate = self
        txtViewPrivacyPolicy.isSelectable = true
        txtViewPrivacyPolicy.isEditable = false
        txtViewPrivacyPolicy.textAlignment = .center
        txtViewPrivacyPolicy.delaysContentTouches = false
        txtViewPrivacyPolicy.isScrollEnabled = false
    }
}
