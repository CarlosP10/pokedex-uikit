//
//  PPokemonDetailStatsTableViewCellViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/26/23.
//

import Foundation

final class PPokemonDetailStatsTableViewCellViewModel {
    private let titleStat: String
    public let scoreStat: Int
    
    public var titleStatDisplay: String {
        return titleStat.capitalized
    }
    
    init(titleStat: String, scoreStat: Int) {
        self.titleStat = titleStat
        self.scoreStat = scoreStat
    }
}
