//
//  detailViewController.swift
//  egostudio.com
//
//  Created by Kogen on 10/1/17.
//  Copyright © 2017 Egostudio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class detailViewController: UITableViewController {

    @IBOutlet weak var detailViewImage: UIImageView!
    @IBOutlet weak var detailViewName: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var detailPriceView: UILabel!
    
    let defaults = UserDefaults.standard
    
    let col = UIColor(red: 20.0/255.0, green: 2.0/255.0, blue: 16.0/255.0, alpha: 1.0)
    
    //@IBOutlet weak var topConstraint: NSLayoutConstraint!
    var detailName =    ""
    var detailImage =   ""
    var detailText =    ""
    var detailPrice =    ""
    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    
    @IBOutlet weak var call1: UIButton!
    var telephone1 =    ""
    @IBAction func myCall1(_ sender: Any) {
        if let url = URL(string: "tel://"+telephone1){
            UIApplication.shared.openURL(url)
        }
    }
    @IBOutlet weak var call2: UIButton!
    var telephone2 =    ""
    @IBAction func myCall2(_ sender: Any) {
        if let url = URL(string: "tel://"+telephone2){
            UIApplication.shared.openURL(url)
        }
    }
    
    var myHeightImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = detailName
        detailViewName.text = detailName
        //detailViewImage?.image = UIImage(named: detailImage)
        detailTextView.text = detailText
        
        if( detailImage.count > 0 ) {
            let url = URL(string: detailImage)!
            detailViewImage.af_setImage(withURL: url)
        }
        self.detailPriceView.backgroundColor = UIColor(red: 160.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 0.5)
        self.detailPriceView.textColor = .white
        self.detailPriceView.text = detailPrice
        
        if let my_telephone1 = defaults.string(forKey: "city_call_1") {
            telephone1 = my_telephone1
            self.call1.setTitle(my_telephone1 , for: .normal)
        }
        if let my_telephone2 = defaults.string(forKey: "city_call_2") {
            telephone1 = my_telephone2
            self.call2.setTitle(my_telephone2, for: .normal)
        }

        let actualWidth =   detailViewImage.frame.width
        let actualHeight =  detailViewImage.frame.height
        
        let realWidth = UIScreen.main.bounds.width
        let realHeight = realWidth * (actualHeight/actualWidth)
        myHeightImage = Int(realHeight)
        detailViewImage.frame = CGRect(x: 0, y: 0, width: realWidth, height: realHeight)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myCellHeight = 0
        switch indexPath.row {
        case 0:
            myCellHeight = myHeightImage
            break
        case 1:
            myCellHeight = 44
            break
        case 2:
            myCellHeight = 44
            break
        case 3:
            myCellHeight = 300
            break
        default:
            myCellHeight = 44
            break
        }
        
        return CGFloat(myCellHeight)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = col
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = col
        self.cell1.backgroundColor = col
        self.cell2.backgroundColor = col
        self.cell3.backgroundColor = col
        self.cell4.backgroundColor = col
        self.detailViewName.textColor = .white
        
        if let navButtons = self.navigationController?.navigationBar.items {
            if navButtons.count > 0 {
                navButtons[0].title = "Назад"
            }
        }
        
    }

}
