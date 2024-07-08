//
//  HomeViewController.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private let viewModel: HomeProtocol
    
    
    //MARK: - Outlets
    @IBOutlet weak var chatUnderLineView: UIView!
    @IBOutlet weak var statusUnderLineView: UIView!
    @IBOutlet weak var callsUnderLineView: UIView!
    @IBOutlet weak var btnStartChatting: UIButton!
    @IBOutlet weak var noChatView: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var btnAddNewFriend: UIButton!
    
    
    @IBOutlet weak var lblNotHaveChat: UILabel!
    
    //MARK: - init
    init(viewModel: HomeProtocol) {
        self.viewModel = viewModel
        super.init(nibName: HomeViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        viewModel.fetchFriendListner {
            self.contactsTableView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        lblNotHaveChat.font = Fonts.robotoMedium.font(size: 32)
        btnStartChatting.titleLabel?.font = Fonts.robotoMedium.font(size: 20)
        btnStartChatting.layer.cornerRadius = btnStartChatting.frame.height / 2
        btnAddNewFriend.layer.cornerRadius = btnAddNewFriend.frame.height / 2
    }
    
    
    
    //MARK: - Button Actions
    
    @IBAction func optionsButtonAction(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            chatUnderLineView.isHidden = true
            statusUnderLineView.isHidden = false
            callsUnderLineView.isHidden = true
            
        case 2:
            chatUnderLineView.isHidden = true
            statusUnderLineView.isHidden = true
            callsUnderLineView.isHidden = false
            
        default:
            chatUnderLineView.isHidden = true
            statusUnderLineView.isHidden = true
            callsUnderLineView.isHidden = true
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: UIButton) {
        showLogoutAlert()
    }
    
    @IBAction func addNewFriendButtonAction(_ sender: UIButton) {
        viewModel.router.redirectToContact()
    }
    //MARK: - Functions
    
    private func configure() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.showsHorizontalScrollIndicator = false
        contactsTableView.showsVerticalScrollIndicator = false
        contactsTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        contactsTableView.register(UINib(nibName: ContactTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.className)
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            // Perform logout action here, such as signing out the user
            Utility.showLoadingView()
            self.viewModel.signOut { result in
                Utility.hideLoadingView()
                
                switch result {
                case .success(_):
                    self.viewModel.router.redirectoWelcome()
                    
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription, position: .top)
                }
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)

    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let data = viewModel.friendsList[indexPath.row]
        
        cell.data = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.router.redirectToChat()
    }
}
