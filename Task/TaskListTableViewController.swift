//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TaskController.sharedController.incompleteTasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! ButtonTableViewCell
        
        let task = TaskController.sharedController.incompleteTasks[indexPath.row]
        
        cell.updateWithTask(task)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let task = TaskController.sharedController.incompleteTasks[indexPath.row]
            TaskController.sharedController.removeTask(task)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toViewTask" {
            
            let destinationViewController = segue.destinationViewController as? TaskDetailTableViewController
            
            if let taskDetailViewController = destinationViewController {
                
                // force the destination view controller to draw all subviews for updating
                _ = taskDetailViewController.view
                
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    taskDetailViewController.updateWithTask(TaskController.sharedController.incompleteTasks[selectedRow])
                }
            }
        }
    }
}

extension TaskListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        
        let indexPath = tableView.indexPathForCell(sender)!
        
        let task = TaskController.sharedController.incompleteTasks[indexPath.row]
        task.isComplete = !task.isComplete.boolValue
        TaskController.sharedController.saveToPersistentStorage()
        
        tableView.reloadData()
    }
}
