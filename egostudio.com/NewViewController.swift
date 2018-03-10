//
//  NewViewController.swift
//  egostudio.com
//
//  Created by Kogen on 12/7/17.
//  Copyright © 2017 Egostudio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var addCity: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let defaults = UserDefaults.standard
    
    var privateListId         = [String]()
    var privateList         = [String]()
    var privateListCall1         = [String]()
    var privateListCall2         = [String]()
    
    var baseURL = "http://erotic-massage-egostudio.com/backend.php/connect/cities"
    
    @IBAction func dismissPopup(_ sender: Any) {
        let notificationNme = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.post(name: notificationNme, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var global_city_id: Int!
        if let my_city_id2 = self.defaults.string(forKey: "city_id") {
            global_city_id = Int(my_city_id2)
        }
        if !(global_city_id != nil) {
            closeButton.isHidden = true
        }
        else{
            closeButton.isHidden = false
        }
        
        getJSON()
        
        //        pickerView.selectRow(3, inComponent: 0, animated: true)
        
        pickerView.backgroundColor = UIColor(red: 20.0/255.0, green: 2.0/255.0, blue: 16.0/255.0, alpha: 1.0)
        pickerView?.layer.borderColor = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
        pickerView?.layer.borderWidth = 0.5
        pickerView?.layer.cornerRadius = 6.0
        pickerView?.layer.masksToBounds = true
        
        addCity.isHidden = true
        if let my_city_name_default = self.defaults.string(forKey: "city_name") {
            addCity.isHidden = false
            addCity.setTitle(my_city_name_default,for: .normal)
        }
        
        //pickerView.tintColor = UIColor.white
        let tgr = UITapGestureRecognizer(target:self,action:#selector(tap(_:)))
        
        self.pickerView.addGestureRecognizer(tgr)
        //pickerView.addGestureRecognizer(tgr)
        
        addCity.layer.cornerRadius = 5
        addCity?.layer.borderWidth = 0.7
        addCity.layer.borderColor = UIColor.white.cgColor
        
        city.backgroundColor = UIColor(white: 1, alpha: 0)
        city?.layer.borderColor = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
    }


    func tap(_ sender:UITapGestureRecognizer) {
        print("Tapped!")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return privateList.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.view(forRow: row, forComponent: component)?.backgroundColor = UIColor.white
        
        //        attributedString = NSAttributedString(string: "Two"), attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        
        addCity.isHidden = false
        addCity.setTitle(privateList[row],for: .normal)
        defaults.set(privateList[row], forKey: "city_name")
        defaults.set(privateListId[row], forKey: "city_id")
        defaults.set(privateListCall1[row], forKey: "city_call_1")
        defaults.set(privateListCall2[row], forKey: "city_call_2")
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = privateList[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!,NSForegroundColorAttributeName:UIColor.white])
        
        return myTitle
    }

    func getJSON()
    {
        self.privateListId = []
        self.privateList = []
        self.privateListCall1 = []
        self.privateListCall2 = []
        
        //self.activityIndicator.startAnimating()
        //view.addSubview(activityIndicator)
        Alamofire.request(self.baseURL).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                
                if let posts = value["cities"] as? [[String: AnyObject]]
                {
                    for record in posts
                    {
                        if var id = record["city_id"] {
                            self.privateListId.append(id as! String)
                        }
                        if var name = record["city_name"] {
                            self.privateList.append(name as! String)
                        }
                        if var telephone1 = record["telephone1"] {
                            self.privateListCall1.append(telephone1 as! String)
                        }
                        if var telephone2 = record["telephone2"] {
                            self.privateListCall2.append(telephone2 as! String)
                        }
                    }
                    //self.activityIndicator.stopAnimating()
                    self.pickerView.reloadAllComponents()
                }
            }
        }
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
