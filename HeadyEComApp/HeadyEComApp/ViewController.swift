//
//  ViewController.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/30/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserName.text = "Test"
        txtPassword.text = "Test123"
    }

    @IBAction func onClickBtnLogin(_ sender: Any) {
        let activityView = getAcitivtyIndicator()
        self.showActivityIndicator(activityView: activityView)
        
            EComAPI.getEComResponse { (data, error ) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: (error?.message)!)
                        self.hideAcitivityIndicator(activityView: activityView)
                    }
                    return
                }
                EComUtil.updateDatacontroller(data: data)
                EComDataController.sharedController.isLoggedIn = true
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.hideAcitivityIndicator(activityView: activityView)
                }
            }
    }
}
