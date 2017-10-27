//
//  ViewController.swift
//  Track Peers
//
//  Created by Navneet on 10/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    let DEFAULT_ZOOM: Float = 15
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var locationDisabledView: UIView!
    var camera: GMSMutableCameraPosition?
    var bearingAngleRadians: CGFloat = 0 //Map rotation angle
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    //User specific
    var me = User()
    var myMarker: UserMarker? // SubClass of GMSMarker
    var myPreviousCoordinate: CLLocationCoordinate2D?
    var myCurrentCoordinate: CLLocationCoordinate2D?
    var myLatestLocation: CLLocation?
//    var locations: [CLLocationCoordinate2D] = [] //User it for store users location
    var currentUserPath: GMSMutablePath?
    var currentUserPolyline: GMSPolyline?
//    var multiPolyline: MultiPolyline?
    
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
        locationManager.desiredAccuracy = 10
        locationManager.startUpdatingLocation()
        
        // Create a GMSCameraPosition that tells the map to display the
        camera = GMSMutableCameraPosition()//.camera(withLatitude: 22.75042399427852, longitude: 75.895100645720959, zoom: 15.0)
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera!)
        camera?.zoom = DEFAULT_ZOOM
        mapView.camera = camera!
        mapView.delegate = self
//        mapView.isTrafficEnabled = true
//        view = mapView
//        self.mapView.isMyLocationEnabled = true
//        self.mapView.mapType = .satellite
        
        // Creates a marker in the center of the map.
        myMarker = UserMarker(user: me)
        let image = UIImage(named: "marker")
        let markerImageView = UIImageView(image: image)
        Global.fill(color: UIColor.red, inImageView: markerImageView)
        markerImageView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        myMarker?.iconView = markerImageView
//        myCurrentCoordinate = myMarker?.position
//        myMarker?.title = "Indore"
//        myMarker?.snippet = "India"
        myMarker?.map = mapView
        myMarker?.iconView?.bounds = CGRect(x: 0, y: (myMarker?.iconView?.bounds.size.height)!/2, width: (myMarker?.iconView?.bounds.size.width)!, height: (myMarker?.iconView?.bounds.size.height)!)
        
//        //On start read the old saved path and update multipolyline
//        if currentUserPath == nil {
//            if UserDefaults.standard.value(forKey: kMyEncodedPath) as? String != nil {
//                currentUserPath = GMSMutablePath(fromEncodedPath: UserDefaults.standard.value(forKey: kMyEncodedPath) as! String)!
//            } else {
                currentUserPath = GMSMutablePath()
//            }
            currentUserPolyline = getPolylineFor(path: currentUserPath)
//        }
        
        addMarkers(of: User.usersWithFakeLocations(),shouldClearOldData: true)
    }
    
    //MARK: - GMS delegate methods
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isSimulator {
            updateMy(locationCoordinate: coordinate)
        }
        
        print("coordinate: \(coordinate)")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker != myMarker {
            showAlertActions(for: marker as? UserMarker)
        }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Will move gesture: \(gesture)")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        For car direction
//        bearingAngleRadians = CGFloat((360 - position.bearing))/(180/CGFloat.pi)
//        self.myMarker?.updateBearingWith(bearing: bearingAngleRadians)
        print("Will change position: \(position)")
    }
    
    //MARK: MAPKit methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if authorizationStatus == .authorizedWhenInUse {
            myLatestLocation = locations.last
            
            camera = GMSMutableCameraPosition.camera(withLatitude: (myLatestLocation?.coordinate.latitude)!, longitude: (myLatestLocation?.coordinate.longitude)!, zoom: (camera?.zoom)!)
            
            mapView.camera = camera!
            updateMy(locationCoordinate: (myLatestLocation?.coordinate)!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse { // if location is enabled
            //TODO: If location is re-enabled the show position
            locationDisabledView.isHidden = true
        } else if status == .denied { // if denied to use the location
            locationDisabledView.isHidden = false
        }
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
    
//        For car direction
    func getRadiansOfMarkerRotationWhenMoved(from startingPoint: CLLocationCoordinate2D, to endingPoint: CLLocationCoordinate2D) -> CGFloat {
        let distanceDifferences = CGPoint(x: endingPoint.longitude - startingPoint.longitude, y: endingPoint.latitude - startingPoint.latitude)
        
        let radianAngle: CGFloat = CGFloat(-atan2f(Float(Double(distanceDifferences.y)), Float(Double(distanceDifferences.x))))
        print("radian angle: \(radianAngle), bearing: \(bearingAngleRadians)")
        return radianAngle
    }
    
    func drawRoute(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) {
    
        let originLocation: CLLocation = CLLocation(latitude: fromLocation.latitude, longitude: fromLocation.longitude)
        let destinationLocation: CLLocation = CLLocation(latitude: toLocation.latitude, longitude: toLocation.longitude)
    
        DispatchQueue.main.async {
            Global.global.fetchPolylineWithOrigin(origin: originLocation, destination: destinationLocation) { (toUserPolyline) in
                if toUserPolyline != nil {
                    DispatchQueue.main.async {
                        toUserPolyline?.map = self.mapView
                        self.selectedMarker?.followPolyline = toUserPolyline
                    }
                }
            }
        }
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
    
    //Update location variables for current user and refresh follow path if following someone
    func updateMy(locationCoordinate: CLLocationCoordinate2D) {
        
        RequestManager().postMyLocation(latLong: "\(locationCoordinate.latitude),\(locationCoordinate.longitude)") { (success, response) in
            
        }
        
        //Update variables
        myPreviousCoordinate = myCurrentCoordinate
        myCurrentCoordinate = locationCoordinate
        
//        For car direction
//        UIView.animate(withDuration: 0.3) {
//            self.myMarker?.updateBaseAngleWith(baseAngle: self.getRadiansOfMarkerRotationWhenMoved(from: self.myPreviousCoordinate!, to: self.myCurrentCoordinate!))
//            self.myMarker?.updateBearingWith(bearing: self.bearingAngleRadians)
            self.myMarker?.position = locationCoordinate
//        }
        currentUserPath?.add(locationCoordinate)
        currentUserPolyline = getPolylineFor(path: currentUserPath)
        
//        //Save my traversed path
//        UserDefaults.standard.setValue(currentUserPath?.encodedPath(), forKey: kMyEncodedPath)
//        UserDefaults.standard.synchronize()
        
        //Draw follow path
        resetRouteFor(marker: selectedMarker)
        latTextField.text = "\(String(describing: myCurrentCoordinate?.latitude))"
        longTextField.text = "\(String(describing: myCurrentCoordinate?.longitude))"
        followSelectedFriendsMarker()
    }
    
    func getPolylineFor(path: GMSMutablePath?) -> GMSPolyline {
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.strokeColor = loggedInUserPathColor
        polyline.map = mapView
        
        return polyline
    }
    
    func getPolylineFor(coordinates: Array<CLLocationCoordinate2D>) -> GMSPolyline {
        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(coordinate)
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.strokeColor = loggedInUserPathColor
        polyline.map = mapView
        
        return polyline
    }
    
    func addMarkers(of friends:[User], shouldClearOldData: Bool) {
        if shouldClearOldData {
            remove(markers: self.friendsMarkers)
        }
        var i = 1
        for friend in friends {
            let image = UIImage(named: "marker")
            let markerImageView = UIImageView(image: image)
            markerImageView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            friend.id = "\(i)"
            
            let friendMarker: UserMarker = UserMarker(user: friend)
            friendMarker.iconView = markerImageView
            friendMarker.position = friend.lastLocation!
//            friendMarker.title = "Indore"
//            friendMarker.snippet = "India"
            friendMarker.map = mapView
            friendMarker.iconView?.bounds = CGRect(x: 0, y: (friendMarker.iconView?.bounds.size.height)!/2, width: (friendMarker.iconView?.bounds.size.width)!, height: (friendMarker.iconView?.bounds.size.height)!)
            
            friendsMarkers.append(friendMarker)
            i = i + 1
            
            
        }
        getLocationOf(friend: friends[0])
    }
    
    func remove(markers: [UserMarker]) {
        for marker in markers {
            if friendsMarkers.index(of: marker) != nil {
                marker.map = nil
                marker.iconView = nil
                friendsMarkers.remove(at: friendsMarkers.index(of: marker)!)
            }
        }
    }
    
    //MARK: - Private methods
    
    func getLocationOf(friend: User) {
        RequestManager().getCoordinatesOfFriend(of: friend.id!) { (success, response) in
            if (response as! Dictionary<String,AnyObject>)["latLongs"] != nil {
                let coordinates = Global.global.getCLLocationCoordinate2DArray(forLatLongStringArray: (response as! Dictionary<String,AnyObject>)["latLongs"] as! Array<String>)
                friend.marker?.traversedPolyline = self.getPolylineFor(coordinates: coordinates)
                friend.marker?.traversedPolyline?.map = self.mapView
            }
        }
    }
    
}

