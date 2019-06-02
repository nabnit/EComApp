//
//  RankingViewController.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/31/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import UIKit
class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var rankingList = [RankModel]()
    @IBOutlet weak var tblRankList: UITableView!
    
    //Deletes the local cache and invokes the API to get latest data
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
                self.tblRankList.reloadData()
                self.hideAcitivityIndicator(activityView: activityView)
            }
        }
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        self.logout()
    }
    
    // UIView life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rankingList = EComDataController.sharedController.rankingList
    }
    
    // Table view Delegates and Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return rankingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = rankingList[section].products?.count {
            return rowCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        
        if let obj = rankingList[indexPath.section].products?[indexPath.row], let id = obj.id {
            
            // Get the product from the product id
            let prodObj = EComUtil.getProductWithId(id)
            
            cell.textLabel?.text = prodObj?.name
            var categoryLabel = ""
            switch rankingList[indexPath.section].ranking {
            case EComAPI.EComRanking.mostViewed.rawValue:
                categoryLabel = EComConstants.viewCountLabel
            case EComAPI.EComRanking.mostOrdered.rawValue:
                categoryLabel = EComConstants.orderCountLabel
            case EComAPI.EComRanking.mostShared.rawValue:
                categoryLabel = EComConstants.sharesLabel
            default:
                break
            }
            
            if let catVal = obj.categoryValue {
                cell.detailTextLabel?.text = "\(categoryLabel): \(catVal)"
            }

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return EComDataController.sharedController.rankingList[section].ranking.uppercased()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "VariantsListViewController") as? VariantsListViewController {
            if let obj = rankingList[indexPath.section].products?[indexPath.row] {
                if let prodObj = EComUtil.getProductWithId(obj.id!) {
                    controller.variantList = prodObj.variants
                    controller.productName = prodObj.name
                    controller.tax = prodObj.tax.value!
                    controller.taxName = prodObj.tax.name
                }
                
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

