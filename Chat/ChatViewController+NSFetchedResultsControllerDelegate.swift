//
//  ChatViewController+NSFetchedResultsControllerDelegate.swift
//  Chat
//
//  Created by Joshua Finch on 09/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import UIKit
import CoreData

extension ChatViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     
        self.changes = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType)
    {
        self.changes.append(Change(type: type, sectionIndex: sectionIndex, indexPath: nil, newIndexPath: nil))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        self.changes.append(Change(type: type, sectionIndex: nil, indexPath: indexPath, newIndexPath: newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        let block = {
            self.tableView?.beginUpdates()
            
            for change in self.changes {
                if let sectionIndex = change.sectionIndex {
                    switch change.type {
                    case .delete:
                        self.tableView?.deleteSections([sectionIndex], with: .none)
                    case .insert:
                        self.tableView?.insertSections([sectionIndex], with: .none)
                    case .move:
                        break
                    case .update:
                        self.tableView?.reloadSections([sectionIndex], with: .none)
                    }
                } else {
                    switch change.type {
                    case .delete:
                        self.tableView?.deleteRows(at: [change.indexPath!], with: .none)
                    case .insert:
                        self.tableView?.insertRows(at: [change.newIndexPath!], with: .none)
                    case .move:
                        self.tableView?.deleteRows(at: [change.indexPath!], with: .none)
                        self.tableView?.insertRows(at: [change.newIndexPath!], with: .none)
                    case .update:
                        self.tableView?.reloadRows(at: [change.indexPath!], with: .none)
                    }
                }
            }
            
            self.tableView?.endUpdates()
        }
        
        UIView.performWithoutAnimation(block)
    }
}
