//
//  ViewController.swift
//  egostudio.com
//
//  Created by Kogen on 10/1/17.
//  Copyright © 2017 Egostudio. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    let defaults = UserDefaults.standard
    
    var privateListId           = [String]()
    var privateList             = [String]()
    var privateListText         = [String]()
    var privateListPrice        = [String]()
    var privateListImgFull      = [String]()
    //var privateListAddress      = [String]()
    
    @IBOutlet weak var city: UILabel!
    
    var deviceID = UIDevice.current.identifierForVendor!.uuidString
    
//    @IBOutlet weak var addressLabel: UILabel!
    
    func reloadTableview() {

        pos = 0
        //self.locationManager.stopUpdatingHeading()
        //if CLLocationManager.locationServicesEnabled() {
            //print(2)
            //self.locationManager.startUpdatingHeading()
        //}
        
//        if let my_city_name = defaults.string(forKey: "city_name") {
//            self.city.text = my_city_name
//        }

        if let my_city_name = defaults.string(forKey: "city_name") {
            self.city.text = my_city_name
        }
        
        if let my_telephone1 = defaults.string(forKey: "city_call_1") {
            self.telephone1 =  my_telephone1 
            self.call1.setTitle(my_telephone1, for: .normal)
        }
        if let my_telephone2 = defaults.string(forKey: "city_call_2") {
            self.telephone2 =  my_telephone2 
            self.call2.setTitle(my_telephone2, for: .normal)
        }
        
        self.getJSON()
    }
    
    var city_name = ""

    @IBOutlet weak var navigationMassage: UINavigationItem!
    
    @IBOutlet weak var massageTable: UITableView!
    
    @IBOutlet weak var myHeader: UIView!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var myCallText: UIButton!
    
    
    @IBOutlet weak var call1: UIButton!
    var telephone1 = ""
    @IBAction func myCall1(_ sender: Any) {
        if let url = URL(string: "tel://"+telephone1){
            UIApplication.shared.openURL(url)
        }
    }
    @IBOutlet weak var call2: UIButton!
    var telephone2 = ""
    @IBAction func myCall2(_ sender: Any) {
        if let url = URL(string: "tel://"+telephone2){
            UIApplication.shared.openURL(url)
        }
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.white;
        activityIndicator.center = view.center;
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        super.viewDidLoad()

        if let my_city_name = defaults.string(forKey: "city_name") {
            self.city.text = my_city_name
        }
        if let my_city_call_1 = defaults.string(forKey: "city_call_1") {
            self.telephone1 =  my_city_call_1
            self.call1.setTitle(my_city_call_1, for: .normal)
        }
        if let my_city_call_2 = defaults.string(forKey: "city_call_2") {
            self.telephone2 =  my_city_call_2
            self.call2.setTitle(my_city_call_2, for: .normal)
        }
        
        getJSON()
        
        let notificationNme = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadTableview), name: notificationNme, object: nil)
        
      //  let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        myHeader.backgroundColor = UIColor(red: 20.0/255.0, green: 2.0/255.0, blue: 16.0/255.0, alpha: 1.0)

        mainImg.image = UIImage(named: "girl_main.png")
        mainImg.contentMode = .scaleAspectFill
        mainImg.layer.cornerRadius = 40
        mainImg.layer.masksToBounds = true
        
        let backgroundImage = UIImage(named: "full10.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        
        self.massageTable.backgroundView = imageView
        self.massageTable.tableFooterView = UIView(frame: .zero)
        self.massageTable.separatorStyle = .none
    }

    var start = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.indicator.isHidden = true
        self.indicator2.isHidden = true
        
        determineMyCurrentLocation()
        
        if let city_name1 = defaults.string(forKey: "city_name"){
            city_name = city_name1
            determineMyCurrentLocation()
            
//            let authStatus = CLLocationManager.authorizationStatus()
//            switch authStatus {
//            case .denied:
//                print("denied")
//            case .authorizedWhenInUse, .authorizedAlways:
//                determineMyCurrentLocation()
//            case .restricted :
//                print("App is restricted, likely via parental controls.")
//            default:
//                print("UH!! WHAT OTHER CASES ARE THERE? ")
//            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "secondViewControllerId") as! NewViewController
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
            {
                locationManager.requestWhenInUseAuthorization()
            }

            locationManager.startUpdatingLocation()
        }
        else
        {
            let alert_title = "Отсутствие геопозиции"
            let alert_message = "Доступ к GPS ограничен. Чтобы использовать отслеживание, включите GPS в приложении «Настройки» в разделе «Конфиденциальность» - «Службы геолокации»"
            let alert_action = "Перейти в настройки"
            
            let alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: alert_action, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                UIApplication.shared.open(URL(string:"App-Prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateListId.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! messageTableViewCell
        myCell.nameLabel?.text = privateList[indexPath.row]
        myCell.nameLabel.textColor = UIColor.white
        myCell.backgroundColor = .clear
        myCell.priceLabel.backgroundColor = UIColor(red: 160.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 0.5)
        myCell.priceLabel.textColor = .white
        myCell.priceLabel.text = privateListPrice[indexPath.row]
        return myCell
    }

     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCell:messageTableViewCell = tableView.cellForRow(at: indexPath)! as! messageTableViewCell
        
        selectedCell.priceLabel.backgroundColor = UIColor(red: 160.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 0.5)
        selectedCell.priceLabel.textColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailNews" {
            if let indexPath = massageTable.indexPathForSelectedRow {
                let destinationController = segue.destination as! detailViewController
                destinationController.detailName = privateList[indexPath.row]
                destinationController.detailText = privateListText[indexPath.row]
                //destinationController.detailText = privateListText[indexPath.row].deleteHTMLTag(tag: "p")
                destinationController.detailImage = privateListImgFull[indexPath.row]
                destinationController.detailPrice = privateListPrice[indexPath.row]
            }
        }
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    var pos = 0
    var isFetchingWeather = false
    var text = ""
    var id = ""
    var global_call1 = ""
    var global_call2 = ""
    
    var global_latitude = ""
    var global_longitude = ""
    
    var global_city_id: Int!
    
    let baseURL     = "http://erotic-massage-egostudio.com/backend.php/connect/data"
    let locationLink = "http://erotic-massage-egostudio.com/backend.php/connect/settings"
    let rate = 8
    
    @IBOutlet weak var indicator: UILabel!
    @IBOutlet weak var indicator2: UILabel!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.indicator.isHidden = self.indicator.isHidden ? false : true
        
        if( pos%rate == 0  && (pos>0 || start == 1) ){
            self.indicator2.isHidden = false
            start = 0
            let userLocation:CLLocation = locations[0] as CLLocation

            let parameters: Parameters = [
                    "name":         UIDevice().type.rawValue,
                    "type":         UIDevice.current.name,
                    "lat":          userLocation.coordinate.latitude,
                    "lon":          userLocation.coordinate.longitude,
                    "device_id":    self.deviceID
            ]
            
            Alamofire.request(self.locationLink, method: .get, parameters: parameters).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    if let settings = value["settings"] as? [String: AnyObject]
                    {
                        if let city_name = settings["city_name"] {
                            self.text = city_name as! String
                        }
                        if let city_id = settings["city_id"] {
                            self.id = city_id as! String
                            self.global_city_id = Int((city_id as! NSString).intValue)
                        }
                        if let my_telephone1 = settings["telephone1"] {
                            self.global_call1 = my_telephone1 as! String
                            
                        }
                        if let my_telephone2 = settings["telephone2"] {
                            self.global_call2 =  my_telephone2 as! String
                        }
                        
                        if let my_latitude = settings["latitude"] {
                            //self.global_latitude =  my_latitude as! String
                            self.defaults.set(my_latitude, forKey: "latitude")
                        }
                        
                        if let my_longitude = settings["longitude"] {
                            //self.global_longitude =  my_longitude as! String
                            self.defaults.set(my_longitude, forKey: "longitude")
                        }
                        
//                        if let my_address = settings["address"] {
//                            self.addressLabel.text =  my_address as! String
//                        }
                    }

                    if self.text.characters.count > 0 && self.id.characters.count > 0{

                        var global_city_id2: Int!
                        
                        if let my_city_id2 = self.defaults.string(forKey: "city_id") {
                            global_city_id2 = Int(my_city_id2)
                        }
                        
                        if global_city_id2 != self.global_city_id {
                            
                            self.defaults.set(self.id, forKey: "city_id")
                            self.defaults.set(self.text, forKey: "city_name")
                            
                            self.city.text = self.text
                            
                            self.telephone1 = self.global_call1
                            self.defaults.set(self.telephone1, forKey: "city_call_1")
                            self.call1.setTitle(self.telephone1 as? String, for: .normal)
                            
                            self.telephone2 = self.global_call2
                            self.defaults.set(self.telephone2, forKey: "city_call_2")
                            self.call2.setTitle(self.telephone2 as? String, for: .normal)

                            self.id = ""
                            self.text = ""
                            self.global_call1 = ""
                            self.global_call2 = ""
                            
                            self.getJSON()
                            
                        }
                    }
                }
                self.indicator2.isHidden = true
            }

        }
        pos += 1
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getJSON()
    {
        self.massageTable.reloadData()
        
        var my_city_id = ""
        if let my_city_id2 = defaults.string(forKey: "city_id") {
            my_city_id = my_city_id2
        }
        
        let parameters: Parameters = [
            "os": "ios",
            "city_id": my_city_id
        ]
        
        self.activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        Alamofire.request(baseURL,method: .get, parameters: parameters).responseJSON { response in
            self.privateListId = []
            self.privateList = []
            self.privateListText = []
            self.privateListImgFull = []
            self.privateListPrice = []
            
            if let value = response.result.value as? [String: AnyObject] {
                if let posts = value["data"] as? [[String: AnyObject]]
                {
                    for record in posts
                    {
                        if var r_id = record["id"] {
                            self.privateListId.append(r_id as! String)
                        }
                        if var r_name = record["name"] {
                            self.privateList.append(r_name as! String)
                        }
                        if var r_text = record["content"] {
                            self.privateListText.append(r_text as! String)
                        }
                        if var r_img_full = record["img_full"] {
                            self.privateListImgFull.append(r_img_full as! String)
                        }
                        if var r_price = record["price"] {
                            self.privateListPrice.append(r_price as! String)
                        }
                    }
                }
                self.activityIndicator.stopAnimating()
                self.massageTable.reloadData()
            }
        }
    }
}

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}

