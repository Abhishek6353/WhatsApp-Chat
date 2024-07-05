//
//  ChatViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation

struct ChatModel {
    var date: String
    var data: [Chats]
}

struct Chats {
    var message: String
    var time: String?
    var type: String
}

protocol ChatProtocol {
    var router: RouterProtocol { get }
//    var messages: [String] { get set }
}

class ChatViewModel: ChatProtocol {
    
    var router: RouterProtocol
    var chatData: [ChatModel] = [
        
        ChatModel(date: "01 july 2022", data:
                    [
                        Chats(message: "Hi", type: "sent"),
                        Chats(message: "Lorem ipsum dolor", type: "sent"),
                        Chats(message: "sit amet, consctetur", type: "received"),
                        Chats(message: "adipiscing elit. Praesent egestas mi id cus", type: "sent"),
                        Chats(message: "Hii", type: "received")
                    ]),
        
        ChatModel(date: "02 july 2022", data:
                    [
                        Chats(message: "Nullam auctor accumsan ex. Aenean ac commodo felis Vivamus cursus libero Aenean ac commodo felis Vivamus cursus libero", type: "received"),
                        Chats(message: "Lorem ipsum dolor", type: "sent"),
                        Chats(message: "Hi", type: "sent"),
                        Chats(message: "Lorem ipsum dolor", type: "sent"),
                        Chats(message: "sit amet, consctetur", type: "received"),
                        Chats(message: "adipiscing elit. Praesent egestas mi id cus", type: "sent")
                    ]),
        
        ChatModel(date: "05 july 2022", data:
                    [
                        Chats(message: "Hii", type: "received"),
                        Chats(message: "Nullam auctor accumsan ex. Aenean ac commodo felis Vivamus cursus libero", type: "received"),
                        Chats(message: "Lorem ipsum dolor", type: "sent")
                    ])
    ]
                  
    

    init(router: RouterProtocol) {
        self.router = router
    }
}
