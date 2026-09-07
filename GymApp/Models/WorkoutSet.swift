//
//  WorkoutSet.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import Foundation
import SwiftData

@Model
final class WorkoutSet {
    var weight: Double
    var repetitions: Int
    var series: Int
    var timestamp: Date
    var startTime: Date
    var durationMinutes: Int
    var exercise: Exercise

    init(
        weight: Double,
        repetitions: Int,
        series: Int,
        timestamp: Date = Date(),
        startTime: Date = Date(),
        durationMinutes: Int = 30,
        exercise: Exercise
    ) {
        self.weight = weight
        self.repetitions = repetitions
        self.series = series
        self.timestamp = timestamp
        self.startTime = startTime
        self.durationMinutes = durationMinutes
        self.exercise = exercise
    }
}
