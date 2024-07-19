//
//  ChatViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
import FirebaseFirestore

protocol ChatProtocol {
    var router: RouterProtocol { get }
    var channelId: String { get }
    var curentUserID: String! { get }
    var groupMessageData: GroupMessage? { get }
    
    func sendMessage(message: String)
    func fetchGroupChat(completion: @escaping () -> Void)
}


class ChatViewModel: ChatProtocol {
    
    var router: RouterProtocol
    var receiverData: UserModel
    
    var channelId : String
    var curentUserID : String!
    var groupMessageData: GroupMessage?
    
    

    init(router: RouterProtocol, receiverData: UserModel, channelID: String) {
        self.router = router
        self.receiverData = receiverData
        self.channelId = channelID
    }
    
    
    func sendMessage(message: String) {
        
        if validateWhiteSpace(message) {
            chatChannelReference.document(channelId).getDocument { snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if snapshot?.data() == nil {
                    self.createNewChannel(message: message)
                } else {
                    self.addChatToGroupMessage(message: message, needToUpdateLastMessage: true)
                }
            }
        }
    }
    
    
    func createNewChannel(message: String) {
        let memberIDs = [curentUserID, receiverData.userID]
        let currentTime = Utility.getCurrentTime()
        
        let dict: [String: Any] = [
            Keys.channelId: channelId,
            Keys.createdAt: currentTime,
            Keys.isDeleted: false,
            Keys.memberIds: memberIDs,
            Keys.message: message,
            Keys.modifiedAt: currentTime,
            Keys.receiverId: receiverData.userID,
            Keys.senderId: curentUserID ?? ""
        ]
        
        chatChannelReference.document(channelId).setData(dict) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
           
            
            self.addChatToGroupMessage(message: message)
        }
    }
    
    func addChatToGroupMessage(message: String, needToUpdateLastMessage: Bool = false) {
        
        let chatID = chatChannelReference.document(channelId).collection(Keys.subNodeGroupMessage).document().documentID
        
        let messageDict: [String: Any] = [
            Keys.chatID: chatID,
            Keys.message: message,
            Keys.isDeleted: false,
            Keys.messageType: "text",
            Keys.messageTime: Utility.getCurrentTime(),
            Keys.senderId: curentUserID ?? "",
            Keys.serverTime : FieldValue.serverTimestamp()
        ]
            
        chatChannelReference.document(channelId).collection(Keys.subNodeGroupMessage).document(messageDict["chatID"] as? String ?? "")
            .setData(messageDict) { error in
                
                if error == nil {
                    if needToUpdateLastMessage {
                        chatChannelReference.document(self.channelId).updateData([Keys.message : message, Keys.modifiedAt : Utility.getCurrentTime()])
                    }
                    self.updateReadCount(messageDic: messageDict)
                }
            }
    }
    
    func fetchGroupChat(completion: @escaping () -> Void) {
        let chatChannelReference = Firestore.firestore().collection("channels")
        
        chatChannelReference.whereField("channelId", isEqualTo: channelId).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching chat: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No data found")
                return
            }
            
            for document in documents {
                do {
                    let data = try document.data(as: GroupMessage.self)
                    self.groupMessageData = data
                    self.fetchMessages {
                        completion()
                    }
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchMessages(completion: @escaping () -> Void) {
        let chatChannelReference = chatChannelReference.document(self.channelId).collection(Keys.GroupMessages)
        
        chatChannelReference.order(by: Keys.messageTime).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching chat: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No message found")
                return
            }
            
            var groupedMessages: [String: Chats] = [:]
            
            for document in documents {
                do {
                    let chatMessage = try document.data(as: ChatMessage.self)
                    let messageDate = Utility.convertTimestamp(chatMessage.messageTime)
                    
                    if groupedMessages[messageDate] != nil {
                        groupedMessages[messageDate]?.chatMessages.append(chatMessage)
                    } else {
                        groupedMessages[messageDate] = Chats(date: chatMessage.messageTime, chatMessages: [chatMessage])
                    }
                } catch {
                    print("Error decoding chat message: \(error.localizedDescription)")
                }
            }
            
            self.groupMessageData?.chats = Array(groupedMessages.values)
            completion()
        }
    }

    
    func updateReadCount(messageDic : [String : Any]) {
        
    }
    
    func validateWhiteSpace(_ str: String?) -> Bool {
        if (str == nil) {
            return false
        }
        
        if  (str?.isKind(of: NSString.self))! {
            let trimmed: String = str!.trimmingCharacters(in: CharacterSet.whitespaces)
            
            if trimmed.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    func fetchChatsListner(completion: @escaping () -> Void) {
        
    }
}
