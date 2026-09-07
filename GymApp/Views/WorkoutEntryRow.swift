//
//  WorkoutEntryRow.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import SwiftUI

struct WorkoutEntryRow: View {
    let workoutSet: WorkoutSet

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dumbbell.fill")
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 36, height: 36)
                .background(.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(workoutSet.exercise.name)
                    .font(.headline)

                Text(workoutSet.timestamp, format: .dateTime.hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(workoutSet.weight, format: .number.precision(.fractionLength(0...1)))
                        .font(.headline)

                    Text("kg")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("\(workoutSet.series)x\(workoutSet.repetitions) reps")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    let exercise = Exercise(name: "Press banca")
    let workoutSet = WorkoutSet(weight: 80, repetitions: 8, series: 3, exercise: exercise)

    WorkoutEntryRow(workoutSet: workoutSet)
        .padding()
}
