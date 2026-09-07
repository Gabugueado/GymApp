//
//  AddWorkoutEntryView.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import SwiftData
import SwiftUI

struct AddWorkoutEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Exercise.name) private var registeredExercises: [Exercise]

    @State private var exerciseName = ""
    @State private var weight = 20.0
    @State private var repetitions = 10
    @State private var series = 3
    @State private var timestamp = Date()
    @State private var durationMinutes = 30

    let onSave: (NewWorkoutSetInput) -> Void

    private var trimmedExerciseName: String {
        exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedExerciseName.isEmpty && weight > 0 && repetitions > 0 && series > 0 && durationMinutes > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ejercicio") {
                    TextField("Nombre", text: $exerciseName)
                        .textInputAutocapitalization(.words)

                    if !registeredExercises.isEmpty {
                        Picker("Registrados", selection: $exerciseName) {
                            Text("Escribir nuevo").tag("")

                            ForEach(registeredExercises) { exercise in
                                Text(exercise.name).tag(exercise.name)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                Section("Carga") {
                    NumericDoubleField(
                        title: "Peso",
                        suffix: "kg",
                        value: $weight,
                        range: 0...500,
                        step: 2.5
                    )

                    NumericIntField(
                        title: "Series",
                        value: $series,
                        range: 1...20,
                        step: 1
                    )

                    NumericIntField(
                        title: "Repeticiones",
                        value: $repetitions,
                        range: 1...100,
                        step: 1
                    )
                }

                Section("Fecha y tiempo") {
                    DatePicker("Fecha y hora", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                    Stepper("Duración: \(durationMinutes) min", value: $durationMinutes, in: 5...240, step: 5)
                }
            }
            .navigationTitle("Nuevo registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let input = NewWorkoutSetInput(
                            exerciseName: trimmedExerciseName,
                            weight: weight,
                            repetitions: repetitions,
                            series: series,
                            timestamp: timestamp,
                            startTime: timestamp,
                            durationMinutes: durationMinutes
                        )
                        onSave(input)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

private struct NumericDoubleField: View {
    let title: String
    let suffix: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                TextField(title, value: $value, format: .number.precision(.fractionLength(0...1)))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 96)
                Text(suffix)
                    .foregroundStyle(.secondary)
            }

            Stepper(title, value: $value, in: range, step: step)
                .labelsHidden()
        }
    }
}

private struct NumericIntField: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                TextField(title, value: $value, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 96)
            }

            Stepper(title, value: $value, in: range, step: step)
                .labelsHidden()
        }
    }
}

#Preview {
    AddWorkoutEntryView { _ in }
        .modelContainer(for: [Exercise.self, WorkoutSet.self], inMemory: true)
}
