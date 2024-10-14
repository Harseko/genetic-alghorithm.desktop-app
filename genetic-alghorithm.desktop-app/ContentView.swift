//
//  ContentView.swift
//  genetic-alghorithm.desktop-app
//
//  Created by Никита Харсеко on 13/10/2024.
//

import SwiftUI
import Charts
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        VStack {

            switch viewModel.type {
            case .grid:
                if viewModel.population != nil {
                    grid(population: viewModel.population!, target: viewModel.target)
                }
            case .chartA:
                if viewModel.population != nil {
                    chartA(population: viewModel.population!, target: viewModel.target)
                }
            case .chartB:
                if viewModel.population != nil {
                    test(population: viewModel.population!, target: viewModel.target)
                }
            }

            Picker("Type", selection: $viewModel.type) {
                Text("Grid").tag(ViewType.grid)
                Text("Chart A").tag(ViewType.chartA)
                Text("Chart B").tag(ViewType.chartB)
            }.frame(width: 150)

            HStack {
                Text("Generation: \(viewModel.generation)")
                Text("Population: \(viewModel.populationSize)")
                Text("Mutation rate: \(viewModel.mutationRate)")
            }

            HStack {
                switch viewModel.state {
                case .running:
                    Button(action: {
                        viewModel.pause()
                    }, label: {
                        Text("Pause")
                    })
                    Button(action: {
                        viewModel.stop()
                    }, label: {
                        Text("Stop")
                    })
                case .paused:
                    Button(action: {
                        viewModel.resume()
                    }, label: {
                        Text("Resume")
                    })
                    Button(action: {
                        viewModel.stop()
                    }, label: {
                        Text("Stop")
                    })
                case .stopped:
                    Button(action: {
                        viewModel.start()
                    }, label: {
                        Text("Start")
                    })
                }
            }
        }.frame(maxWidth: 1920, maxHeight: 1080)
    }


    @ViewBuilder func grid(population: Population, target: [Gen]) -> some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(20)), count: target.count + 1)) {
                ForEach(-1..<target.count) { i in
                    if i == -1 {
                        Text("")
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                    } else {
                        Text("\(target[i].value)")
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                    }
                }
            }
            ScrollView {

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(20)), count: target.count + 1)) {
                    // 4
                    ForEach(0..<population.individuals.count) { i in
                        ForEach(-1..<target.count) { j in
                            if j == -1 {
                                Text("\(population.individuals[i].fitness)")
                                    .frame(width: 20, height: 20)
                                    .background(Color.blue)
                            } else {
                                let individualValue = population.individuals[i].genes[j].value
                                let targetValue = target[j].value
                                Text("\(individualValue)")
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .background {
                                        if individualValue == targetValue  {
                                            Color.green
                                        } else {
                                            Color.red
                                        }
                                    }
                            }
                        }
                    }
                }.padding(.all, 10)
            }
        }.frame(width: 600, height: 600)
    }

    @ViewBuilder func chartA(population: Population, target: [Gen]) -> some View {
        Chart {
            ForEach(0..<target.count, id: \.self) { i in
                let count = Double(population.individuals.reduce(into: 0, { $0 += $1.genes[i] == target[i] ? 1 : 0 }))
                let all = Double(population.individuals.count)
                BarMark(
                    x: .value("Gen", i),
                    y: .value("Percent", count / all * 100)
                )
                .foregroundStyle(
                    Color(
                        red: 1.0 / Double(target.count) * Double(i),
                        green: 0.1 + 0.1 / Double(target.count) * Double(i),
                        blue: 0.5 + 0.1 / Double(target.count) * Double(i))
                )
            }
        }
        .chartYScale(domain: 0...100)
        .chartXScale(domain: 0...target.count)
        .frame(width: 600, height: 600)
    }

    @ViewBuilder func test(population: Population, target: [Gen]) -> some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(20)), count: target.count + 1)) {
                ForEach(-1..<target.count) { i in
                    if i == -1 {
                        Text("")
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                    } else {
                        Text("\(target[i].value)")
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                    }
                }
            }
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(20)), count: target.count), spacing: 0) {
                    // 4
                    ForEach(0..<population.individuals.count) { i in
                        ForEach(0..<target.count) { j in
                            let individualValue = population.individuals[i].genes[j].value
                            let targetValue = target[j].value
                            let color = if individualValue == targetValue  {
                                Color.gray
                            } else {
                                Color.white
                            }
                            Rectangle()
                                .fill(color)
                                .frame(width: 20, height: 1, alignment: .center)
                        }
                    }
                }.padding(.all, 10)
            }
        }.frame(width: 600, height: 600)
    }
}

class ViewModel: ObservableObject {
    let target = [
        Gen(value: 0),
        Gen(value: 2),
        Gen(value: 10),
        Gen(value: 5),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 10),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 10),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 10),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 10),
        Gen(value: 5),
        Gen(value: 2),
        Gen(value: 10),
    ]

    var populationSize = 100
    var maxGenerations = 5000
    var mutationRate = 0.05

    @Published var population: Population? = nil
    @Published var generation: Int = 0
    @Published var state: State = .stopped
    @Published var type: ViewType = .chartB

    init() {}

    func start() {
        state = .running
        DispatchQueue.global().async {
            self.geneticAlgorithm()
        }
    }

    func pause() {
        state = .paused
    }

    func resume() {
        state = .running
    }

    func stop() {
        state = .stopped
    }

    func mutate(population: Population, mutationRate: Double) -> Population {
        var newPopulation = Population(populationSize: 0, geneSize: 0)

        let minimalFitness = population.individuals.sorted(by: { $0.fitness < $1.fitness }).first!.fitness

        var cutting = 0
        if minimalFitness > 1 {
            cutting = minimalFitness - 1
        } else if minimalFitness <= 1 {
            if minimalFitness == 1 {
                cutting = 0
            } else if minimalFitness < 1 {
                cutting = -minimalFitness - 1
            }
        }

        let summaryFitness = population.individuals.reduce(0) { $0 + $1.fitness - cutting }

        let countOfNewIndividuals = population.individuals.count / 2

        for _ in 0..<countOfNewIndividuals {
            var selectedIndividual = weightedRandomSelection(
                elements: population.individuals,
                weights: population.individuals.map { Double($0.fitness - cutting) / Double(summaryFitness) }
            )!
            for _ in 0..<2 {
                var i = selectedIndividual
                i.mutate(mutationRate: mutationRate)
                newPopulation.individuals.append(i)
            }
        }
        return newPopulation
    }

    func weightedRandomSelection<T>(elements: [T], weights: [Double]) -> T? {
        let totalWeight = weights.reduce(0, +)

        let randomValue = Double.random(in: 0..<totalWeight)

        var cumulativeWeight: Double = 0
        for (index, weight) in weights.enumerated() {
            cumulativeWeight += weight
            if randomValue < cumulativeWeight {
                return elements[index]
            }
        }

        return nil
    }

    func geneticAlgorithm() {
        DispatchQueue.main.sync {
            population = Population(populationSize: populationSize, geneSize: target.count)
            population?.evaluateFitness(idealGenes: target)
        }

        for generation in 0..<maxGenerations {
            var newPopulation = mutate(population: population!, mutationRate: mutationRate)

            newPopulation.evaluateFitness(idealGenes: target)

            DispatchQueue.main.sync {
                self.population = newPopulation
                self.generation = generation
            }
            while state == .paused {
                usleep(50 * 1000)
            }
            if state == .stopped {
                return
            }
        }
    }
}


enum State {
    case running
    case paused
    case stopped
}

enum ViewType {
    case grid
    case chartA
    case chartB
}

#Preview {
    ContentView()
}
