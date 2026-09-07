//
//  Exercise.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.exercise) var sets: [WorkoutSet]

    init(name: String, sets: [WorkoutSet] = []) {
        self.name = name
        self.sets = sets
    }
}
