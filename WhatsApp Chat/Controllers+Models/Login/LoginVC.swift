//
//  CHatVC.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit
import CountryPickerView

class LoginVC: UIViewController {
    
    //MARK: - Variables
    private let viewModel: LoginProtocol
    
    
    //MARK: - Outlets
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnNextBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryPickerView: CountryPickerView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    
    
    //MARK: - init
    init(loginViewModel: LoginProtocol) {
        self.viewModel = loginViewModel
        super.init(nibName: LoginVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        btnNext.layer.cornerRadius = 3
    }
    
    
    //MARK: - Button Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if isValidUserInput() {
            let number  = numberTextField.text!
            
            Utility.showLoadingView()
            viewModel.verifyNumber(phoneNumber: "\(countryPickerView.selectedCountry.phoneCode) \(number)") { result in
                Utility.hideLoadingView()
                
                switch result {
                case .success(_):
                    self.viewModel.router.redirectToOTP(phoneNumber: number, coutryPhoneCode: self.countryPickerView.selectedCountry.phoneCode)
                    
                case .failure(let error):
                    self.showToast(message: error.localizedDescription)
                }
            }
            
        }
    }
    
    
    
    //MARK: - Functions
    private func configure() {
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.showPhoneCodeInView = false
        countryPickerView.showCountryCodeInView = false
        countryPickerView.showCountryNameInView = false
        countryPickerView.showsLargeContentViewer = false
        
        subscribeToShowKeyboardNotifications()
    }
    
    private func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showToast(message: String) {
        self.view.makeToast(message, position: .top)
    }
    
    private func isValidUserInput() -> Bool {
        if numberTextField.text == "" {
            showToast(message: ToastMessages.enterNumber)
            return false
        } else if !Utility.isvalidatePhoneHavingDigitsOnly(phoneNumber: numberTextField.text ?? "") {
            showToast(message: ToastMessages.invalidNumber)
            return false
        } else {
            return true
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        btnNextBottomConstraint.constant = keyboardHeight
        
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        btnNextBottomConstraint.constant = 56
        
        let userInfo = notification.userInfo
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension LoginVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryNameLabel.text = country.name
        countryCodeLabel.text = country.phoneCode
    }
}
