//
//  TaskCell.swift
//  ToDoApp
//
//  Created by  Джон Костанов on 31/12/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(withTask task: Task) {
        self.titleLabel.text = task.title
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        if let date = task.date {
            let dateString = df.string(from: date)
            dateLabel.text = dateString
        }
        
        
        self.locationLabel.text = task.location?.name
    }
}
