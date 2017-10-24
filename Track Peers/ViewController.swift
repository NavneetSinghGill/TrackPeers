//
//  ViewController.swift
//  Track Peers
//
//  Created by Navneet on 10/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    var camera: GMSCameraPosition?
    var bearingAngleRadians: CGFloat = 0 //Map rotation angle
    
    //User specific
    var myMarker: UserMarker? // SubClass of GMSMarker
    var myPreviousCoordinate: CLLocationCoordinate2D?
    var myCurrentCoordinate: CLLocationCoordinate2D?
    var myLatestLocation: CLLocation?
//    var locations: [CLLocationCoordinate2D] = [] //User it for store users location
    var currentUserPath = GMSMutablePath()
    var currentUserPolyline: GMSPolyline?

    //Friends specific
    var friendsMarkers: [UserMarker] = []
    var selectedMarker: UserMarker?
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//
//    }
//    override func loadView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 0.002
        locationManager.startUpdatingLocation()
        
        // Create a GMSCameraPosition that tells the map to display the
        camera = GMSCameraPosition()//.camera(withLatitude: 22.75042399427852, longitude: 75.895100645720959, zoom: 15.0)
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera!)
        mapView.camera = camera!
        mapView.delegate = self
//        mapView.isTrafficEnabled = true
//        view = mapView
        self.mapView.isMyLocationEnabled = true
//        self.mapView.mapType = .satellite
        
        // Creates a marker in the center of the map.
        myMarker = UserMarker()
        let image = UIImage(named: "marker")
        let markerImageView = UIImageView(image: image)
        Global.fill(color: UIColor.red, inImageView: markerImageView)
        markerImageView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        myMarker?.iconView = markerImageView
        myMarker?.position = CLLocationCoordinate2D(latitude: 22.75042399427852, longitude: 75.895100645720959)
        myCurrentCoordinate = myMarker?.position
        myMarker?.title = "Indore"
        myMarker?.snippet = "India"
        myMarker?.map = mapView
        myMarker?.iconView?.bounds = CGRect(x: 0, y: (myMarker?.iconView?.bounds.size.height)!/2, width: (myMarker?.iconView?.bounds.size.width)!, height: (myMarker?.iconView?.bounds.size.height)!)
        
//        locations.append(CLLocationCoordinate2D(latitude: 22.75042399427852, longitude: 75.895100645720959))
//        locations.append(CLLocationCoordinate2D(latitude: 22.750322888780673, longitude: 75.895100645720959))
//        locations.append(CLLocationCoordinate2D(latitude: 22.750199212228981, longitude: 75.895088240504265))
//        locations.append(CLLocationCoordinate2D(latitude: 22.750120677560535, longitude: 75.89503962546587))
//        locations.append(CLLocationCoordinate2D(latitude: 22.750059148399007, longitude: 75.895049013197422))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749955259902574, longitude: 75.895054377615452))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749890947936635, longitude: 75.895011462271214))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749801900549183, longitude: 75.894984640181065))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749722747267178, longitude: 75.894968546926975))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749643593939336, longitude: 75.894930996000767))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749574334739847, longitude: 75.894904173910618))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749460551693062, longitude: 75.894866622984409))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749381398213327, longitude: 75.894823707640171))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749277509201576, longitude: 75.894796885550022))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749208249816537, longitude: 75.894786156713963))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749143937498992, longitude: 75.894764699041843))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749020259880162, longitude: 75.894694961607456))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749010365665814, longitude: 75.894684232771397))
//        locations.append(CLLocationCoordinate2D(latitude: 22.749017786326654, longitude: 75.894614495337009))
        
        
        currentUserPolyline = GMSPolyline(path: currentUserPath)
        currentUserPolyline?.strokeWidth = 2
        currentUserPolyline?.strokeColor = loggedInUserPathColor
        currentUserPolyline?.map = mapView
        
        addMarkers(of: Friend.friendsWithFakeLocations(),shouldClearOldData: true)
    }
    
    //MARK: - GMS delegate methods
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isSimulator {
            myMarker?.position = coordinate
            myPreviousCoordinate = myCurrentCoordinate
            myCurrentCoordinate = coordinate
            
            resetRouteFor(marker: selectedMarker)
            followSelectedFriendsMarker()
        }
        
        print("coordinate: \(coordinate)")
    }
    
    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        myPreviousCoordinate = myCurrentCoordinate
       myCurrentCoordinate = coordinate
        
        UIView.animate(withDuration: 0.3) {
            self.myMarker?.updateBaseAngleWith(baseAngle: self.getRadiansOfMarkerRotationWhenMoved(from: self.myPreviousCoordinate!, to: self.myCurrentCoordinate!))
            self.myMarker?.updateBearingWith(bearing: self.bearingAngleRadians)
            self.myMarker?.position = coordinate
        }
        currentUserPath.add(coordinate)
        currentUserPolyline = GMSPolyline(path: currentUserPath)
        currentUserPolyline?.strokeWidth = 2
        currentUserPolyline?.strokeColor = loggedInUserPathColor
        currentUserPolyline?.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        showAlertActions(for: marker as? UserMarker)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Will move gesture: \(gesture)")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        bearingAngleRadians = CGFloat((360 - position.bearing))/(180/CGFloat.pi)
        self.myMarker?.updateBearingWith(bearing: bearingAngleRadians)
        print("Will change position: \(position)")
    }
    
    //MARK: MAPKit methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        //TODO: This will be used in real for updating the true location
        //        currentUserPath.add((locations.last?.coordinate)!)
        //        polyline = GMSPolyline(path: currentUserPath)
        //        polyline?.strokeWidth = 2
        //        polyline?.strokeColor = loggedInUserPathColor
        //        polyline?.map = mapView
        
        myLatestLocation = locations.last
        if isSimulator {
            camera = GMSCameraPosition.camera(withLatitude: 22.75042399427852, longitude: 75.895100645720959, zoom: 15.0)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: (myLatestLocation?.coordinate.latitude)!, longitude: (myLatestLocation?.coordinate.longitude)!, zoom: 15.0)
            myMarker?.position = (myLatestLocation?.coordinate)!
            myPreviousCoordinate = myCurrentCoordinate
            myCurrentCoordinate = (myLatestLocation?.coordinate)!
            
            resetRouteFor(marker: selectedMarker)
            followSelectedFriendsMarker()
        }
        mapView.camera = camera!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK: - Custom methods
    
    func showAlertActions(for marker: UserMarker?) {
        let alertController = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        let showOneDayRoute = UIAlertAction(title: "Show one day route", style: .default) { (action) in
            self.resetRouteFor(marker: self.selectedMarker)
            self.selectedMarker = marker
            
        }
        let showRoutine = UIAlertAction(title: "Show routine", style: .default) { (action) in
            self.resetRouteFor(marker: self.selectedMarker)
            self.selectedMarker = marker
            
        }
        let follow: UIAlertAction!
        if marker == selectedMarker {
            follow = UIAlertAction(title: "Stop following", style: .destructive) { (action) in
                self.resetRouteFor(marker: self.selectedMarker)
                self.selectedMarker = nil
            }
        } else {
            follow = UIAlertAction(title: "Follow", style: .default) { (action) in
                self.resetRouteFor(marker: self.selectedMarker)
                self.selectedMarker = marker
                self.followSelectedFriendsMarker()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(showRoutine)
        alertController.addAction(showOneDayRoute)
        alertController.addAction(follow)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getRadiansOfMarkerRotationWhenMoved(from startingPoint: CLLocationCoordinate2D, to endingPoint: CLLocationCoordinate2D) -> CGFloat {
        let distanceDifferences = CGPoint(x: endingPoint.longitude - startingPoint.longitude, y: endingPoint.latitude - startingPoint.latitude)
        
        let radianAngle: CGFloat = CGFloat(-atan2f(Float(Double(distanceDifferences.y)), Float(Double(distanceDifferences.x))))
        print("radian angle: \(radianAngle), bearing: \(bearingAngleRadians)")
        return radianAngle
    }
    
    func drawRoute(fromLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.741162791314817, longitude: 75.892375521361828), toLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.752719409058209, longitude: 75.888148359954357)) {
    
        let originLocation: CLLocation = CLLocation(latitude: fromLocation.latitude, longitude: fromLocation.longitude)
        let destinationLocation: CLLocation = CLLocation(latitude: toLocation.latitude, longitude: toLocation.longitude)
    
        DispatchQueue.main.async {
            self.fetchPolylineWithOrigin(origin: originLocation, destination: destinationLocation) { (toUserPolyline) in
                if toUserPolyline != nil {
                    DispatchQueue.main.async {
                        toUserPolyline?.map = self.mapView
                        self.selectedMarker?.followPolyline = toUserPolyline
                    }
                }
            }
        }
    }
    
    func fetchPolylineWithOrigin(origin: CLLocation, destination: CLLocation, completionHandler: @escaping ((_ polyline: GMSPolyline?) -> Void)) {
        let originString = "\(origin.coordinate.latitude),\(origin.coordinate.longitude)"
        let destinationString = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
        let directionsUrlString = "\(directionsAPI)&origin=\(originString)&destination=\(destinationString)&mode=driving"
        let directionsUrl = URL(string: directionsUrlString)
        
        let request = URLRequest(url: directionsUrl!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                if (error != nil) {
                    completionHandler(nil)
                    return
                }
                
                let routesArray: Array<AnyObject> = (json as! Dictionary<String, AnyObject>)["routes"] as! Array<AnyObject>
                var polyline: GMSPolyline? = nil
                
                if routesArray.count > 0 {
                    let routeDict: Dictionary<String,AnyObject> = routesArray[0] as! Dictionary<String, AnyObject>
                    let routeOverviewPolyline: Dictionary<String, AnyObject> = routeDict["overview_polyline"] as! Dictionary<String, AnyObject>
                    let points: String = routeOverviewPolyline["points"] as! String
                    let path: GMSPath = GMSPath(fromEncodedPath: points)!
                    polyline = GMSPolyline(path: path)
                    polyline?.strokeWidth = 2
                    polyline?.strokeColor = loggedInUserPathColor
                }
                
                DispatchQueue.main.async {
                    completionHandler(polyline)
                }
            } catch _ {
                
                }
                
            }
        }
        
        task.resume()
    }
    
    func followSelectedFriendsMarker() {
        if selectedMarker != nil {
            drawRoute(fromLocation: CLLocationCoordinate2D(latitude: (myCurrentCoordinate?.latitude)!, longitude: (myCurrentCoordinate?.longitude)!), toLocation: CLLocationCoordinate2D(latitude: (selectedMarker?.position.latitude)!, longitude: (selectedMarker?.position.longitude)!))
        }
    }
    
    func resetRouteFor(marker: UserMarker?) {
        if marker != nil {
            marker?.followPolyline?.map = nil
            marker?.followPolyline = nil
        }
    }
    
    func addMarkers(of friends:[Friend], shouldClearOldData: Bool) {
        if shouldClearOldData {
            remove(markers: self.friendsMarkers)
        }
        
        for friend in friends {
            let image = UIImage(named: "marker")
            let markerImageView = UIImageView(image: image)
            markerImageView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            let friendMarker: UserMarker = UserMarker()
            friendMarker.iconView = markerImageView
            friendMarker.position = friend.lastLocation!
//            friendMarker.title = "Indore"
//            friendMarker.snippet = "India"
            friendMarker.map = mapView
            friendMarker.iconView?.bounds = CGRect(x: 0, y: (friendMarker.iconView?.bounds.size.height)!/2, width: (friendMarker.iconView?.bounds.size.width)!, height: (friendMarker.iconView?.bounds.size.height)!)
            friendMarker.friend = friend
            
            friendsMarkers.append(friendMarker)
        }
    }
    
    func remove(markers: [UserMarker]) {
        for marker in markers {
            if friendsMarkers.index(of: marker) != Int.max {
                marker.map = nil
                marker.iconView = nil
                friendsMarkers.remove(at: friendsMarkers.index(of: marker)!)
            }
        }
    }
    
    
}

