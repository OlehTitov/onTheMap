//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 05.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    //MARK: - PROPERTIES
    let dismissKeyboard = DismissKeyboardDelegate()
    let addressImage = TextfiedLeftImage.styleLeftImage(imageName: "mappin.and.ellipse")
    let successVC = "ConfirmLocationViewController"
    let spinner = LoadingIndicator.addSpinner()
    let darkenView = LoadingIndicator.addDarkenView()
    
    //MARK: - OUTLETS
    @IBOutlet weak var addLocationTitle: UILabel!
    @IBOutlet weak var addressTextfield: UITextField!
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextfield.delegate = dismissKeyboard
        addLocationTitle.font = FontKit.roundedFont(ofSize: 32, weight: .heavy)
        TextfiedLeftImage.addImage(textField: addressTextfield, image: addressImage)
        navigationController?.isNavigationBarHidden = true
        self.view.addSubview(spinner)
        self.view.addSubview(darkenView)
        spinner.center = self.view.center
    }
    
    //MARK: - ACTIONS
    @IBAction func findLocationButton(_ sender: Any) {
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: false)
        LoadingIndicator.rotate(object: spinner)
        let mapString = addressTextfield.text ?? ""
        CurrentStudent.Location.mapString = mapString
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = mapString
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: handleMapSearch(response:error:))
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - METHODS
    func handleMapSearch(response: MKLocalSearch.Response?, error: Error?) {
        //Show error alert when map search fails and reset textfield
        guard let response = response else {
            let searchFailedAlert = Alerts.errorAlert(title: AlertTitles.searchFailed.rawValue, message: AlertMessages.searchFailed.rawValue)
            self.present(searchFailedAlert, animated: true)
            LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
            self.resetTextfield()
            return
        }
        //Save location and go to next VC if success
        let lat = response.mapItems[0].placemark.coordinate.latitude
        let long = response.mapItems[0].placemark.coordinate.longitude
        let placeName = response.mapItems[0].name ?? ""
        CurrentStudent.Location.latitude = lat
        CurrentStudent.Location.longitude = long
        CurrentStudent.Location.placeName = placeName
        self.showNextVC()
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    func resetTextfield() {
        addressTextfield.text = ""
    }
    
    
    func showNextVC() {
        let ConfirmLocationVC = self.storyboard?.instantiateViewController(identifier: successVC) as! ConfirmLocationViewController
        self.navigationController?.pushViewController(ConfirmLocationVC, animated: true
         )
    }
}
