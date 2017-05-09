//
//  ChatService.swift
//  Chat
//
//  Created by Joshua Finch on 09/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import Foundation

class ChatService {
    
    var messageImporter: MessageImporter?
    
    func sendMessage(body: String) {
        let message = MessageImporter.Message(id: NSUUID().uuidString, chatId: "chatId", senderId: "sender", body: body, timestamp: Date() as NSDate)
        
        messageImporter?.importMessage(message: message)
    }
}
