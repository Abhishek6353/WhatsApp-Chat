//
//  ContactsViewController.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 07/07/24.
//

import UIKit
import FirebaseAuth

class ContactsViewController: UIViewController {

    //MARK: - Variables
    private let viewModel: ContactsViewModel
    
    
    //MARK: - Outlets
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var contactCountLabel: UILabel!
    
    
    //MARK: - init
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: ContactsViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getAllUsers()
    }
    
    
    //MARK: - Button Actions
    
    
    //MARK: - Functions
    private func configure() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(UINib(nibName: ContactTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.className)
    }
    private func getAllUsers() {
        viewModel.fetchAllUsers { error in
            if let error = error {
                self.view.makeToast(error)
                return
            }
            self.contactCountLabel.text = "\(self.viewModel.contacts.count) contcts"
            self.contactsTableView.reloadData()
        }
    }
}


//MARK: - TableView delegate methods
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none        
        cell.contactData = viewModel.contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let receiverData = self.viewModel.contacts[indexPath.row]
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let channelId = Utility.getPrivateChannelId(otherUserId: receiverData.userID, loginUserId: userID)

        SceneDelegate().sceneDelegate?.mainNav?.dismiss(animated: true, completion: {
            self.viewModel.router.redirectToChat(receiverData: self.viewModel.contacts[indexPath.row], channelID: channelId)
        })
    }
}
