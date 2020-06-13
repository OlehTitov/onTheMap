//
//  LocationAddedSuccessfullyVC.swift
//  OnTheMap
//
//  Created by Oleh Titov on 07.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

class LocationAddedSuccessfullyVC: UIViewController {
    
    //MARK: - PROPERTIES
    let tabBarVCIdentifier = "TabBarViewController"
    
    //MARK: - OUTLETS
    @IBOutlet weak var successTitle: UILabel!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        successTitle.font = FontKit.roundedFont(ofSize: 32, weight: .heavy)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - ACTIONS
    @IBAction func okButton(_ sender: Any) {
        showTabVC()
    }
    
    //MARK: - METHODS
    func showTabVC() {
        let tabBarVC = self.storyboard?.instantiateViewController(identifier: tabBarVCIdentifier) as! TabBarViewController
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
}
