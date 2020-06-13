//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 06.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
    //MARK: - PROPERTIES
    let dismissKeyboard = DismissKeyboardDelegate()
    let globeImage = TextfiedLeftImage.styleLeftImage(imageName: "globe")
    let spinner = LoadingIndicator.addSpinner()
    let darkenView = LoadingIndicator.addDarkenView()
    let locationAddedVCIdentifier = "LocationAddedSuccessfullyVC"
    let tabBarVCIdentifier = "TabBarViewController"
    var initialSubmit = false
    
    //MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextfield: LoginTextField!
    @IBOutlet weak var pageTitle: UILabel!
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
  
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        urlTextfield.delegate = dismissKeyboard
        TextfiedLeftImage.addImage(textField: urlTextfield, image: globeImage)
        pageTitle.font = FontKit.roundedFont(ofSize: 32, weight: .heavy)
        self.view.addSubview(spinner)
        self.view.addSubview(darkenView)
        spinner.center = self.view.center
        showSearchResults()
    }
    
    //MARK: - ACTIONS
    @IBAction func submitButton(_ sender: Any) {
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: false)
        LoadingIndicator.rotate(object: spinner)
        let mediaURL = urlTextfield.text ?? ""
        let validURL = UdacityClient.validateUrl(urlString: mediaURL)
        if validURL {
            CurrentStudent.Location.mediaURL = mediaURL
            //Check if the student already submitted the location
            if UdacityClient.Auth.initialSubmit == true {
                //Call PUT method
                UdacityClient.updateStudentLocation(completion: handlePostStudentLocation(success:error:))
            } else {
                //Call POST method
                UdacityClient.postStudentLocation(completion: handlePostStudentLocation(success:error:))
            }
        //Show alert about invalid URL
        } else {
            let alert = Alerts.errorAlert(title: AlertTitles.invalidURL.rawValue, message: AlertMessages.invalidURLWhenAdding.rawValue)
            present(alert, animated: true)
            LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        goToTabBarVC()
    }
    
    //MARK: - METHODS
    func handlePostStudentLocation(success: Bool, error: Error?) {
        if success {
            print("Location posted")
            UdacityClient.Auth.initialSubmit = true
            let nextVC = self.storyboard?.instantiateViewController(identifier: locationAddedVCIdentifier) as! LocationAddedSuccessfullyVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let alert = Alerts.errorAlert(title: AlertTitles.failureToPost.rawValue, message: AlertMessages.failureToPost.rawValue)
            present(alert, animated: true)
            print(error ?? "")
        }
    }
    
    func showSearchResults() {
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2DMake(CurrentStudent.Location.latitude, CurrentStudent.Location.longitude)
        let placeName = CurrentStudent.Location.placeName
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        annotation.coordinate = coordinates
        annotation.title = placeName
        self.mapView.setRegion(region, animated: true)
        self.mapView.mapType = .mutedStandard
        self.mapView.addAnnotation(annotation)
    }
    
    func goToTabBarVC() {
        let tabBarVC = self.storyboard?.instantiateViewController(identifier: tabBarVCIdentifier) as! TabBarViewController
        self.navigationController?.pushViewController(tabBarVC, animated: true
         )
    }
}

//MARK: - EXTENSION
extension ConfirmLocationViewController: MKMapViewDelegate {
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
                let alert = Alerts.errorAlert(title: AlertTitles.invalidURL.rawValue, message: AlertMessages.invalidURLWhenBrowsing.rawValue)
                present(alert, animated: true)
            }
        }
    }
}
