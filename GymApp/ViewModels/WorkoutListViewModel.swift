//
//  WorkoutListViewModel.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import Foundation
import SwiftData

struct WorkoutDaySection: Identifiable {
    let day: Date
    let sets: [WorkoutSet]

    var id: Date { day }
}

struct NewWorkoutSetInput {
    let exerciseName: String
    let weight: Double
    let repetitions: Int
    let series: Int
    let timestamp: Date
    let startTime: Date
    let durationMinutes: Int
}

final class WorkoutListViewModel {
    func groupedByDay(_ sets: [WorkoutSet], calendar: Calendar = .current) -> [WorkoutDaySection] {
        let groupedSets = Dictionary(grouping: sets) { set in
            calendar.startOfDay(for: set.timestamp)
        }

        return groupedSets
            .map { WorkoutDaySection(day: $0.key, sets: sortedSets($0.value)) }
            .sorted { $0.day > $1.day }
    }

    func addWorkoutSet(from input: NewWorkoutSetInput, in modelContext: ModelContext) {
        let exercise = existingExercise(named: input.exerciseName, in: modelContext) ?? Exercise(name: input.exerciseName)

        if exercise.modelContext == nil {
            modelContext.insert(exercise)
        }

        let workoutSet = WorkoutSet(
            weight: input.weight,
            repetitions: input.repetitions,
            series: input.series,
            timestamp: input.timestamp,
            startTime: input.startTime,
            durationMinutes: input.durationMinutes,
            exercise: exercise
        )

        modelContext.insert(workoutSet)
        exercise.sets.append(workoutSet)
    }

    func deleteSets(at offsets: IndexSet, from sets: [WorkoutSet], in modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(sets[index])
        }
    }
    
    func listSets(in modelContext: ModelContext) -> [WorkoutSet] {
        // 1. Creamos un descriptor de búsqueda (Como el query object de Prisma)
        // Opcional: Le podemos decir que ordene por fecha (timestamp) de forma descendente
        let descriptor = FetchDescriptor<WorkoutSet>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            // 2. Le pedimos al contexto que ejecute la búsqueda (como un await db.fetch())
            let setsObtenidos = try modelContext.fetch(descriptor)
            return setsObtenidos
        } catch {
            print("Error al traer los sets de la base de datos: \(error)")
            return [] // Si falla, retornamos un array vacío de forma segura
        }
    }

    private func existingExercise(named name: String, in modelContext: ModelContext) -> Exercise? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptor = FetchDescriptor<Exercise>(sortBy: [SortDescriptor(\.name)])
        let exercises = (try? modelContext.fetch(descriptor)) ?? []

        return exercises.first { exercise in
            exercise.name.compare(trimmedName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
    }

    private func sortedSets(_ sets: [WorkoutSet]) -> [WorkoutSet] {
        sets.sorted { $0.timestamp > $1.timestamp }
    }
}
