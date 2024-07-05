//
//  ChatsViewController.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: - Variables
    let viewModel: ChatViewModel
    
    
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageOptionsView: UIView!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    
    //MARK: - init
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: ChatViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - VIew lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillLayoutSubviews() {
        messageOptionsView.layer.cornerRadius = messageOptionsView.frame.height / 2
        btnSendMessage.layer.cornerRadius = btnSendMessage.frame.height / 2
    }
    
    //MARK: - Button actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        viewModel.router.goBack()
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if sender.tag == 0 {
                
        } else {
            guard let text = messageTextField.text, !text.isEmpty else { return }
            viewModel.chatData[2].data.append(Chats(message: text, time: Utility.currentDate("hh:mm a"), type: "sent"))
            chatTableView.reloadData()
            scrollToBottom()
            
            messageTextField.text?.removeAll()

        }
    }
    
    
    //MARK: - Functions
    func configure() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.showsHorizontalScrollIndicator = false
        chatTableView.showsVerticalScrollIndicator = false
        chatTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 25, right: 0)
        chatTableView.register(UINib(nibName: TextChatTableViewCell.className, bundle: nil), forCellReuseIdentifier: TextChatTableViewCell.className)
        scrollToBottom()

        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func scrollToBottom() {
        let lastSection = chatTableView.numberOfSections - 1
        let lastRow = chatTableView.numberOfRows(inSection: lastSection) - 1
        
        if lastRow >= 0 && lastSection >= 0 {
            chatTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .top, animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        btnSendMessage.setImage(textField.text!.isEmpty ? .iconMic : .iconSendMessage, for: .normal)
        btnSendMessage.tag = textField.text!.isEmpty ? 0 : 1
    }
}


//MARK: - Tableview delegate functions
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.chatData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.chatData[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextChatTableViewCell.className, for: indexPath) as? TextChatTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none

        cell.chatData = viewModel.chatData[indexPath.section].data[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed(ChatTableHeaderView.className, owner: self, options: nil)?.first as? ChatTableHeaderView else {
            return UIView()
        }
        headerView.containerView.layer.cornerRadius = 5
        headerView.titleLabel.text = viewModel.chatData[section].date
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
}


//MARK: - Textfield delegate methods
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
}
