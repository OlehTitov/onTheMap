//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 02.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - PROPERTIES
    let spinner = LoadingIndicator.addSpinner()
    let darkenView = LoadingIndicator.addDarkenView()
    
    //MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
        UdacityClient.getStudentLocation(limit: "100", order: "-", completion: handleGetStudentsLocation(students:error:))
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.view.addSubview(spinner)
        self.view.addSubview(darkenView)
        spinner.center = self.view.center
    }
    
    //MARK: - METHODS
    func handleGetStudentsLocation(students: [StudentInformation], error: Error?) {
        StudentModel.students = students
        attachPins()
    }
    
    func attachPins() {
        let students = StudentModel.students
        for student in students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinates = CLLocationCoordinate2DMake(lat, long)
            let firstName = student.firstName
            let lastName = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            self.mapView.addAnnotation(annotation)
        }
    }
    
    public func refresh() {
        self.mapView.removeAnnotations(mapView.annotations)
        attachPins()
    }
}

//MARK: - EXTENSION
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let urlString = view.annotation?.subtitle else {
                return
            }
            if UdacityClient.validateUrl(urlString: urlString) {
                let mediaURL = URL(string: urlString!)!
                UIApplication.shared.open(mediaURL, options: [ : ], completionHandler: nil)
            } else {
                let invalidURLAlert = Alerts.errorAlert(title: AlertTitles.invalidURL.rawValue, message: AlertMessages.invalidURLWhenBrowsing.rawValue)
                present(invalidURLAlert, animated: true)
            }
        }
    }
    
}
