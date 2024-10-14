//
//  Alghorithm.swift
//  genetic-alghorithm.desktop-app
//
//  Created by Никита Харсеко on 13/10/2024.
//

import Foundation

struct Gen: Equatable {
    var value: Int
}

struct Individual {
    var genes: [Gen]
    var fitness: Int = 0

    init(genes: [Gen]) {
        self.genes = genes
    }

    init(size: Int) {
        self.init(genes: (0..<size).map { _ in Gen(value: Int.random(in: 0...10)) })
    }

    mutating func evaluateFitness(idealGenes: [Gen]) {
        var f = 0
        for i in 0..<genes.count {
            if genes[i].value == idealGenes[i].value {
                f += 1
            }
        }
        self.fitness = f
    }

    mutating func mutate(mutationRate: Double) {
        if Double.random(in: 0...1) < mutationRate {
            let index = Int.random(in: 0..<genes.count)
            genes[index].value = Int.random(in: 0...10)
        }
    }
}

struct Population {
    var individuals: [Individual]

    init(individuals: [Individual]) {
        self.individuals = individuals
    }

    init(populationSize: Int, geneSize: Int) {
        self.init(individuals: (0..<populationSize).map { _ in Individual(size: geneSize) })
    }

    mutating func evaluateFitness(idealGenes: [Gen]) {
        for i in 0..<individuals.count {
            individuals[i].evaluateFitness(idealGenes: idealGenes)
        }
    }
}
