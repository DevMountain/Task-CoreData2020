//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import UIKit

/**
The protocol we will use to handle the update of the cell when the `completeButton` is toggled
   - `class`: This protocol can interact with class level objects

Step One:
   - Define the protocol. This will need to interact with class level objects and define the task we want our delegate to handle.

Delegate Methods:
   - buttonCellButtonTapped(_ sender: ButtonTableViewCell)

*/
protocol ButtonTableViewCellDelegate: class {
    /**
    Delegate method for the `ButtonTableViewCellDelegate`

    Parameters:
       - sender: The cell that that user toggled
    */
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton! // IBAction Button Tapped links to same button
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    /**
    The `delegate` or *intern* for the protocol `ButtonTableViewCellDelegate`

    - weak: We mark this method as weak to not create a retain cycle
    - optional: We do not want to set the value of the delegate here.
    */
    var delegate: ButtonTableViewCellDelegate?

    fileprivate func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete" // ternary showing if isComplete is true/not
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }

    func update(withTask task: Task) {
        primaryLabel.text = task.name
        timestampLabel.text = "Task is due on: \(task.due!.stringValue())"
        updateButton(task.isComplete)
    }

    @IBAction func buttonTapped(_ sender: Any) {
        /// This is the call to action for the delegate. Hey intern, go get me a coffee
        delegate?.buttonCellButtonTapped(self)
    }
}

