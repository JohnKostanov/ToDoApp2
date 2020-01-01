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
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    func configure(withTask task: Task, done: Bool = false) {
        
        if done {
            let attributedString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attributedString
        } else {
            if let date = task.date {
                let dateString = dateFormatter.string(from: date)
                dateLabel.text = dateString
            }
            
            self.titleLabel.text = task.title
            self.locationLabel.text = task.location?.name
        }
        
        
    }
}
