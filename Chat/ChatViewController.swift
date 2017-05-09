//
//  ChatViewController.swift
//  Chat
//
//  Created by Joshua Finch on 09/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatService {
    
    var messageImporter: MessageImporter?
    
    func sendMessage(body: String) {
        let message = MessageImporter.Message(id: NSUUID().uuidString, chatId: "chatId", senderId: "sender", body: body, timestamp: Date() as NSDate)
        
        messageImporter?.importMessage(message: message)
    }
}

class ChatViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        didSet {
            
            guard let persistentContainer = persistentContainer else {
                fetchedResultsController = nil
                tableView?.reloadData()
                return
            }
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: Message.messagesInChat(chatId: "chatId"),
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            fetchedResultsController?.delegate = self
            
            do {
                print("Perform fetch")
                try fetchedResultsController?.performFetch()
                tableView?.reloadData()
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    var chatService: ChatService?
    
    private(set) var tableView: UITableView?
    private(set) var fetchedResultsController: NSFetchedResultsController<Message>?
    
    override func loadView() {
        
        view = UIView()
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.reloadData()
        
        self.tableView = tableView
    }
    
    override var navigationItem: UINavigationItem {
        let nav = super.navigationItem
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMessage))
        nav.rightBarButtonItem = add
        
        return nav
    }
    
    // MARK: Actions
    
    func addMessage() {
        
        for _ in 0..<100 {
            chatService?.sendMessage(body: "Message: \(Date().timeIntervalSinceReferenceDate)")
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")!
        
        if let message = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = message.body
        }
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
    
}

extension ChatViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, 
                    for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .delete:
            tableView?.deleteSections([sectionIndex], with: .fade)
        case .insert:
            tableView?.insertSections([sectionIndex], with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
        switch type {
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
