//
//  NewTaskViewControllerTests.swift
//  ToDoAppTests
//
//  Created by  Джон Костанов on 01/01/2020.
//  Copyright © 2020 John Kostanov. All rights reserved.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func testHasTLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasAdressTextField() {
        XCTAssertTrue(sut.adressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testSaveUsesGeocoderToConvertCoorfinateFromAdress() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.20")
        
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "01.01.20"
        sut.adressTextField.text = "Huelva"
        sut.descriptionTextField.text = "Baz"
        
        sut.taskManager = TaskManager()
        let mockGeocoder = MockCLGeocoder()
        sut.geocoder = mockGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.2586074, longitude: -6.9499692)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addresString = "Huelva"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addresString) { (placemarks, error) in
            
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard
                let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude else {
                    XCTFail()
                    return
            }
            
            XCTAssertEqual(latitude, 37.2586074)
            XCTAssertEqual(longitude, -6.9499692)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveDismissesNewTaskViewController() {
        // given
        let mockNewTaskViewController = MockNewTaskViewController()
        mockNewTaskViewController.titleTextField = UITextField()
        mockNewTaskViewController.titleTextField.text = "Foo"
        mockNewTaskViewController.descriptionTextField = UITextField()
        mockNewTaskViewController.descriptionTextField.text = "Bar"
        mockNewTaskViewController.locationTextField = UITextField()
        mockNewTaskViewController.locationTextField.text = "Baz"
        mockNewTaskViewController.adressTextField = UITextField()
        mockNewTaskViewController.adressTextField.text = "Huelva"
        mockNewTaskViewController.dateTextField = UITextField()
        mockNewTaskViewController.dateTextField.text = "01.01.20"
        
        // when
        mockNewTaskViewController.save()
        
        //then
        XCTAssertTrue(mockNewTaskViewController.isDismissed)
    }
}

extension NewTaskViewControllerTests {
    class MockCLGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}

extension NewTaskViewControllerTests {
    
    class MockNewTaskViewController: NewTaskViewController {
        var isDismissed = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
    }
}
