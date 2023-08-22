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
    
    private let viewModel = MapViewModel()
    private let mapView = MKMapView()
    private let locationManager = LocationManager.shared
    var coordinates: [CLLocationCoordinate2D] = []
    
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 3
            return renderer
        }
        return MKPolylineRenderer()
    }
}

extension MapViewController: LocationManagerDelegate {
    func didUpdateUserLocation(_ location: CLLocation) {
        // Обновление отображения карты с новыми координатами пользователя
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        viewModel.userLocationUpdated(on: location)

        coordinates.append(location.coordinate)

        // Отрисовка линий на карте
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}
