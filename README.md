# Task
## Level 2
Students will build a simple task tracking app to practice project planning, progress tracking, MVC separation, intermediate table view features, and Core Data.
Students who complete this project independently are able to:
## Part One - Project Planning, Model Objects and Controllers, Persistence with Core Data
* follow a project planning framework to build a development plan
* follow a project planning framework to prioritize and manage project progress
* identify and build a simple navigation view hierarchy
* create a model object using Core Data
* add staged data to a model object controller
* implement a master-detail interface
* implement the UITableViewDataSource protocol
* implement a static UITableView
* create a custom UITableViewCell
* write a custom delegate protocol
* use a date picker as a custom input view
* wire up view controllers to model object controllers
* add a Core Data stack to a project
* implement basic data persistence with Core Data
## Part Two - NSFetchedResultsController
* use an NSFetchedResultsController to populate a UITableView with information from Core Data
* implement the NSFetchedResultsControllerDelegate to observe changes in Core Data information and update the display accordingly
# Part One - Project Planning, Model Objects and Controllers, Persistence with Core Data
## View Hierarchy
Set up a basic List-Detail view hierarchy using a UITableViewController for a TaskListTableViewController and a TaskDetailTableViewController.
1 Add a UITableViewController scene that will be used to list tasks
2 Embed the scene in a UINavigationController
3 Add an Add system bar button item to the navigation bar
4 Add a class file TaskListTableViewController.swift and assign the scene in the Storyboard
5 Add a UITableViewController scene that will be used to add and view tasks
	* note: We will use a static table view for our Task Detail view, static table views should be used sparingly, but they can be useful for a table view that will never change, such as a basic form.
6 Add a segue from the Add bar button item from the first scene to the second scene
7 Add a segue from the prototype cell in the first scene to the second scene
8 Add a class file TaskDetailTableViewController.swift and assign the scene in the Storyboard
	* note: We will finish building our views later on
## Add a Core Data Stack
You will add a CoreDataStack class that will initialize your persistent store, coordinator, and managed object context. Then you will build your Core Data data model.
1 Create a new file called CoreDataStack.swift.
2 Import CoreData and then add the following code to the file:
enum CoreDataStack {

    static let container: NSPersistentContainer = {

        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(“Unresolved error \(error), \(error.userInfo)”)
            }
        }
        return container
    }()

    static var context: NSManagedObjectContext { return container.viewContext }
}
* note: Be sure you understand what is going on in each line of code in your CoreDataStack
## Implement Core Data Model
1 Create a new Data Model template file (File -> New -> File -> Data Model) and be sure to use the app name for the name of the Data Model.
2 Add a New Entity called Task with attributes for name (String), notes (String), due (Date), and isComplete (Bool).
3 Use the Data Model inspector to set notes and due to optional values and give isComplete a default value of false.
4 At this point Xcode will automatically create your CoreDataClass and CoreDataProperties files for you.
	* note: Remember that when we create Core Data types they are NSManagedObject subclasses. Thus, Task is a subclass of NSManagedObject.
Now you need to add a convenience initializer for your Task objects that matches what would normally be a member-wise initializer. NSManagedObjects have a designated initializer called init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) and a convenience initializer called init(context moc: NSManagedObjectContext). You will write your own convenience initializer that uses the NSManagedObject convenience initializer and sets the properties on a Task object.
1 Create a new file called Task+Convenience.swift.
2 Add an extension to Task and create your convenience initializer inside of the extension
	* note: Make sure the initializer has parameters for name, notes, due, and context and that each parameter takes in the right type (context will be of type NSManagedObjectContext).
	* note: Remember that notes and due are optional, therefore, you can give them default values of nil. Also, give context a default value of CoreDataStack.context.
3 Inside the body of the initializer set your Task properties and call the NSManagedObject convenience initializer and pass in context from your own convenience initializer —> self.init(context: context)
## Controller Basics
Create a TaskController model object controller that will manage and serve Task objects to the rest of the application. The TaskController will also handle persistence using Core Data.
1 Create a TaskController.swift file and define a new TaskController class inside.
2 Create a shared property as a shared instance.
3 Add a tasks Array property with an empty default value.
4 Create function signatures for add(taskWithName name: String, notes: String?, due: Date?), update(task: Task, name: String, notes: String?, due: Date?), remove(task: Task), saveToPersistentStore(), and fetchTasks() -> [Task].
## Controller Staged Data Using a Mock Data Function
Add mock task data to the TaskController. Once there is mock data, teams can serialize work, with some working on the views with visible data and others working on implementing the controller logic. This is a quick way to get objects visible so you can begin building the views.
There are many ways to add mock data to model object controllers. We will do so using a computed property.
1 Create a mockTasks: [Task] computed property that will hold a number of staged Task objects
2 Initialize a small number of Task objects with varying properties (include at least one ‘isComplete’ task and one task with a due date)
Generally, when you use mock data, you set self.tasks to self.mockTasks in the initializer and then remove it when you no longer need mock data. In this case, we will be setting our mock data through our fetchTasks() -> [Task] function since that is what we will be doing when we use real data.
1 In your controller’s initializer, set the tasks array equal to the return of your fetchTasks() -> [Task] function.
	* note: If you have not added an initializer, add one.
2 In your fetchTasks() -> [Task] function return your mock tasks computed property.
At this point, you can wire up your list table view to display the complete or incomplete tasks to check your progress on Part One.
## Basic Task List View
Go to TaskListTableViewController.swift and finish setting up your views.
You will want this view to reload the table view each time it appears in order to display newly created tasks.
1 Implement the UITableViewDataSource functions using the TaskController tasks array
2 Set up your cells to display the name of the task (we’ll create a custom table view cell later so we’ll have to come back to this function later and change some things)
3 Reload the table view in viewWillAppear(_:)
## List View Editing
Add swipe-to-delete support for deleting tasks from the List View.
1 Implement the UITableViewDataSource tableView(_:commit:forRowAt:) function to enable swipe to delete functionality.
2 Using the indexPath from the function parameter, grab the task out of your tasks array on TaskController that you want to delete and then call TaskController.shared.remove(task:) to delete it. Then delete the row from the table view.
	* note: You haven’t filled out the remove function on TaskController yet, we will do that later, but we will set it up so that it will delete a Task object.
## Detail View Setup
Go to your TaskDetailTableViewController scene in storyboard and finish setting up the views.
You will use a UITextField to capture the name of a task, a UITextView to capture notes, and a ‘Save’ UIBarButtonItem to save the task.
Look at the task detail screenshot in the project folder and set up the Storyboard scene with all of the required user interface elements to appear similarly.
1 Update the table view to use static cells and make sure the style is ‘Grouped’
2 Create three separate sections, each with one cell (you’ll have to delete two cells from each section)
3 Change the name of the header in the first section to ‘Name’ and add a UITextField to the cell with placeholder text
	* note: Placeholder text should tell the user what they should put in the text field
4 Change the name of the header in the second section to ‘Due’ and add a UITextField to the cell with placeholder text
5 Change the name of the header in the third section to ‘Notes’ and add a text view to the cell
6 Resize the UI elements and add constraints so that they fill each cell
7 Add a Navigation Item to the Navigation Bar and then add two UIBarButtonItems to the Navigation Bar and change the System Item of one of them to ‘Save’ and to ‘Cancel’ for the other
## Setup the TaskDetailTableViewController class
1 Delete boilerplate code from your TaskDetailTableViewController class
	* note: Since the task detail table view is a static table view you don’t need UITableViewDataSource functions, so you can delete those as well.
2 Add an optional task property of type Task? and an optional dueDateValue property of type Date?
3 Add the appropriate outlets and IBActions from your detail scene in storyboard to your TaskDetailTableViewController class.
	* note: The IBAction for your ‘Save’ bar button item should save a new task if the task property is nil and update the existing task otherwise (even though we haven’t set it yet, use dueDateValue for the date that you pass into your add and update functions.
	* note: If you want, you can create another function called updateTask() that will do this for you and then call that function in your IBAction.
	* note: The IBAction for your ‘Cancel’ bar button item should simply pop the view controller, your ‘Save’ IBAction should do the same after it has updated the task
Your Detail View should follow the ‘updateViews’ pattern for updating the view elements with the details of a model object.
1 Add an updateViews() function
2 Implement the function to update all view elements that reflect details about the model object (in this case, the name text field, the due date text field, and the notes text view) and also have it check to see if the view has been loaded.
	* note: Dates require some extra work when we try to set them to labels. We’ll implement an extension on Date using DateFormatter to get a prettier label in the next step.
3 Call updateViews() in your viewDidLoad()
## Date Formatting
Dates are a notoriously difficult programming problem. Date creation, formatting, and math are all challenging for beginner programmers. This section will walk you through creating helper functions, setting dates, and using a date picker in place of a keyboard to set a date label.
Because Dates do not print in a user readable format, Apple includes the DateFormatter class to convert dates into strings and strings back into dates. We will add an extension to Date and make a reusable stringValue() function that returns a formatted string.
You could place this extension code directly into the view controller that will display the view, but creating an extension in a separate file allows you to reuse the code throughout the application and reuse the file in other projects you work on in the future.
1 Add a new DateHelpers.swift file and define an extension on Date
2 Create a stringValue() -> String function that instantiates a DateFormatter, sets the dateStyle, and returns a string from the date.
func stringValue() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium

    return formatter.string(from: self)
}
3 Go back to your updateViews() function and use task.due.stringValue() to set the text for the due label (you may have to cast task.due to Date first)
## Capture the Due Date
UIDatePicker is used to capture date and time information from a user. By setting a UIDatePicker to the inputView of a UITextField, a UIDatePicker will appear in place of the traditional keyboard. You can use a target action, delegate, or IBAction to capture the date that the user selects and set that to a variable.
1 Add a UIDatePicker object as a supplementary view to the detail scene
	* note: Drag a UIDatePicker object to the outline area of the Storyboard and Interface Builder will drop it directly beneath the First Responder object
2 Set the UIDatePicker to Date mode
3 Create an IBOutlet named dueDatePicker from the UIDatePicker supplementary view to the class file
4 In viewDidLoad(), set the date picker as the taskDueTextFields input view
	* hint: taskDueTextField.inputView = dueDatePicker
5 Create an IBAction from the UIDatePicker supplementary view to the class file named datePickerValueChanged
	* note: Choose UIDatePicker as the sender type so that you do not need to cast the object to get the date off of it
6 Implement the action to store the updated date value to dueDateValue and to set the taskDueTextField.text to the string value from the date picker’s date
Dismissing the keyboard can be done in many ways. When using a custom keyboard you have two common options: add a toolbar with a ‘Done’ button that resigns the first responder as the field’s input accessory, or add a UITapGestureRecognizer that does the same. We’ll do the latter.
1 Add a UITapGestureRecognizer object to the table view on the Task Detail Scene (just drag it out the same way you did with the UIDatePicker)
2 Create an IBAction from the UITapGestureRecognizer named userTappedView that resigns the first responder on all text fields or text views
## Segue
Recall that you created two segues from the List View to the Detail View. The segue from the plus button will tell the TaskDetailTableViewController that it should create a new task. The segue from a selected cell will tell the TaskDetailTableViewController that it should display a previously created task and save any changes made to it.
1 If you haven’t already, give the segue from a table view cell to the detail view an identifier.
2 Add a prepare(for segue: UIStoryboardSegue, sender: Any?) function to the TaskListTableViewController if it’s not there already
3 Implement the prepare(for segue: UIStoryboardSegue, sender: Any?) function. Be sure to check the identifier of the segue, get the destination of the segue, then get the index path for the selected row and use that index path to pass the selected task to the task property on the TaskDetailTableViewController
	* note: You will also want to pass the due property from your selected task to the dueDateValue property in your TaskDetailTableViewController
4 Go to the TaskDetailTableViewController class and update your task property to a computed property that uses a didSet property observer to call updateViews() every time task gets set. Thus, when you pass the task from your prepare(for segue: UIStoryboardSegue, sender: Any?) function to the task computed property it will update the views to reflect the properties of the selected task.
## Custom Table View Cell
Build a custom table view cell to display tasks. The cell should display the task name and have a button that acts as a checkmark to display and toggle the completion status of the task.
It is best practice to make table view cells reusable between apps. As a result, you will build a ButtonTableViewCell rather than a TaskTableViewCell that can be reused any time you want a cell with a button. You will add an extension to the ButtonTableViewCell for updating the view with a Task.
1 Add a new ButtonTableViewCell.swift as a subclass of UITableViewCell
2 Assign the new class to the prototype cell on the Task List Scene in Main.storyboard
3 Design the prototype cell with a label on the left and a square button on the right margin
	* note: If you are using a stack view, constrain the aspect ratio of the button to 1:1 to force the button into a square that gives the remainder of the space to the label
	* note: Use the image edge inset to shrink the image to not fill the entire height of the content view, you can adjust the image edge insets in the Size Inspector of the UIButton
4 Remove text from the button, but add a image of an empty checkbox
	* note: Use the ‘complete’ and ‘incomplete’ image assets included in the project folder
5 Create an IBOutlet for the label named primaryLabel
6 Create an IBOutlet for the button named completeButton
7 Create an IBAction for the button named buttonTapped which you will implement using a custom protocol in the next step
Implement the ‘update(with:)’ pattern in and extension on the ButtonTableViewCell class.
1 Add an updateButton(_ isComplete: Bool) function that updates the button’s image to the desired image based on the isComplete Bool
2 Add an extension to ButtonTableViewCell at the bottom of the class file
3 Add a function update(withTask task: Task) that updates the label to the name of the task and calls the updateButton(_ isComplete: Bool) function to update the image
4 Update the tableView(_:cellForRowAt:) table view data source function in your TaskListTableViewController class to call update(withTask task: Task) instead of setting the text label directly (you will have to cast your cell to be a ButtonTableViewCell)
## Custom Protocol
Write a protocol for the ButtonTableViewCell to delegate handling a button tap to the TaskListTableViewController, adopt the protocol, and use the delegate method to mark the task as complete and reload the cell.
1 Add a protocol named ButtonTableViewCellDelegate to the bottom of the class file
2 Define a required buttonCellButtonTapped(_ sender: ButtonTableViewCell) function
3 Add an optional delegate property on the ButtonTableViewCell
	* note: var delegate: ButtonTableViewCellDelegate?
4 Update the buttonTapped IBAction to check if a delegate is assigned, and if so, call the delegate protocol function
5 Adopt the protocol in the TaskListTableViewController class
6 Implement the buttonCellButtonTapped delegate function to capture the Task as a property, toggle task.isComplete, and reload the tapped row. Don’t forget to set your delegate in your tableView(_:cellForRowAt:) function!
	* note: You will need to create a function in TaskController called toggleIsCompleteFor(task: Task) that toggles the isComplete Bool on the Task object passed into the function, this is how you will toggle the task.isComplete in your delegate function
At this point you should be able to run your project and toggle tasks for the mock tasks you created.
## Persistence With Core Data
Implement your function signatures in TaskController to be able to persist to Core Data. Begin by importing CoreData.
1 Your saveToPersistentStore() function should call the save() function on the NSManagedObjectContext you set up in the CoreDataStack.
	* note: The save() function on an NSManagedObjectContext instance is a ‘throwing function’ so be sure to account for if it throws an error.
2 Your fetchTasks -> [Task] function needs to initialize a NSFetchRequest and then use that fetch request to fetch Task objects from the managed object context.
	* note: There is a fetch(_:) function on instances of NSManagedObjectContext that returns the an array of objects that meet the criteria specified by the request. Thus, you can return the result of that function in your fetchTasks() function. fetch(_:) is also a throwing function so be sure to account for an error.
	* note: To initialize a NSFetchRequest use the following syntax: let request: NSFetchRequest<Task> = Task.fetchRequest()
	* note: You can also delete your mock tasks that you created earlier at this point
3 Your add(taskWithName name: String, notes: String?, due: Date?) function should initialize a task object, save the managed object context using saveToPersistentStore(), and then fetch tasks from the managed object context and assign the returned tasks to your controller’s tasks array.
	* note: Initializing a subclass of NSManagedObject like Task automatically puts it into the Core Data managed object context so you don’t need to initialize a Task and put it anywhere.
4 Your update(task: Task, name: String, notes: String?, due: Date?) function needs to set the name, notes, and due property on the passed in task to be equal to the new name, notes, and due values passed into the function parameters. Then your function needs to call saveToPersistentStore() and set the tasks array to the return result of fetchTasks().
5 Your remove(task: Task) function should delete the task from the managed object context, save the managed object context, and then fetch tasks from the managed object context and assign the returned tasks to your tasks array.
	* note: You can get the managed object context from the task you passed into your function since every managed object exists in a managed object context.
6 Also be sure to update your toggleIsCompleteFor(task: Task) function to saveToPersistentStore().
Your app should now be able to create, update, and remove tasks. It should also persist to Core Data. Test the app and be sure to check if persistence is working. Check for and fix any bugs you might find.
## Black Diamonds
* Add support for projects (task parent object), or tags (task child object) to categorize your tasks
* Create a Unit test that verifies project or tag functionality by converting an instance to and from Data
* Add support for due date notifications scheduled to fire when the task is due
* Create a Unit test that verifies notification scheduling
* Add a segmented control as the title view that toggles whether the table view should display complete or incomplete tasks
* Add support for entering ‘Editing’ mode on a table view and add a cell that allows you to  [insert](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html)  new tasks
* Add automatic resizing to the table view cell with the Notes text view
* Update the settings for the checkbox images to  [inherit the tint color](http://stackoverflow.com/questions/19829356/color-tint-uibutton-image)  of the button
* Add ‘incompleteTasks’ and ‘completedTasks’ arrays and use an NSFetchRequest with an NSPredicate to return the correct results
* Implement a Fetched Results Controller for the Table View DataSource
# Part Two - NSFetchedResultsController
## Prepare Project to use NSFetchedResultsController
An NSFetchedResultsController has properties that allow you to access fetched objects, thereby replacing the tasks array that is currently on the TaskController. It also takes the place of the fetchTasks() function. Consequently, you will delete those items from the TaskController and remove the TaskListTableViewController entirely and start from scratch.
1 Delete your tasks array.
2 Delete your fetchTasks() function and all references to it.
3 Delete your entire file TaskListsTableViewController.swift.
	* note: When prompted and asked whether to remove reference or move to trash, choose move to trash.
## Add an NSFetchedResultsController to TaskController
NSFetchedResultsController is an API that allows you to easily sync a table view with information stored in Core Data. In order to use it, you must initialize it with an NSFetchRequest, a managed object context, the name of the variable you want your sections divided by, and an optional cache name. In our case, we do not need a cache, so we will leave it as nil.
1 Add a constant to your TaskController called fetchedResultsController that is of type NSFetchedResultsController<Task>.
2 You should get a compiler error saying you need to initialize this property. In your initializer, create a fetch request similar to the one you had before, but with a sort descriptor for isComplete and a sort descriptor for due, in that order. This ensures that the tasks will be sorted by whether or not they are complete first and then by their due date.
3 Initialize your fetchedResultsController using your fetch request, CoreDataStack.context, and the key by which you want to divide sections (we want a section for incomplete tasks and a section for complete tasks).
## Perform Fetch Using NSFetchedResultsController
An NSFetchedResultsController will keep you updated of any changes to the data in your Core Data model once a fetch has been performed, but you still must perform the initial fetch.
1 Inside your initializer, after having initialized your fetchedResultsController, you will need to call performFetch() on it.
	* note: You will need to use the do, try, catch syntax since performFetch() is a throwing function. The catch should print out an error if there is one.
## Basic Task List View
Rebuild a view that lists all tasks. You will use a UITableViewController and implement the UITableViewDataSource functions. Apple’s documentation for an NSFetchedResultsController describes exactly how to implement the UITableViewDataSource functions. There are examples in Swift beneath each Objective C example. However, note that the style differs slightly from the style you have been taught here at DevMountain. You should do your best to keep your code style consistent to what we have been learning the last weeks (i.e. safely unwrapping optionals, etc.). You can find the example needed in the section titled “Integrating the Fetched Results Controller with the Table View Data Source” in the  [Core Data Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/ConceptualCoreDataStacknsfetchedresultscontroller.html) .
You will want this view to reload the table view each time it appears in order to display newly created tasks.
1 Implement the numberOfSections(in:) function. Remember to use documentation for help on this.
2 Implement the numberOfRows(inSection:) function.
3 Implement the cellForRow(at indexPath: IndexPath) function by dequeuing your cell and casting it as your custom cell, getting the right task object, calling your custom cell’s update(withTask:) function, and setting the cell’s delegate. Don’t forget to adopt and conform to the ButtonTableViewDelegate protocol. We will implement the delegate method later.
4 Implement the tableView(_:titleForHeaderInSection:) function to return the proper section title. There is no example of this in the Core Data Programming Guide. However, each object in the array of NSFetchedResultsSectionInfo objects that you get from the Fetched Results Controller contains a name property that is a string representing the index of the section. You can convert this to an Int and use it to determine whether your header should say “Incomplete” or “Complete”. Use the sections property on your fetchedResultsController to get your array of NSFetchedResultsSectionInfo objects.
5 Implement your prepare(for segue: NSStoryboardSegue, sender: Any?) function to pass the selected task and the selected task’s due value to the next screen if a cell was tapped.
## List View Editing
Add swipe-to-delete support for deleting tasks from the List View and implement the ButtonTableViewCellDelegate function.
1 Go to your UITableViewDataSource tableView(_:commit:forRowAt:) function to enable swipe to delete functionality. When committing the editing style, delete the model object from the controller, but do not delete the cell from the table view. We will implement an NSFetchedResultsControllerDelegate method to do this once the object is deleted.
	* note: Use TaskController.shared.fetchedResultsController.object(at: indexPath) to get the correct Task object to delete.
2 Go to your ButtonTableViewCellDelegate function and call TaskController.shared.toggleIsCompleteFor(task: task) to toggle the isComplete property on the passed in Task object.
	* note: Again, use TaskController.shared.fetchedResultsController.object(at: indexPath) to get the correct Task object. You’ll also have to use sender to get the correct index path.
## Using the NSFetchedResultsControllerDelegate
Use NSFetchedResultsControllerDelegate functions to be notified of and respond to changes in the underlying Core Data information. The Core Data Programming Guide has examples of this as well in the section “Communication Data Changes to the Table View”.
1 Import CoreData into the TaskListTableViewController and then adopt the NSFetchedResultsControllerDelegate protocol in the class signature.
2 In viewDidLoad() set self as the delegate for the fetchedResultsController on the TaskController.
3 Look up NSFetchedResultsControllerDelegate in documentation. There are four functions that are called when the controller’s fetch results have changed that will update the table view to correctly display the right data. You will need to implement all of them, so write the function signatures for all of them.
4 The delegate function controllerWillChangeContent(_:) will be called before any change occurs and the delegate function controllerDidChangeContent(_:) will be called after changes occur. Sometimes there will be multiple changes that need to occur to a table view, some of which need to happen simultaneous to other changes. For this to work, the table view needs to know to execute all changes at the same time. This is done by calling tableView.beginUpdates() and then after all of the changes have been made, calling tableView.endUpdates(). You should begin updates in the function that will be called before changes happen and you should end updates in the function that will be called after those changes happen.
5 The delegate method controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) tells you what type of change has happened, whether an object was added, deleted, moved, or updated. To be safe, we should check for the type of change and respond accordingly. This is a great situation to use a switch statement. Go ahead and switch on type with the four different cases: .delete, .insert, .move, and .update.
6 For the .delete case, you simply need use the line of code you included in your tableView(_:commit:forRowAt:) function before you deleted the TaskListTableViewController.swift file: tableView.deleteRows(at: [indexPath], with: .fade). This is because when you delete an object, this delegate function will be called and you want the table view to reflect the changes made in your fetch results.
	* note: Be sure to safely unwrap indexPath
7 For the .insert case, you can use a similar line of code to insert a row at a given indexPath: tableView.insertRows(at: [newIndexPath], with: .automatic).
8 Using the two table view functions used in the previous two steps, attempt to fill out the .move case.
9 Search documentation to find a table view function that you can use to reload a row at a given index path in order to implement the .update case.
10 The delegate method controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) will be called if a section needs to be added or deleted. Again, the type variable passed into the function will tell you if a section needs to be added or deleted. Use documentation and the Core Data Programming Guide to implement this function.
The app is now finished. Run it, check for bugs, and fix any that you find.
# Contributions
Please refer to CONTRIBUTING.md.
# Copyright
© DevMountain LLC, 2020. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
