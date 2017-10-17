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
    var locations: [CLLocationCoordinate2D] = []
    var bearingAngleRadians: CGFloat = 0
    
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
        currentMarker?.iconView?.layer.borderWidth = 1
        currentMarker?.iconView?.bounds = CGRect(x: 0, y: (currentMarker?.iconView?.bounds.size.height)!/2, width: (currentMarker?.iconView?.bounds.size.width)!, height: (currentMarker?.iconView?.bounds.size.height)!)
        
        locations.append(CLLocationCoordinate2D(latitude: 22.75042399427852, longitude: 75.895100645720959))
        locations.append(CLLocationCoordinate2D(latitude: 22.750322888780673, longitude: 75.895100645720959))
        locations.append(CLLocationCoordinate2D(latitude: 22.750199212228981, longitude: 75.895088240504265))
        locations.append(CLLocationCoordinate2D(latitude: 22.750120677560535, longitude: 75.89503962546587))
        locations.append(CLLocationCoordinate2D(latitude: 22.750059148399007, longitude: 75.895049013197422))
        locations.append(CLLocationCoordinate2D(latitude: 22.749955259902574, longitude: 75.895054377615452))
        locations.append(CLLocationCoordinate2D(latitude: 22.749890947936635, longitude: 75.895011462271214))
        locations.append(CLLocationCoordinate2D(latitude: 22.749801900549183, longitude: 75.894984640181065))
        locations.append(CLLocationCoordinate2D(latitude: 22.749722747267178, longitude: 75.894968546926975))
        locations.append(CLLocationCoordinate2D(latitude: 22.749643593939336, longitude: 75.894930996000767))
        locations.append(CLLocationCoordinate2D(latitude: 22.749574334739847, longitude: 75.894904173910618))
        locations.append(CLLocationCoordinate2D(latitude: 22.749460551693062, longitude: 75.894866622984409))
        locations.append(CLLocationCoordinate2D(latitude: 22.749381398213327, longitude: 75.894823707640171))
        locations.append(CLLocationCoordinate2D(latitude: 22.749277509201576, longitude: 75.894796885550022))
        locations.append(CLLocationCoordinate2D(latitude: 22.749208249816537, longitude: 75.894786156713963))
        locations.append(CLLocationCoordinate2D(latitude: 22.749143937498992, longitude: 75.894764699041843))
        locations.append(CLLocationCoordinate2D(latitude: 22.749020259880162, longitude: 75.894694961607456))
        locations.append(CLLocationCoordinate2D(latitude: 22.749010365665814, longitude: 75.894684232771397))
        locations.append(CLLocationCoordinate2D(latitude: 22.749017786326654, longitude: 75.894614495337009))
        
    }
    
    //MARK: GMS delegate methods
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        previousCoordinate = currentCoordinate
        currentCoordinate = coordinate
        
        UIView.animate(withDuration: 0.3) {
            self.currentMarker?.iconView?.transform = self.getTransformRotationAngleWhenMoved(from: self.previousCoordinate!, to: self.currentCoordinate!)
            self.currentMarker?.position = coordinate
        }
        print("coordinate: \(coordinate)")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        makeMarkerMove()
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Will move gesture: \(gesture)")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        bearingAngleRadians = CGFloat((360 - position.bearing))/(180/CGFloat.pi)
        print("Will change position: \(position)")
    }
    
    func getTransformRotationAngleWhenMoved(from startingPoint: CLLocationCoordinate2D, to endingPoint: CLLocationCoordinate2D) -> CGAffineTransform {
        let distanceDifferences = CGPoint(x: endingPoint.longitude - startingPoint.longitude, y: endingPoint.latitude - startingPoint.latitude)
        
        let radianAngle: CGFloat = CGFloat(-atan2f(Float(Double(distanceDifferences.y)), Float(Double(distanceDifferences.x))))
        print("radian angle: \(radianAngle), bearing: \(bearingAngleRadians)")
        return CGAffineTransform(rotationAngle: radianAngle + bearingAngleRadians)
    }
    
    func makeMarkerMove() {
        for location in locations {
            currentMarker?.position = location
        }
    }

}

