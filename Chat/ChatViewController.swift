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
    
    struct Change {
        let type: NSFetchedResultsChangeType
        let sectionIndex: Int?
        let indexPath: IndexPath?
        let newIndexPath: IndexPath?
    }
    
    var changes: [Change] = []
    
    override var navigationItem: UINavigationItem {
        let navigationItem = super.navigationItem
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMessage))
        navigationItem.rightBarButtonItem = add
        
        return navigationItem
    }
    
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
    
    // MARK: Actions
    
    func addMessage() {
        
        for _ in 0..<100 {
            chatService?.sendMessage(body: "Message: \(Date().timeIntervalSinceReferenceDate)")
        }
    }
}
