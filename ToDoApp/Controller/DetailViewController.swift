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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
}
