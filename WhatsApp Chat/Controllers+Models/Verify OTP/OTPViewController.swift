//
//  OTPViewController.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit
import DPOTPView

class OTPViewController: UIViewController {
    
    //MARK: - Variables
    private var viewModel: OTPProtocol
    
    
    //MARK: - Outlets
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnVerifyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCodeSentNumber: UILabel!
    
    
    //MARK: - init
    init(viewModel: OTPProtocol) {
        self.viewModel = viewModel
        super.init(nibName: OTPViewController.className, bundle: nil)
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
        alertView.layer.cornerRadius = alertView.frame.height / 2
        btnVerify.layer.cornerRadius = btnVerify.frame.height / 2
        btnVerify.backgroundColor = .darkButton.withAlphaComponent(0.44)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        otpView.becomeFirstResponder()
    }
    
    
    //MARK: - Button Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        viewModel.router.goBack()
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            Utility.showLoadingView()
        }
        viewModel.signIn(otp: otpView.text ?? "") { result in
            Utility.hideLoadingView()
            
            switch result {
            case .success(_):
                self.viewModel.router.redirectToHome()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Function
    private func configure() {
        otpView.dpOTPViewDelegate = self
        otpView.dismissOnLastEntry = true
        otpView.fontTextField = Fonts.robotoRegular.font(size: 30)
        
        alertView.isHidden = true
        
        lblCodeSentNumber.text = "Code has been send to \(viewModel.coutryPhoneCode) \(Utility.maskPhoneNumber(phoneNumber: viewModel.phoneNumber))"
    }
}


//MARK: - OTPView methods -
extension OTPViewController: DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        
        if otpView.validate() {
            btnVerify.isEnabled = true
            btnVerify.backgroundColor = .darkButton
        } else {
            btnVerify.isEnabled = false
            btnVerify.backgroundColor = .darkButton.withAlphaComponent(0.44)
        }
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}
