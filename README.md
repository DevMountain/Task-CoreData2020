# Task

### Level 2

Students will build a simple task tracking app to practice project planning, progress tracking, MVC separation, intermediate table view features, and Core Data.

Students who complete this project independently are able to:

### Part One - Project Planning, Model Objects and Controllers, Persistence with CoreData

* follow a project planning framework to build a development plan
* follow a project planning framework to prioritize and manage project progress
* identify and build a simple navigation view hierarchy
* create a model object using CoreData
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
* use NSPredicates to filter search results

### Part Two - NSFetchedResultsController

* use an NSFetchedResultsController to populate a UITableView with information from CoreData
* implement the NSFetchedResultsControllerDelegate to observe changes in CoreData information and update the display accordingly


## Part One - Project Planning, Model Objects and Controllers, Persistence with CoreData

### View Hierarchy

Set up a basic List-Detail view hierarchy using a UITableViewController for a TaskListTableViewController and a TaskDetailTableViewController.

1. Add a UITableViewController scene that will be used to list tasks
2. Embed the scene in a UINavigationController
3. Add an Add system bar button item to the navigation bar
4. Add a class file ```TaskListTableViewController.swift``` and assign the scene in the Storyboard
5. Add a UITableViewController scene that will be used to add and view tasks
    * note: We will use a static table view for our Task Detail view, static table views should be used sparingly, but they can be useful for a table view that will never change, such as a basic form.
6. Add a segue from the Add button from the first scene to the second scene
7. Add a segue from the prototype cell in the first scene to the second scene
7. Add a class file ```TaskDetailTableViewController.swift``` and assign the scene in the Storyboard


### Add a Core Data Stack

Add a simple Stack to your application to start working with Core Data. You will build your Data Model and NSManagedObject subclass objects. Then you will add a Stack class that will initialize your persistent store, coordinator, and managed object context.

1. Import the Core Data ```Stack.swift``` template available on [Github](https://gist.github.com/calebhicks/404165bdb6bc77502026)
    * note: Review how this file works, and what it does for you each time you work with it.

### Implement Core Data Model

1. Create a new Data Model template file (File -> New -> File -> iOS Core Data -> Data Model), use the app name
2. Add a New Entity called Task with properties for name (String), notes (String), due (NSDate), and isComplete (Bool).
3. Use the Data Model Inspector to set notes and due to optional values, set isComplete with a default value of false
4. Assign a Class name of Task, this is what Xcode will use to create your NSManagedObject and CoreDataProperties files
4. Create Managed Object Subclass
    * note: Consider the purpose of the two different files you get
    * note: Verify that name and isComplete are required properties, and notes and due are optional properties. CoreData will automatically make all of the properties optional once you create your NSManagedObject subclasses so you'll need to delete the "?" from anything you want to be non-optional.

Now you need to add a Convenience Initializer to your ```Task.swift``` file that matches what would normally make as a memberwise initializer. NSManagedObjects have a designated initializer called ```init(entity: entity, insertIntoManagedObjectContext: context)``` that gets called by the ```NSEntityDescription.entityForName("Task", inManagedObjectContext: context)``` function that is traditionally used to create Managed Objects. You will write a convenience initializer that uses those two designated function calls and then set properties on the Task.

5. Add a Convenience Initializer to the ```Task.swift``` file
    * note: You can optionally add a 'managedObjectContext' parameter, but for our app we only have one, and we can set it to a default parameter value of ```Stack.sharedStack.managedObjectContext```)

```
convenience init(name: String, notes: String? = nil, due: NSDate? = nil, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {

    // there is no graceful way to respond to a failure on NSEntityDescription.entityForName, force unwrapping and forcing a crash is the desired behavior for this app
    
    // designated initializer

    let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)!
    
    self.init(entity: entity, insertIntoManagedObjectContext: context)
    
    // set properties here
}
```

### Controller Basics

Create a TaskController model object controller that will manage and serve Task objects to the rest of the application. The TaskController will also handle persistence using Core Data.

Views in our application want to display completed and incomplete tasks separately. Build the TaskController with a completedTasks and incompleteTasks computed properties that filter a tasks array.

1. Create a ```TaskController.swift``` file and define a new ```TaskController``` class inside.
7. Create a sharedController property as a shared instance. 
2. Add a tasks Array property with an empty default value.
3. Add a completedTasks computed Array property that returns only complete tasks.
    * note: Use a filter function on the tasks array
4. Add an incompleteTasks computed Array property that returns only incomplete tasks. 
    * note: Use a filter function on the tasks array
5. Create method signatures for ```addTask(name: String, notes: String?, due: NSDate?)```, ```removeTask(task: Task)```, ```updateTask(task: Task, name: String, notes: String?, due: NSDate?, isComplete: Bool)```, ```saveToPersistentStore()```, and ```fetchTasks() -> [Task]```.

### Controller Staged Data Using a Mock Data Function

Add mock task data to the TaskController. Once there is mock data, teams can serialize work, with some working on the views with visible data and others working on implementing the controller logic. This is a quick way to get objects visible so you can begin building the views.

There are many ways to add mock data to model object controllers. We will do so using a computed property.

1. Create a ```mockTasks:[Task]``` computed property that holds a number of staged Task objects
2. Initialize a small number of Task objects with varying properties (include at least one 'isComplete' task and one task with a due date)

Generally, when you want mock data, set self.tasks to self.mockTasks in the initializer. Remove it when you no longer want mock data. In this case, we will be setting our mock tasks through our ```fetchTasks() -> [Task]``` function since that is what we will be doing when using real data.

1. In your controller's initializer, set your tasks array equal to the return from your ```fetchTasks() -> [Task]``` function.
    * note: If you have not added an initializer, add one.
2. In your ```fetchTasks() -> [Task]``` function return your mock tasks computed property.

At this point, you can go and wire up your list table view to display the complete or incomplete tasks to check your progress on Part One. We will focus on the list and detail views in Part Two.

### Basic Task List View

Build a view that lists all tasks. You will use a UITableViewController and implement the UITableViewDataSource functions. You will start with a basic implementation and return to add editing features and custom cells to mark tasks as complete.

You will want this view to reload the table view each time it appears in order to display newly created tasks.

1. Implement the UITableViewDataSource functions using the TaskController tasks array
2. Set up your cells to display the name of the task
3. Add a UIBarButtonItem to the UINavigationBar with the plus symbol
    * note: Select 'Add' in the System Item menu from the Identity Inspector to set the button as a plus symbol, these are system bar button items, and include localization and other benefits

### List View Editing

Add swipe-to-delete support for deleting tasks from the List View. When committing the editing style, delete the model object from the controller, then delete the cell from the table view.

1. Implement the UITableViewDataSource ```commitEditingStyle``` functions to enable swipe to delete functionality.

### Detail View Setup

Build a view that provides editing and view functionality for a single task. You will use a static table view to create this form. A static table view should only be used when the contents of the table will be identical each time, otherwise, use a dynamic table view with prototype cells.

You will use a UITextField in the first cell to capture the name, a UIDatePicker from tapping the second cell to capture the due date, a UITextView in the third cell to capture notes, and a 'Save' UIBarButtonItem to save the task.

Look at the task detail screenshot or in the solution code. Set up the Storyboard scene with all required user interface elements to appear similarly.

1. Update the table view to use static cells
2. Create three separate sections, each with one cell
3. Change the name of the first section to 'Name', and add a UITextField to the cell with placeholder text
    * note: Placeholder text should tell the user what they put in the text field
4. Change the name of the second section to 'Due', and add a UITextField to the cell with placeholder text
5. Change the name of the third section to 'Notes', and add a text view to the cell
6. Resize the UI elements and add automatic constraints so that they fill each cell
7. Add an IBAction from the "Save" button. This action should save a new task if the ```task``` property is nil, and update the existing task otherwise.

Your Detail View should follow the 'updateWith' pattern for updating the view elements with the details of a model object. 

1. Add an ```updateWithTask(task: Task)``` function
2. Implement the 'updateWith' function to update all view elements that reflect details about the model object (in this case, the name text field, the due date text field, and the notes text view)
    * note: Dates require some extra work when we try to set them to labels. We'll implement an extension on NSDate using an NSDateFormatter to get a prettier label in the next step.

### Date Formatting

Dates are a notoriously difficult programming problem. Date creation, formatting, and math are all challenging for beginner programmers. This section will walk you through creating helper functions, setting dates, and using a date picker in place of a keyboard to set a date label.

Because NSDates do not print in a user readable format, Apple includes the NSDateFormatter class to convert dates into strings, and strings back into dates. We will add an extension to NSDate to make a reusable ```date.stringValue``` function that returns a formatted string.

You could place this extension code directly into the view controller that will display the view, but creating an extension allows you to reuse the code throughout the application, and reuse the DateHelpers file in other projects you work on in the future.

1. Add a new ```DateHelpers.swift``` file and define a new extension on NSDate (```extension NSDate { }```)
2. Create a ```stringValue() -> String``` function that instantiates an NSDateFormatter, sets the dateStyle, and returns a string from the date.

```
func stringValue() -> String {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    
    return formatter.stringFromDate(self)
}
```

3. Go back to your ```updateWithTask``` function and use task.due.stringValue to set the text for the due label

### Capture the Due Date

UIDatePicker is used to capture date and time information from a user. By setting a UIDatePicker to the inputView of a UITextField, a UIDatePicker will appear in place of the traditional keyboard. You can use a target action, delegate, or IBAction to capture the date that the user selects to a variable.

1. Add a UIDatePicker object as a supplementary view to the detail scene
    * note: Drag a UIDatePicker object to the outline area of the Storyboard, Interface Builder will drop it directly beneath the First Responder object
2. Set the UIDatePicker to Date mode
3. Create an IBOutlet named ```dueDatePicker``` from the UIDatePicker supplementary view to the class file
3. In ```viewDidLoad```, set the date picker as the text field's input view
    * hint: ```textField.inputView = dueDatePicker```
4. Create an IBAction from the UIDatePicker supplementary view to the class file named ```datePickerValueChanged```
    * note: Choose UIDatePicker as the sender type so that you do not need to cast the object to get the date off of it
5. Create an optional due date placeholder property ```dueDateValue```
6. Implement the action to store the updated date value to ```dueDateValue```

Dismissing the keyboard can be done in many ways. You can use the ```textFieldShouldReturn``` delegate function on the system keyboard. When using a custom keyboard, you have two common options: add toolbar with a Done button that resigns first responder as the field's input accessory, or add a tap gesture recognizer that does the same.

7. Add a UITapGestureRecognizer object to Table View on the Task Detail Scene. You may need to add it to the view controller and then create an outlet collection to the Table View using the Outlet Inspector.
8. Create an IBAction from the UITapGestureRecognizer named ```userTappedView``` that resigns first responder on all text fields or text views

### Segue

You will add two separate segues from the List View to the Detail View. The segue from the plus button will tell the ```TaskDetailTableViewController``` that it should create a new task. The segue from a selected cell will tell the ```TaskDetailTableViewController``` that it should display a previously created task, and save any changes to the same.

1. Add a 'show' segue from the Add button to the detail scene and give the segue an identifier if you haven't already
    * note: Consider that this segue will be used to add a task when naming the identifier
2. Add a 'show' segue from the table view cell to the TaskDetailViewController scene and give the segue an identifier if you haven't already
    * note: Consider that this segue will be used to edit a task when naming the identifier
3. Add a ```prepareForSegue``` function to the TaskListTableViewController
4. Implement the ```prepareForSegue``` function. Check the identifier of the segue parameter, if the identifier is 'toAddTask' then we will present the destination view controller without passing a task.
5. Continue implementing the ```prepareForSegue``` function. If the identifier is 'toViewTask' we will pass the selected task to the DetailViewController by calling our ```updateWithTask(task: Task)``` function
    * note: You will need to capture the selected task by using the indexPath of the selected cell
    * note: Remember that the ```updateWithTask(task: Task)``` function will update the destination view controller with the task details, you may need to force the detail view to draw it's subviews before updating

### Custom Table View Cell

Build a custom table view cell to display tasks. The cell should display the task name and have a button that acts as a checkmark to display and toggle the completion status of the task.

It is best practice to make table view cells reusable between apps. As a result, you will build a ```ButtonTableViewCell``` rather than a ```TaskTableViewCell``` that can be reused any time you want a cell with a button. You will add an extension to the ```ButtonTableViewCell``` for updating the view with a Task. 

1. Add a new ```ButtonTableViewCell.swift``` as a subclass of UITableViewCell
2. Assign the new class to the prototype cell on the Task List Scene in ```Main.storyboard```
3. Design the prototype cell with a label on the left and a square button on the right margin
    * note: If using a stack view, constrain the aspect ratio of the button to 1:1 to force the button into a square that gives the remainder of the space to the label
    * note: Use the image edge inset to shrink the image to not fill the entire height of the content view
4. Remove text from the button, but add a image of an empty checkbox
    * note: Use the 'complete' and 'incomplete' image assets included in the project
4. Create an IBOutlet for the label named ```primaryLabel```
5. Create an IBOutlet for the button named ```button```
6. Create an IBAction for the button named ```buttonTapped``` which you will implement using a custom protocol in the next step

Implement the 'updateWith' pattern in an extension on the ```ButtonTableViewCell``` class.

1. Add an ```updateButton(isComplete: Bool)``` function that updates the button's image to the desired image based on the isComplete Bool
2. Add an extension to ```ButtonTableViewCell``` at the bottom of the class file
3. Add a function ```updateWithTask(task: Task)``` that updates the label to the name of the task, and calls the ```updateButton(isComplete: Bool)``` function to update the image
4. Update the ```cellForRowAtIndexPath``` to call ```updateWithTask(task: Task)``` instead of setting the text label directly

### Custom Protocol

Write a protocol for the ```ButtonTableViewCell``` to delegate handling a button tap to the ```TaskListTableViewController```, adopt the protocol, and use the delegate method to mark the task as complete and reload the cell.

1. Add a protocol named ```ButtonTableViewCellDelegate``` to the bottom of the class file
2. Define a required ```buttonCellButtonTapped(sender: ButtonTableViewCell)``` function
3. Add an optional delegate property on the ButtonTableViewCell, require the delegate to have adopted the delegate protocol 
    * note: ```var delegate: ButtonTableViewCellDelegate?```
4. Update the ```buttonTapped``` IBAction to check if a delegate is assigned, and if so, call the delegate protocol function
5. Adopt the protocol in the ```TaskListTableViewController``` class
6. Implement the ```buttonCellButtonTapped``` delegate method to capture the Task as a variable, toggle task.isComplete, save to persistent storage, and reload the table view

### Persistence With CoreData

1. Your ```addTask(name: String, notes: String?, due: NSDate?)``` function should initialize a task object, save the tasks, and then fetch tasks from the persistent store and assign the returned tasks to your controller's ```.tasks``` array.
    * note: Initializing a subclass of NSManagedObject like Task automatically puts it into the CoreData Managed Object Context so you don't need to initialize and then add it anywhere
2. Your ```removeTask(task: Task)``` function should delete the task from the Managed Object Context, save the tasks, and the fetch tasks from the persistent store and assign the returned tasks to your controller's ```.tasks``` array.
3. Your ```saveToPersistentStore()``` should save everything in the Managed Object Context to the persistent store.
4. Your ```fetchTasks() -> [Task]``` should perform an NSFetchRequest on the Managed Object Context to get tasks, and return an array of tasks.
    * note: You may need to review the Swift Programming Guide to understand the functions that throw.

### Black Diamonds

* Add support for projects (task parent object), or tags (task child object) to categorize your tasks
* Create a Unit test that verifies project or tag functionality by converting an instance to and from NSData
* Add support for due date notifications scheduled to fire when the task is due
* Create a Unit test that verifies notification scheduling
* Add a segmented control as the title view that toggles whether the table view should display complete or incomplete tasks
* Add support for entering 'Editing' mode on a table view and add a cell that allows you to [insert](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html) new tasks
* Add [automatic resizing](https://pontifex.azurewebsites.net/self-sizing-uitableviewcell-with-uitextview-in-ios-8/) to the table view cell with the Notes text view
* Update the settings for the checkbox images to [inherit the tint color](http://stackoverflow.com/questions/19829356/color-tint-uibutton-image) of the button
* Refactor the 'incompleteTasks' and 'completedTasks' arrays to use an NSFetchRequest with an NSPredicate to return the correct results
* Implement a Fetched Results Controller for the Table View DataSource

## Part Two - NSFetchedResultsController

### Prepare Project to use NSFetchedResultsController

An NSFetchedResultsController has properties that allow you to access fetched objects, thereby replacing the tasks array that is currently on the TaskController. It also takes the place of the fetchTasks function. Consequently, you will delete those items from the TaskController, and remove the TaskListTableViewController entirely and start from scratch.

1. Delete your tasks array and the computed properties for incomplete and complete tasks.
2. Delete your fetchTasks function and all references to it.
3. Delete your entire file ```TaskListsTableVieWController.swift```.
    * note: When prompted and asked whether or not to remove reference or move to trash, choose move to trash.

### Add an NSFetchedResultsController to TaskController

NSFetchedResultsController is an API that allows you to easily sync a table view with information stored in CoreData. In order to use it, you must initialize it with an NSFetchRequest, a Managed Object Context, the name of the variable you want your sections divided by, and an optional cache name. In our case, we do not need a cache, so we will leave it as nil.

1. Add a constant to your ```TaskController``` called fetchedResultsController that is of type ```NSFetchedResultsController```. 
2. You should get a compiler error saying you need to initialize this property. In your initializer, create a fetch request similar to the one you had before, but with a sort descriptor for ```isComplete``` and a sort descriptor for ```due```, in that order. This ensures that the tasks will be sorted by whether or not they are complete first, and then by their due date.
3. Initialize your fetchedResultsController using your fetch request, ```Stack.sharedStack.managedObjectContext```, and the key by which you want to divide sections (we want a section for incomplete tasks and a section for complete tasks).

### Perform Fetch Using NSFetchedResultsController

An NSFetchedResultsController will keep you updated of any changes to the data in your CoreData model once a fetch has been performed, but you still must perform the initial fetch.

1. Inside your initializer, after having initialized your fetchedResultsController, you will need to call ```performFetch()``` on it.
    * note: You will need to use the do, try, catch syntax, and should print out the error if there is one.

### Basic Task List View

Rebuild a view that lists all tasks. You will use a UITableViewController and implement the UITableViewDataSource functions. Apple's documentation for an NSFetchedResultsController describes exactly how to implement the UITableViewDataSource functions. There are examples in Swift beneath each Objective C example. However, note that the style differs slightly from the style you have been taught here at DevMountain. You should do your best to keep your code style consistent to what we have been learning the last weeks (i.e. safely unwrapping optionals, etc.). You can find the example needed in the section titled "Integrating the Fetched Results Controller with the Table View Data Source" in the [Core Data Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html).

You will want this view to reload the table view each time it appears in order to display newly created tasks.

1. Implement the ```numberOfSectionsInTableView``` function. Remember to use documentation for help on this.
2. Implement the ```numberOfRowsInSection``` function.
3. Implement the ```cellForRowAtIndexPath``` function by dequeuing your cell and casting it as your custom cell, getting the right task object, and calling your custom cell's ```updateWithTask(task: Task)``` function. 
4. Implement the ```titleForHeaderInSection``` function to return the proper section title. There is no example for this in the Core Data Programming Guide. However, the array of NSFetchedResultsSectionInfo objects that you get from the Fetched Results Controller contains a name property that is a string representing the index of the section. You can cast this as an ```Int``` and use it to determine whether your header should say "Incomplete" or "Complete".
4. Implement your ```prepareForSegue``` function to pass the selected task to the next screen if a cell was tapped.

### List View Editing

Add swipe-to-delete support for deleting tasks from the List View. When committing the editing style, delete the model object from the controller, but do not delete the cell from the table view. We will implement an NSFetchedResultsControllerDelegate method to do this once the object is deleted.

1. Implement the UITableViewDataSource ```commitEditingStyle``` functions to enable swipe to delete functionality.

### Using the NSFetchedResultsControllerDelegate

Use NSFetchedResultsControllerDelegate functions to be notified of and respond to changes in the underlying CoreData information. The Core Data Programming Guide has examples of this as well in the section "Communication Data Changes to the Table View".

1. Import CoreData into the TaskListTableViewController and then add NSFetchedResultsControllerDelegate to the class signature.
2. In ```viewDidLoad``` set the ```self``` as the delegate for the fetchedResultsController on the TaskController.
3. Look at documentation for the NSFetchedResultsControllerDelegate. There are four methods. you will need to implement all of them, so write the function signatures for all of them.
4. The delegate method ```func controllerWillChangeContent(controller: NSFetchedResultsController)``` will be called before any change occurs, and the delegate method ```func controllerDidChangeContent(controller: NSFetchedResultsController)``` will be called after changes occur. Sometimes there will be multiple changes that need to occur to the table view, some of which need to happen simultaneous to other changes. For this to work, the table view needs to know to execute all changes at the same time. This is done by saying ```tableView.beginUpdates()```, and then after all of the changes have been made, saying ```tableView.endUpdates()```. You should begin updates in the function that will be called before changes happen, and you should end updates in the function that will be called after changes happen.  
4. The delegate method ```func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)``` tells you what type of change has happened, whether an object was added, deleted, moved, or updated. To be safe, we should check for the type of change and respond accordingly. This is a great situation to use a switch statement. Go ahead and add a switch statement for ```type``` with four cases, ```.Delete```, ```.Insert```, ```.Move```, and ```.Update```. 
5. In the ```.Delete``` case, you simply need use the line of code I told you not to include in your ```commitEditingStyle``` function: ```tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)```. This is because when you delete an object, this delegate function will be called and that is where you will handle the deletion of the rows.
6. In the ```.Insert``` case, you can use a similar line of code to insert a row at a given indexPath: ```tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)```.
7. Using the two table view functions used in the previous two steps, attempt to fill in the ```.Move``` case. You will need to delete the row at the given indexPath, and insert a row at the newIndexPath.
8. Search documentation to find a table view function that you can use to reload a row at a given index path in order to implement the ```.Update``` case.
9. The delegate method ```func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)``` will be called if a section needs to be added or deleted. Again, the ```type``` variable passed into the function will tell you if a section needs to be added or deleted. Use documentation and the Core Data Programming Guide to implement this function.

## Contributions

Please refer to CONTRIBUTING.md.


## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.