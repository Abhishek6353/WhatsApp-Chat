//
//  TextChatTableViewCell.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit

class TextChatTableViewCell: UITableViewCell {
    
    var chatData: Chats? {
        didSet {
            setData()
        }
    }

    @IBOutlet weak var chatBackgroundView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBackgroundView.layer.cornerRadius = 10
        
        
        stackView.removeArrangedSubview(chatBackgroundView)
        stackView.removeArrangedSubview(emptyView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData() {
        guard let data = chatData else {
            return
        }
        
        if data.type == "sent" {
            stackView.addArrangedSubview(emptyView)
            stackView.addArrangedSubview(chatBackgroundView)
        } else {
            stackView.addArrangedSubview(chatBackgroundView)
            stackView.addArrangedSubview(emptyView)
        }
        lblMessage.text = data.message
        lblTime.text = data.time
    }
}
