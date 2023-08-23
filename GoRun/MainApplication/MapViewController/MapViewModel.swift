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
    
    private let locationManager = LocationManager.shared
    private let trainingManager = TrainingManager.shared
    
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var location: CLLocation?
    
    init() {
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.startUpdatingLocation()
        trainingManager.setTrainingStatus(on: .start)
    }
    
    func pause() {
        locationManager.stopUpdatingLocation()
        trainingManager.setTrainingStatus(on: .pause)
        trainingManager.updateTraining(with: coordinates)
        coordinates = []
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        trainingManager.setTrainingStatus(on: .stop)
        trainingManager.updateTraining(with: coordinates)
        trainingManager.stopTraining()
        coordinates = []
    }
    
    func requestAuthorization() {
        locationManager.requestAuthorization()
    }
}

extension MapViewModel: LocationManagerDelegate {
    func didUpdateUserLocation(_ location: CLLocation) {
        self.location = location
        guard trainingManager.trainingStatus == .start else { return }
        coordinates.append(location.coordinate)
    }
}
