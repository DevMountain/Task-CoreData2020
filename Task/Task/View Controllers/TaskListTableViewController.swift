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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // initializes taskCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell () }

        let task = TaskController.shared.tasks[indexPath.row]
        // Let the cell handle its own updateing. The cell should set its view
        cell.update(withTask: task)
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.shared.tasks[indexPath.row]
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
            let task = TaskController.shared.tasks[indexPath.row]
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
        let task = TaskController.shared.tasks[indexPath.row]
        // Use our Model Controller to handle the isComplete Property
        TaskController.shared.toggleIsCompleteFor(task: task)
        // Have the cell Update
        sender.update(withTask: task)
    }
}

