//
//  ChatViewControllerTests.swift
//  Chat
//
//  Created by Joshua Finch on 09/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import Foundation
import XCTest

@testable import Chat

class ChatViewControllerTests: XCTestCase {
    
    private var coreData: CoreData?
    private var messageImporter: MessageImporter?
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let expect = expectation(description: "Persistent stores loaded successfully")
        
        coreData = CoreData(name: "Model", storeType: .InMemory, loadPersistentStoresCompletionHandler: { success in
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        guard let persistentContainer = coreData?.persistentContainer else {
            return
        }
        
        messageImporter = MessageImporter(label: NSUUID().uuidString, persistentContainer: persistentContainer)
    }
    
    func testInsertedMessageUpdatesTableView() {
        
        let vc = ChatViewController()
        vc.persistentContainer = coreData?.persistentContainer
        XCTAssertNotNil(vc.persistentContainer)
        XCTAssertNotNil(vc.fetchedResultsController)
        
        let _ = vc.view
        
        XCTAssertNotNil(vc.tableView)
        let tableView = vc.tableView!
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        
        let expectInsertFirstMessage = expectation(description: "Inserted first message")
        let message = MessageImporter.Message(id: "id", chatId: "chatId", senderId: "senderId",
                                              body: "body", timestamp: NSDate())
        messageImporter?.importMessage(message: message, completion: { 
            expectInsertFirstMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testInsertedSecondMessageUpdatesTableViewAgain() {
        
        let vc = ChatViewController()
        vc.persistentContainer = coreData?.persistentContainer
        XCTAssertNotNil(vc.persistentContainer)
        XCTAssertNotNil(vc.fetchedResultsController)
        
        let _ = vc.view
        
        XCTAssertNotNil(vc.tableView)
        let tableView = vc.tableView!
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        
        let expectInsertFirstMessage = expectation(description: "Inserted first message")
        let message = MessageImporter.Message(id: "id", chatId: "chatId", senderId: "senderId",
                                              body: "body", timestamp: NSDate())
        messageImporter?.importMessage(message: message, completion: {
            expectInsertFirstMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        let expectInsertSecondMessage = expectation(description: "Inserted second message")
        let message2 = MessageImporter.Message(id: "id2", chatId: "chatId", senderId: "senderId",
                                              body: "body2", timestamp: NSDate())
        messageImporter?.importMessage(message: message2, completion: {
            expectInsertSecondMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testInsertedSameMessageTwiceDoesNotUpdateTableViewAgain() {
        
        let vc = ChatViewController()
        vc.persistentContainer = coreData?.persistentContainer
        XCTAssertNotNil(vc.persistentContainer)
        XCTAssertNotNil(vc.fetchedResultsController)
        
        let _ = vc.view
        
        XCTAssertNotNil(vc.tableView)
        let tableView = vc.tableView!
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        
        let expectInsertFirstMessage = expectation(description: "Inserted first message")
        let message = MessageImporter.Message(id: "id", chatId: "chatId", senderId: "senderId",
                                              body: "body", timestamp: NSDate())
        messageImporter?.importMessage(message: message, completion: {
            expectInsertFirstMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        let expectInsertSecondMessage = expectation(description: "Inserted second message")
        messageImporter?.importMessage(message: message, completion: {
            expectInsertSecondMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testInsertSameMessageWithUpdatedBodyUpdatesCellLabelToNewBody() {
        
        let vc = ChatViewController()
        vc.persistentContainer = coreData?.persistentContainer
        XCTAssertNotNil(vc.persistentContainer)
        XCTAssertNotNil(vc.fetchedResultsController)
        
        let _ = vc.view
        
        XCTAssertNotNil(vc.tableView)
        let tableView = vc.tableView!
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        
        let expectInsertFirstMessage = expectation(description: "Inserted first message")
        let message = MessageImporter.Message(id: "id", chatId: "chatId", senderId: "senderId",
                                              body: "body", timestamp: NSDate())
        messageImporter?.importMessage(message: message, completion: {
            expectInsertFirstMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell?.textLabel?.text, "body")
        
        let expectInsertSecondMessage = expectation(description: "Inserted second message")
        let messageUpdated = MessageImporter.Message(id: "id", chatId: "chatId", senderId: "senderId",
                                                     body: "body2", timestamp: NSDate())
        messageImporter?.importMessage(message: messageUpdated, completion: {
            expectInsertSecondMessage.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        let updatedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(updatedCell?.textLabel?.text, "body2")
    }
}
