//
//  ViewController.swift
//  GPSDemo
//
//  Created by Talor Levy on 2/17/23.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - @IBOutlet
    
    @IBOutlet weak var aMap: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        setUpLocationService()
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
    }
    
    func setUpLocationService() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func dropPin(lat: Double, long: Double) {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        aMap.addAnnotation(annotation)
    }
    
    func searchMap(search: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = search
        searchRequest.region = aMap.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let results = response else {
                print(error?.localizedDescription ?? "Error reached but description unavailable")
                return
            }
            for item in results.mapItems {
                let lat = item.placemark.coordinate.latitude
                let long = item.placemark.coordinate.longitude
                self.dropPin(lat: lat, long: long)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


// MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        aMap.removeAnnotations(aMap.annotations)
        let searchText = searchBar.text ?? ""
        searchMap(search: searchText)
    }
}
