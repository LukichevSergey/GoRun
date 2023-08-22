//
//  MapViewModel.swift
//  GoRun
//
//  Created by Лукичев Сергей on 22.08.2023.
//

import Foundation
import CoreLocation

final class MapViewModel {
    
    private var routeCoordinates: [CLLocationCoordinate2D] = []

    func userLocationUpdated(on location: CLLocation) {
        routeCoordinates.append(location.coordinate)
    }
}
