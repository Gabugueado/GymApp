//
//  ContentView.swift
//  GymApp
//
//  Created by Gabriel Patricio Castillo Núñez on 25-06-26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSet.timestamp, order: .reverse) private var workoutSets: [WorkoutSet]

    @State private var isShowingAddWorkout = false

    private let viewModel = WorkoutListViewModel()

    private var daySections: [WorkoutDaySection] {
        viewModel.groupedByDay(workoutSets)
    }

    var body: some View {
        NavigationStack {
            List {
                if workoutSets.isEmpty {
                    emptyState
                } else {
                    workoutEntries
                }
            }
            .navigationTitle("GymApp")
            .toolbar {
                addWorkoutToolbarItem
            }
            .sheet(isPresented: $isShowingAddWorkout) {
                AddWorkoutEntryView { input in
                    addWorkoutSet(input)
                }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "Sin registros",
            systemImage: "dumbbell",
            description: Text("Agrega tu primer ejercicio para empezar a seguir tus pesos.")
        )
    }

    private var workoutEntries: some View {
        ForEach(daySections) { section in
            Section {
                ForEach(section.sets) { workoutSet in
                    NavigationLink {
                        ExerciseDetailView(exercise: workoutSet.exercise)
                    } label: {
                        WorkoutEntryRow(workoutSet: workoutSet)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            let currentSet = workoutSet

                            print("Editar set 1: \(currentSet.exercise.name)")
                            // Ej: tuEstadoParaEditar = currentSet
                            // isShowingEditWorkout = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
                .onDelete { offsets in
                    deleteWorkoutSets(offsets, from: section.sets)
                }
            } header: {
                Text(section.day, format: .dateTime.weekday(.wide).day().month())
            }
        }
    }

    private var addWorkoutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShowingAddWorkout = true
            } label: {
                Label("Agregar registro", systemImage: "plus")
            }
        }
    }

    private func addWorkoutSet(_ input: NewWorkoutSetInput) {
        withAnimation {
            viewModel.addWorkoutSet(from: input, in: modelContext)
        }
    }

    private func deleteWorkoutSets(_ offsets: IndexSet, from sets: [WorkoutSet]) {
        withAnimation {
            viewModel.deleteSets(at: offsets, from: sets, in: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exercise.self, WorkoutSet.self], inMemory: true)
}
