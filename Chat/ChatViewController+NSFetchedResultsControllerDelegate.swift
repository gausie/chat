//
//  ChatViewController+NSFetchedResultsControllerDelegate.swift
//  Chat
//
//  Created by Joshua Finch on 09/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import Foundation
import CoreData

extension ChatViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .delete:
            tableView?.deleteSections([sectionIndex], with: .none)
        case .insert:
            tableView?.insertSections([sectionIndex], with: .none)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .none)
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .none)
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .none)
            tableView?.insertRows(at: [newIndexPath!], with: .none)
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .none)
        }
    }
}
