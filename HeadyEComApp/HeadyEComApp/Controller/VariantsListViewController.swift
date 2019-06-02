//
//  VariantsListViewController.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/31/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import UIKit
class VariantsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var variantList: [VariantModel] = [VariantModel]()
    var productName = ""
    var tax: Double = 0.0
    var taxName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = productName.capitalized
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return variantList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VariantTableViewCell {
            let listCount = variantList.count
            if listCount > indexPath.row {
                let obj = variantList[indexPath.row]
                if let size = obj.size {
                    cell.lblSize.text = "Size: \(String(size))"
                }
                else {
                    cell.lblSize.isHidden = true
                }
                if obj.color != "" {
                    cell.lblColor.text = "Color: \(obj.color)"
                }
                else {
                    cell.lblColor.isHidden = true
                }
                if let price = obj.price {
                    cell.lblPrice.text = "Price: \(String(price))"
                }
                else {
                    cell.lblPrice.isHidden = true
                }
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame: CGRect = tableView.frame

        
        let lblHeader = UILabel(frame: CGRect(x: 20, y: 10, width: 150, height: 40))
        lblHeader.text = "Tax (\(taxName)): \(tax)"
        
        let headerView: UIView = UIView(frame: CGRect(x:0, y:0, width:frame.size.width, height: 60.0))
        headerView.backgroundColor = UIColor(red: 217.0/255, green: 217.0/255, blue: 217.0/255, alpha: 1.0)

        headerView.addSubview(lblHeader)
        return headerView
    }
    
}
