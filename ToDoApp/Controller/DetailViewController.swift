//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by  Джон Костанов on 01/01/2020.
//  Copyright © 2020 John Kostanov. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var task: Task!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        locationLabel.text = task.location?.name
    }
}
