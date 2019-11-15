//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Assign the TaskListTableViewController to be the delegate of the fetchedResultsController
        TaskController.shared.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { // checks task controller for number of sections, else displays zero
        return TaskController.shared.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // initializes taskCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell () }

        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        // Let the cell handle its own updateing. The cell should set its view
        cell.update(withTask: task)
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // logic for "complete" and "incomplete" headers
        return TaskController.shared.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Incomplete" : "Complete"

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // sets height for header
        return 30.0
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            TaskController.shared.remove(task: task)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //IIDOO
        //identifier: what segue was triggered?
        if segue.identifier == "toViewTask" {
            //index: what cell triggered the segue?
            //destination: where am I trying to go?
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
            //object to send: What am I trying to pass?
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            //object to receive it: who's going to "catch this object?
            destinationVC.task = task
        }
    }
} //TaskListTableViewController class end bracket


extension TaskListTableViewController: ButtonTableViewCellDelegate {
    // Conform to Button Delegate
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        // Get the indexPath of the the sender; I.E. the cell
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        // Use that index to get the Task we need
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        // Use our Model Controller to handle the isComplete Property
        TaskController.shared.toggleIsCompleteFor(task: task)
        // Have the cell Update
        sender.update(withTask: task)
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    // Conform to the NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type{
            case .delete:
                guard let indexPath = indexPath else { break }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { break }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { break }
                tableView.reloadRows(at: [indexPath], with: .automatic)

            @unknown default:
                fatalError()
        }
    }

    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
        }
    }
}
