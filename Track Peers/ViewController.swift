//
//  ViewController.swift
//  Track Peers
//
//  Created by Navneet on 10/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {

    var mapView: GMSMapView!
    var logiTextField: UITextField!
    var latiTextField: UITextField!
    var currentMarker: GMSMarker?
    var previousCoordinate: CLLocationCoordinate2D?
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 22.7533, longitude: 75.8937, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.isTrafficEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        currentMarker = GMSMarker()
        let image = UIImage(named: "car")
        let markerImageView = UIImageView(image: image)
        markerImageView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        currentMarker?.iconView = markerImageView
        currentMarker?.position = CLLocationCoordinate2D(latitude: 22.7533, longitude: 75.8937)
        currentCoordinate = currentMarker?.position
        currentMarker?.title = "Indore"
        currentMarker?.snippet = "India"
        currentMarker?.map = mapView
        
//        let widthOfTextField: CGFloat = 100
//        let heightOfTextField: CGFloat = 40
//        latiTextField = UITextField(frame: CGRect(x: 0, y: screenHeight - heightOfTextField - 20, width: widthOfTextField, height: heightOfTextField))
//        view.addSubview(latiTextField)
//        view.bringSubview(toFront: latiTextField)
    }
    
    //MARK: GMS delegate methods
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        previousCoordinate = currentCoordinate
        currentCoordinate = coordinate
        
        UIView.animate(withDuration: 0.3) {
            self.currentMarker?.iconView?.transform = self.getTransformRotationAngleWhenMoved(from: self.previousCoordinate!, to: self.currentCoordinate!)
            self.currentMarker?.position = coordinate
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Will move gesture: \(gesture)")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("Will change position: \(position)")
    }
    
    func getTransformRotationAngleWhenMoved(from startingPoint: CLLocationCoordinate2D, to endingPoint: CLLocationCoordinate2D) -> CGAffineTransform {
        let distanceDifferences = CGPoint(x: endingPoint.longitude - startingPoint.longitude, y: endingPoint.latitude - startingPoint.latitude)
        
        let radianAngle: CGFloat = CGFloat(-atan2f(Float(Double(distanceDifferences.y)), Float(Double(distanceDifferences.x))))
        return CGAffineTransform(rotationAngle: radianAngle)
    }

}

