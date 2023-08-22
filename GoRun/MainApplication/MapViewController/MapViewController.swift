//
//  MapViewController.swift
//  GoRun
//
//  Created by Лукичев Сергей on 22.08.2023.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

final class MapViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let locationManager = LocationManager.shared
    
    private func configureUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        locationManager.delegate = self
        locationManager.requestAuthorization()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    
}


extension MapViewController: LocationManagerDelegate {
    func didUpdateUserLocation(_ location: CLLocation) {
        // Обновление отображения карты с новыми координатами пользователя
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}
