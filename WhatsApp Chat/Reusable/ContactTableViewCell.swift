//
//  ChatsTableVIewCell.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var messageStatusImageView: UIImageView!
    @IBOutlet weak var messageTypeImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
