//
//  MapViewModel.swift
//  GoRun
//
//  Created by Лукичев Сергей on 22.08.2023.
//

import Foundation
import CoreLocation
import Combine

final class MapViewModel {
    
    let locationManager = LocationManager.shared
    
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var location: CLLocation?
    private var updatingIsStarted: Bool = false
    
    init() {
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.startUpdatingLocation()
        updatingIsStarted = true
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        updatingIsStarted = false
    }
}

extension MapViewModel: LocationManagerDelegate {
    func didUpdateUserLocation(_ location: CLLocation) {
//        guard updatingIsStarted else { return }
        coordinates.append(location.coordinate)
        self.location = location
    }
}
