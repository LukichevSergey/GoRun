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
    private var locationSubscription = Set<AnyCancellable>()
    
    private var trainingIsStarted: Bool = false {
        didSet {
            if trainingIsStarted {
                startButton.setTitle("Пауза", for: .normal)
            } else {
                startButton.setTitle("Старт", for: .normal)
            }
        }
    }
    
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
        trainingIsStarted.toggle()
        trainingIsStarted ? viewModel.start() : viewModel.pause()
    }
    
    @objc private func stopButtonTapped() {
        trainingIsStarted = false
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
        locationSubscription.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        viewModel.requestAuthorization()
        configureUI()
        
        viewModel.$location
            .sink { [weak self] location in
                guard let location, let self else { return }
                self.setRegion(location)
                self.renderWayLine(by: self.viewModel.getCoordinates())
            }.store(in: &locationSubscription)
    }
    
    private func renderWayLine(by coordinates: [[CLLocationCoordinate2D]]) {
        // Отрисовка линий на карте
        coordinates.forEach { coordinatesLine in
            let polyline = MKPolyline(coordinates: coordinatesLine, count: coordinatesLine.count)
            mapView.addOverlay(polyline)
        }
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


