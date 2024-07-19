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
    var curentUserID: String! { get set }
    var groupMessageData: GroupMessage? { get }
    var receiverData: UserModel { get }
    var chatMembewrData: ChatMemberData? { get }
    
    func sendMessage(message: String)
    func fetchGroupChat(completion: @escaping () -> Void)
    func updateOnlineStatus(isOnline: Bool)
    func updateUnreadCount()
    func stopListningForGroupChat()
    func fetchChatMemberData(completion: @escaping () -> Void)
}


class ChatViewModel: ChatProtocol {
    
    var router: RouterProtocol
    var receiverData: UserModel
    
    var channelId : String
    var curentUserID : String!
    var groupMessageData: GroupMessage?
    var chatMembewrData: ChatMemberData?

    var listeners: [ListenerRegistration] = []

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
            self.addChatMemberData()
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
            
        chatChannelReference.document(channelId).collection(Keys.subNodeGroupMessage).document(messageDict[Keys.chatID] as? String ?? "")
            .setData(messageDict) { error in
                
                if error == nil {
                    if needToUpdateLastMessage {
                        chatChannelReference.document(self.channelId).updateData([Keys.message : message, Keys.modifiedAt : Utility.getCurrentTime()])
                    }
                    self.updateReadCount()
                }
            }
    }
    
    func addChatMemberData() {
        
        for memberId in [curentUserID, receiverData.userID] {
            let dict: [String: Any] = [
                Keys.isOnline: memberId == curentUserID ? true : false,
                Keys.memberId: memberId ?? "",
                Keys.muteTill: 0,
                Keys.roomId: channelId,
//                Keys.unreadCount: memberId == curentUserID ? 0 : 1,
            ]
            
            chatChannelReference.document(channelId).collection(Keys.subNodeChatMemberData).document(memberId ?? "").setData(dict)
        }
    }
    
    func fetchGroupChat(completion: @escaping () -> Void) {
        
        let listner = chatChannelReference.whereField(Keys.channelId, isEqualTo: channelId).addSnapshotListener { [weak self] querySnapshot, error in
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
        listeners.append(listner)
    }
    
    func fetchMessages(completion: @escaping () -> Void) {
        let chatChannelReference = chatChannelReference.document(self.channelId).collection(Keys.subNodeGroupMessage)
        
       let listner = chatChannelReference.order(by: Keys.messageTime).addSnapshotListener { [weak self] querySnapshot, error in
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
        
        listeners.append(listner)
    }

    func fetchChatMemberData(completion: @escaping () -> Void) {
       let listner = chatChannelReference.document(channelId).collection(Keys.subNodeChatMemberData).whereField(Keys.memberId, isEqualTo: receiverData.userID).addSnapshotListener { [weak self] querySnapshot, error in
           guard let self = self else { return }
           
           if let error = error {
               print("Error fetching chat member data: \(error.localizedDescription)")
               return
           }
           
           guard let documents = querySnapshot?.documents else {
               print("No message found of member data")
               return
           }
           
           do {
               if let document = documents.first {
                   chatMembewrData = try document.data(as: ChatMemberData.self)
                   completion()
               }
           } catch {
               print("Error decoding document: \(error.localizedDescription)")
           }
        }
        listeners.append(listner)
    }
    
    func updateReadCount() {
        chatChannelReference.document(channelId).collection(Keys.subNodeChatMemberData).document(receiverData.userID).updateData([Keys.unreadCount: FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            }
        }
    }
    
    func updateOnlineStatus(isOnline: Bool) {
        chatChannelReference.document(channelId).collection(Keys.subNodeChatMemberData).document(curentUserID).updateData([Keys.isOnline: isOnline])
    }
    
    func updateUnreadCount() {
        chatChannelReference.document(channelId).collection(Keys.subNodeChatMemberData).document(curentUserID).updateData([Keys.unreadCount: 0])
    }
    
    func stopListningForGroupChat() {
        for listner in listeners {
            listner.remove()
        }
        listeners.removeAll()
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
}
