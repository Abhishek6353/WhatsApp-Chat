//
//  ChatsTableVIewCell.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import UIKit
import SDWebImage

class ContactTableViewCell: UITableViewCell {
    
    var contactData: UserModel? {
        didSet {
            setContactData()
        }
    }
    
    var friendsData: FriendsDataModel? {
        didSet {
            setFriendsData()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var messageStatusImageView: UIImageView!
    @IBOutlet weak var messageTypeImageView: UIImageView!
    @IBOutlet weak var lastMessageStackView: UIStackView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func setContactData() {
        guard let data = contactData else {
            return
        }
        
        lblName.text = data.name
        lblMessage.text = data.about
        messageStatusImageView.isHidden = true
        
        if let imageURL = URL(string: data.profilePhotoUrl) {
            profileImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "sampleProfile"))
        }
    }
    
    func setFriendsData() {
        guard let data = friendsData else {
            return
        }
        
        lblName.text = data.personalDetail?.name
        lblMessage.text = data.message
        messageStatusImageView.isHidden = true
        
        if let imageURLStr = data.personalDetail?.profilePhotoUrl, let imageURL = URL(string: imageURLStr) {
            profileImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "sampleProfile"))
        }

    }
}
