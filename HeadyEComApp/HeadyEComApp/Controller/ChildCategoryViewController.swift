//
//  ChildCategoryViewController.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 6/2/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import UIKit
class ChildCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblChildCategory: UITableView!
    private var categories = [CategoryModel]()
    @IBAction func onClickRefresh(_ sender: Any) {
        EComUtil.deleteCache()
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
                self.tblChildCategory.reloadData()
                self.hideAcitivityIndicator(activityView: activityView)
            }
        }
        
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        self.logout()
    }
    
    //View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categories =  EComDataController.sharedController.categoryList.filter { ($0.childCategory?.count)! > 0 }
        tblChildCategory.reloadData()
    }
    
    // Table view delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].childCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        if let childObj = categories[indexPath.section].childCategory?[indexPath.row] {
            cell.textLabel?.text = String(childObj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name.uppercased()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "VariantsListViewController") as? VariantsListViewController {
            if let prodObj = categories[indexPath.section].products?[indexPath.row] {
                controller.variantList = prodObj.variants
                controller.productName = prodObj.name
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
