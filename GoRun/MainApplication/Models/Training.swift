//
//  Training.swift
//  GoRun
//
//  Created by Лукичев Сергей on 23.08.2023.
//

import Foundation
import CoreLocation

final class Training {
    
    enum TrainingStatus {
        case start, pause, stop
    }
    
    let startTime: Date
    var finishTime: Date?
    var trainingStatus: TrainingStatus
    var coordinates: [[CLLocationCoordinate2D]] = []
    
    internal init(startTime: Date = Date(),
                  finishTime: Date? = nil,
                  trainingStatus: TrainingStatus = .start,
                  coordinates: [[CLLocationCoordinate2D]] = []) {
        self.startTime = startTime
        self.finishTime = finishTime
        self.trainingStatus = trainingStatus
        self.coordinates = coordinates
    }
}
