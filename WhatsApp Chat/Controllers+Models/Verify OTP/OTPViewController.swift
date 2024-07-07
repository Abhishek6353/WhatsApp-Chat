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
    
    private var countdownTimer: Timer?
    private var remainingTime = 60

    
    //MARK: - Outlets
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnVerifyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCodeSentNumber: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var lblResentCode: UILabel!
    
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        otpView.becomeFirstResponder()
    }
    
    
    //MARK: - Button Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        viewModel.router.goBack()
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        Utility.showLoadingView()
        viewModel.signIn(otp: otpView.text ?? "") { result in
            Utility.hideLoadingView()
            
            switch result {
            case .success(_):
                self.viewModel.router.redirectToHome()
                
            case .failure(let error):
                self.view.makeToast(error.localizedDescription, position: .top)
            }
        }
    }
    
    @IBAction func resendCodeButtonAction(_ sender: UIButton) {
        
        Utility.showLoadingView()
        viewModel.verifyNumber(phoneNumber: "\(viewModel.coutryPhoneCode) \(viewModel.phoneNumber)") { result in
            Utility.hideLoadingView()
            
            switch result {
            case .success(_):
                self.showToast(message: "A new OTP has been sent to your number. Please check your inbox.")
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Function
    private func configure() {
        otpView.dpOTPViewDelegate = self
        otpView.dismissOnLastEntry = true
        otpView.fontTextField = Fonts.robotoRegular.font(size: 30)
        btnVerify.backgroundColor = .darkButton.withAlphaComponent(0.44)
        alertView.isHidden = true
        
        lblCodeSentNumber.text = "Code has been send to \(viewModel.coutryPhoneCode) \(Utility.maskPhoneNumber(phoneNumber: viewModel.phoneNumber))"

        startTimer()
    }
    
    private func startTimer() {
        countdownTimer?.invalidate()
        remainingTime = 60
        btnResendCode.isEnabled = false
        updateCountdownLabel()

        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            btnResendCode.isEnabled = true
            lblResentCode.text = "Resend OTP"
        }
    }

    private func updateCountdownLabel() {
        lblResentCode.attributedText = createCountdownAttributedString(remainingTime: remainingTime)
    }
    
    private func showToast(message: String) {
        self.view.makeToast(message, position: .top)
    }
    
    private func createCountdownAttributedString(remainingTime: Int) -> NSAttributedString {
        let fullText = "Resend Code in \(remainingTime) s"
        let remainingTimeString = "\(remainingTime)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let blackAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: fullText.count))
        
        let blueAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor._00_A_884]
        if let timeRange = fullText.range(of: remainingTimeString) {
            let nsRange = NSRange(timeRange, in: fullText)
            attributedString.addAttributes(blueAttributes, range: nsRange)
        }
        
        return attributedString
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
