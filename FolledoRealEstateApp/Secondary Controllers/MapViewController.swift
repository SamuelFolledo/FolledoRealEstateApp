//
//  MapViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/26/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewDelegate { //RE ep.64 5mins for done tapped
    func didFinishWith(coordinate: CLLocationCoordinate2D) //RE ep.64 5mins
}


class MapViewController: UIViewController, UIGestureRecognizerDelegate { //RE ep.63 0mins //RE ep.63 9mins gesture recognizer is added
    
    var pinCoordinates:CLLocationCoordinate2D? //RE ep.63 7mins
    var delegate: MapViewDelegate? //RE ep.64 6mins
    
    
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView! //RE ep.63 5mins
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTouch)) //RE ep.63 7mins gesture recognizer for long press
        gestureRecognizer.delegate = self //RE ep.63 8mins
        mapView.addGestureRecognizer(gestureRecognizer) //RE ep.63 9mins add this gesture recognizer to our map view
        
        
        var region = MKCoordinateRegion() //RE ep.64 1min
        region.center.latitude = 40.731290 //RE ep.64 2mins
        region.center.longitude = -74.064150 //RE ep.64 2mins latlong of journal
        region.span.latitudeDelta = 50 //RE ep.64 3mins
        region.span.longitudeDelta = 50 //RE ep.64 3mins how wide the span is
        mapView.setRegion(region, animated: true) //RE ep.64 4mins
        
    }
    
    
//MARK: Helpers
    @objc func handleLongTouch(gestureRecognizer: UILongPressGestureRecognizer) { //RE ep.63 10mins
        if gestureRecognizer.state == .began { //RE ep.63 11mins register when the state just began
            let location = gestureRecognizer.location(in: mapView) //RE ep.63 11mins access the location of the long press from the mapView
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView) //RE ep.63 12mins convert location coordinate from mapView
             //RE ep.63 13mins//drop pin from coordinates we received
            dropPin(coordinate: coordinates) //RE ep.63 15mins
        }
    }
    
    func dropPin(coordinate: CLLocationCoordinate2D) { //RE ep.63 13mins drop a pin and also only allow only 1 pin
        mapView.removeAnnotations(mapView.annotations) //RE ep.63 14mins remove all annotations from the mapView
        
        pinCoordinates = coordinate //RE ep.63 14mins update our global variable coordinates
        let annotation = MKPointAnnotation() //RE ep.63 15mins
        annotation.coordinate = coordinate //RE ep.63 15mins give the annotation's coordinate to our coordinate
        self.mapView.addAnnotation(annotation) //RE ep.63 15mins drops the pin to our dorpView
        
    }
    
    
    
//MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: Any) { //RE ep.63 5mins
        if mapView.annotations.count == 1 && pinCoordinates != nil { //RE ep.64 6mins check if we have 1 annotation and if we have the coordinates
            delegate!.didFinishWith(coordinate: self.pinCoordinates!) //RE ep.64 8mins
            self.dismiss(animated: true, completion: nil) //RE ep.64 8mins
        } else { //RE ep.64 6mins if there's any pin != 1
            self.dismiss(animated: true, completion: nil) //RE ep.64 7mins
        }
    } //RE ep.64 7mins IMPORTANT to make sure the VC's mapView's delegate = self
    
    @IBAction func cancelButtonTapped(_ sender: Any) { //RE ep.63 5mins
        self.dismiss(animated: true, completion: nil) //RE ep.63 6mins
    }
    
}
