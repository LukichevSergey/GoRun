//
//  LocationManager.swift
//  GoRun
//
//  Created by Лукичев Сергей on 22.08.2023.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateUserLocation(_ location: CLLocation)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    weak var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func calculateDistance(routeCoordinates: [CLLocationCoordinate2D]) -> CLLocationDistance {
        var totalDistance: CLLocationDistance = 0
        if routeCoordinates.count > 1 {
            for i in 0..<routeCoordinates.count-1 {
                let source = CLLocation(latitude: routeCoordinates[i].latitude, longitude: routeCoordinates[i].longitude)
                let destination = CLLocation(latitude: routeCoordinates[i+1].latitude, longitude: routeCoordinates[i+1].longitude)
                totalDistance += source.distance(from: destination)
            }
        }
        return totalDistance
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        delegate?.didUpdateUserLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
}
