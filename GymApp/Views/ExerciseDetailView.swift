//
//  ExerciseDetailView.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import Charts
import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    private var sortedSets: [WorkoutSet] {
        exercise.sets.sorted { $0.timestamp < $1.timestamp }
    }

    private var latestSet: WorkoutSet? {
        sortedSets.last
    }

    private var maxWeight: Double {
        sortedSets.map(\.weight).max() ?? 0
    }

    private var averageWeight: Double {
        guard !sortedSets.isEmpty else { return 0 }
        let totalWeight = sortedSets.reduce(0) { $0 + $1.weight }
        return totalWeight / Double(sortedSets.count)
    }

    private var totalDuration: Int {
        sortedSets.reduce(0) { $0 + $1.durationMinutes }
    }

    private func formattedWeight(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)))
    }

    var body: some View {
        List {
            Section("Resumen") {
                LabeledContent("Peso máximo", value: "\(formattedWeight(maxWeight)) kg")
                LabeledContent("Peso promedio", value: "\(formattedWeight(averageWeight)) kg")

                LabeledContent("Registros", value: "\(sortedSets.count)")
                LabeledContent("Tiempo acumulado", value: "\(totalDuration) min")
            }

            Section("Evolución de peso") {
                if sortedSets.isEmpty {
                    ContentUnavailableView("Sin historial", systemImage: "chart.line.uptrend.xyaxis")
                } else {
                    weightProgressChart
                        .frame(height: 220)
                        .padding(.vertical, 8)
                }
            }

            Section("Historial") {
                ForEach(sortedSets.reversed()) { workoutSet in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(workoutSet.timestamp, format: .dateTime.day().month().year().hour().minute())
                                .font(.headline)

                            Spacer()

                            Text("\(formattedWeight(workoutSet.weight)) kg")
                        }

                        Text("\(workoutSet.series) series de \(workoutSet.repetitions) reps · \(workoutSet.durationMinutes) min")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var weightProgressChart: some View {
        Chart(sortedSets) { workoutSet in
            LineMark(
                x: .value("Fecha", workoutSet.timestamp),
                y: .value("Peso", workoutSet.weight)
            )
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Fecha", workoutSet.timestamp),
                y: .value("Peso", workoutSet.weight)
            )
        }
        .chartYAxisLabel("kg")
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4))
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise(name: "Press banca"))
    }
}
