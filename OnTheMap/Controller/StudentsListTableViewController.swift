//
//  StudentsListTableViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 09.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

class StudentsListTableViewController: UITableViewController {
    
    let cellIdentifier = "StudentCell"
    let spinner = LoadingIndicator.addSpinner()
    let darkenView = LoadingIndicator.addDarkenView()
    
    @IBOutlet var studentsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.studentsTableView.reloadData()
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableBackground = UIImageView(image: UIImage(named: "background"))
        studentsTableView.backgroundView = tableBackground
        //Pull to refresh
        studentsTableView.refreshControl = UIRefreshControl()
        studentsTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        self.view.addSubview(spinner)
        self.view.addSubview(darkenView)
        spinner.center = self.view.center
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentsTableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let student = StudentModel.students[indexPath.row]
        if student.firstName == "" {
            cell.textLabel?.text = "No name specified"
        } else {
            cell.textLabel?.text = "\(student.firstName)  \(student.lastName)"
        }
        let urlString = student.mediaURL
        if UdacityClient.validateUrl(urlString: urlString) {
            cell.detailTextLabel?.text = urlString
        } else {
            cell.detailTextLabel?.text = "Invalid URL"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.students[indexPath.row]
        let urlString = student.mediaURL
        if UdacityClient.validateUrl(urlString: urlString) {
            let mediaURL = URL(string: urlString)!
            UIApplication.shared.open(mediaURL, options: [ : ], completionHandler: nil)
        } else {
            let invalidURLAlert = Alerts.errorAlert(title: AlertTitles.invalidURL.rawValue, message: AlertMessages.invalidURLWhenBrowsing.rawValue)
            present(invalidURLAlert, animated: true)
        }
    }
    
    @objc func handleRefreshControl() {
       // Update the content
        UdacityClient.getStudentLocation(limit: "100", order: "-") { (students, error) in
            StudentModel.students = students
        }
        self.studentsTableView.reloadData()
       // Dismiss the refresh control
       DispatchQueue.main.async {
          self.studentsTableView.refreshControl?.endRefreshing()
       }
    }
    
    public func refresh() {
        if self.studentsTableView != nil {
            self.studentsTableView.reloadData()
        }
        
    }
}
