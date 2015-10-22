//
//  ProjectTableViewCell.swift
//  Task
//
//  Created by Caleb Hicks on 10/18/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

@IBDesignable

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var primaryLabel: UILabel!
    
    // MARK: - Complete Button Drawing Properties
    
    var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(self)
        }
    }
    
    func updateButton(isComplete: Bool) {
        
        if isComplete {
            completeButton.setImage(UIImage(named: "complete"), forState: .Normal)
        } else {
            completeButton.setImage(UIImage(named: "incomplete"), forState: .Normal)
        }
    }
}

protocol ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}

extension ButtonTableViewCell {
    
    func updateWithTask(task: Task) {
        
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}

