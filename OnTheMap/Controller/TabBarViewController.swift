//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 02.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: - PROPERTIES
    let darkenView = LoadingIndicator.addDarkenView()
    let spinner = LoadingIndicator.addSpinner()
    let addLocationVCIdentifier = "AddLocationViewController"
    
    //MARK: - OUTLETS
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.view.addSubview(darkenView)
        self.view.addSubview(spinner)
        spinner.center = self.view.center
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    //MARK: - ACTIONS
    @IBAction func refreshButton(_ sender: Any) {
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: false)
        LoadingIndicator.rotate(object: spinner)
        UdacityClient.getStudentLocation(limit: "100", order: "-", completion: handleRefreshStudents(students:error:))
    }
    
    @IBAction func addStudentLocationButton(_ sender: Any) {
        //Check if student has already submitted the location and present alert with 2 options
        if UdacityClient.Auth.initialSubmit == true {
            let alert = Alerts.errorAlert(title: AlertTitles.repeatedSubmission.rawValue, message: AlertMessages.repeatedSubmission.rawValue, cancelButton: true) {
                self.goToNextVC()
            }
            present(alert, animated: true)
        } else {
            goToNextVC()
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: false)
        UdacityClient.logout(completion: handleLogout(success:response:error:))
    }
    
    //MARK: - METHODS
    func handleRefreshStudents(students: [StudentInformation], error: Error?) {
        if let error = error {
            let alert = Alerts.errorAlert(title: AlertTitles.refreshFailed.rawValue, message: error.localizedDescription)
            present(alert, animated: true)
        } else {
            StudentModel.students = students
        }
        
        for childVC in self.children {
            if let mapVC = childVC as? MapViewController {
                mapVC.refresh()
            }
            else if let tableVC = childVC as? StudentsListTableViewController {
                tableVC.refresh()
            }
        }
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    func handleLogout(success: Bool, response: HTTPURLResponse?, error: Error?) {
        guard let response = response else {
            return
        }
        print("Logout response is \(response.statusCode)")
        if response.statusCode == 200 {
            UdacityClient.Auth.accountKey = ""
            UdacityClient.Auth.sessionId = ""
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            DispatchQueue.main.sync {
                let logoutAlert = Alerts.errorAlert(title: AlertTitles.logoutFailed.rawValue, message: error?.localizedDescription ?? "")
                self.present(logoutAlert, animated: true)
                LoadingIndicator.hideElements(spinner: self.spinner, darkenView: self.darkenView, hiden: true)
            }
        }
    }
    
    func goToNextVC() {
        let addLocationVC = self.storyboard?.instantiateViewController(identifier: addLocationVCIdentifier) as! AddLocationViewController
        self.navigationController?.pushViewController(addLocationVC, animated: true)
    }
    
}
