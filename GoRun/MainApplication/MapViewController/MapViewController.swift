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
import Combine

final class MapViewController: UIViewController {
    
    private let viewModel = MapViewModel()
    private let mapView = MKMapView()
    private var coordinatesSubscription = Set<AnyCancellable>()
    private var locationSubscription = Set<AnyCancellable>()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Старт", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Стоп", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startButton, stopButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        return stack
    }()
    
    @objc private func startButtonTapped() {
        viewModel.start()
    }
    
    @objc private func stopButtonTapped() {
        viewModel.stop()
    }
    
    private func configureUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        mapView.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func setRegion(_ location: CLLocation) {
        // Обновление отображения карты с новыми координатами пользователя
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    deinit {
        coordinatesSubscription.removeAll()
        locationSubscription.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        viewModel.requestAuthorization()
        configureUI()
        
        viewModel.$coordinates
            .dropFirst()
            .sink { [weak self] coordinates in
                self?.renderWayLine(by: coordinates)
            }.store(in: &coordinatesSubscription)
        
        viewModel.$location
            .sink { [weak self] location in
                guard let location else { return }
                self?.setRegion(location)
            }.store(in: &locationSubscription)
    }
    
    private func renderWayLine(by coordinates: [CLLocationCoordinate2D]) {
        // Отрисовка линий на карте
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
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


