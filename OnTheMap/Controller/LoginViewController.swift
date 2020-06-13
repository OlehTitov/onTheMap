//
//  ViewController.swift
//  OnTheMap
//
//  Created by Oleh Titov on 27.05.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - PROPERTIES
    let dismissKeyboard = DismissKeyboardDelegate()
    let emailImage = TextfiedLeftImage.styleLeftImage(imageName: "envelope")
    let passwordImage = TextfiedLeftImage.styleLeftImage(imageName: "lock")
    let signupURL = "https://auth.udacity.com/sign-up"
    let tabBarVCIdentifier = "TabBarViewController"
    let spinner = LoadingIndicator.addSpinner()
    let darkenView = LoadingIndicator.addDarkenView()
    
    //MARK: - OUTLETS
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        hideNavigationBar(hiden: true)
        resetTexfields()
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = dismissKeyboard
        password.delegate = dismissKeyboard
        TextfiedLeftImage.addImage(textField: email, image: emailImage)
        TextfiedLeftImage.addImage(textField: password, image: passwordImage)
        loginTitle.font = FontKit.roundedFont(ofSize: 32, weight: .heavy)
        self.view.addSubview(spinner)
        self.view.addSubview(darkenView)
        spinner.center = self.view.center
    }
    
    //MARK: - VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        hideNavigationBar(hiden: false)
    }

    //MARK: - ACTIONS
    @IBAction func loginButton(_ sender: Any) {
        LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: false)
        LoadingIndicator.rotate(object: spinner)
        UdacityClient.login(username: email.text ?? "", password: password.text ?? "", completion: handleLoginRequest(success:error:))
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let url = URL(string: signupURL)
        UIApplication.shared.open(url!, options: [ : ], completionHandler: nil)
    }
    
    //MARK: - METHODS
    func handleLoginRequest(success: Bool, error: Error?) {
        if success {
            print("Login OK. Account key: \(UdacityClient.Auth.accountKey), session ID: \(UdacityClient.Auth.sessionId)")
            UdacityClient.getPublicUserData(id: UdacityClient.Auth.accountKey, completion: handleGetPublicData(success:error:))
            goToNextVC()
        } else {
            let loginfailedAlert = Alerts.errorAlert(title: AlertTitles.loginFailed.rawValue, message: error?.localizedDescription ?? "")
            self.present(loginfailedAlert, animated: true)
            LoadingIndicator.hideElements(spinner: spinner, darkenView: darkenView, hiden: true)
        }
    }
    
    func handleGetPublicData(success: Bool, error: Error?) {
        if success {
            print("Random name: \(UdacityClient.Auth.firstName) \(UdacityClient.Auth.lastName)")
        } else {
            print("Could not get random dummy name")
        }
    }
    
    func goToNextVC() {
        let tabBarVC = self.storyboard?.instantiateViewController(identifier: tabBarVCIdentifier) as! TabBarViewController
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    func hideNavigationBar(hiden: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func resetTexfields() {
        email.text = ""
        password.text = ""
    }
}

