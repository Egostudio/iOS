//
//  MapViewController.swift
//  egostudio.com
//
//  Created by Kogen on 1/30/18.
//  Copyright © 2018 Egostudio. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapkitView: MKMapView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var locationManager = CLLocationManager()
    
    let defaults = UserDefaults.standard

    var global_latitude: Double = 0.0
    var global_longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let my_latitude = defaults.string(forKey: "latitude") {
            self.global_latitude = Double(my_latitude)!
        }
        if let my_longitude = defaults.string(forKey: "longitude") {
            self.global_longitude = Double(my_longitude)!
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(backAction))

        mapkitView.delegate = self
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let sourceCoordinates = locationManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(self.global_latitude, self.global_longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)

        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            
            response, error in
            guard let response = response else {
                if let error = error {
                    print("Wrong")
                }
                return
            }
    
            let route = response.routes[0]
            self.mapkitView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapkitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
            //self.mapkitView.mapType = .hybrid

            let annotation = MKPointAnnotation()
            annotation.subtitle = "Массажный салон"
            annotation.title = "EgoStudio"
            annotation.coordinate = CLLocationCoordinate2DMake(self.global_latitude, self.global_longitude)
            self.mapkitView.addAnnotation(annotation)
        })
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            mapkitView.mapType = .standard
        case 1:
            mapkitView.mapType = .satelliteFlyover
        case 2:
            mapkitView.mapType = .hybridFlyover
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let reuseId = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView?.isEnabled = true
            
            let btn = UIButton()
            annotationView?.rightCalloutAccessoryView = btn

        }
        else {
            annotationView!.annotation = annotation
        }
     
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    

    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
