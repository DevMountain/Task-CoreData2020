//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Connor Holland on 6/11/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}


class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
  
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
}
