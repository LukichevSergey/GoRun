//
//  TrainingManager.swift
//  GoRun
//
//  Created by Лукичев Сергей on 23.08.2023.
//

import Foundation
import CoreLocation

final class TrainingManager {
    static let shared = TrainingManager()
    
    private init() {}
    
    private var trainings: [Training] = []
    
    var currentTraining: Training?
    
    var trainingStatus: Training.TrainingStatus {
        return currentTraining?.trainingStatus ?? .stop
    }
    
    func setTrainingStatus(on status: Training.TrainingStatus) {
        currentTraining?.trainingStatus = status
    }
    
    func createTraining() {
        currentTraining = Training()
    }
    
    func updateTraining(with coordinates: [CLLocationCoordinate2D]) {
        currentTraining?.coordinates.append(coordinates)
    }
    
    func getCurrentTrainingCoordinates() -> [[CLLocationCoordinate2D]] {
        return currentTraining?.coordinates ?? []
    }
    
    func stopTraining() {
        currentTraining?.finishTime = Date()
        guard let currentTraining else { return }
        trainings.append(currentTraining)
        self.currentTraining = nil
    }
}
