//
//  PPokemonDetailInfoTableViewCellViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/24/23.
//

import Foundation

final class PPokemonDetailInfoTableViewCellViewModel {
    private let name: Info
    private let info: String
    public let hasBase: Bool
    
    public var nameTitle: String {
        name.displayTitle
    }
    
    public var displayValue: String {
        if info.isEmpty { return "-"}
        
        return info
    }
    
    enum Info: String {
        case height,
             order,
             weight,
             type,
             abilities,
             ability,
             baseExperience
        
        var displayTitle: String {
            switch self {
            case .height,
                    .order,
                    .weight,
                    .type,
                    .abilities,
                    .ability:
                return rawValue.capitalized
            case .baseExperience:
                return "Base experience"
            }
        }
    }
    
    init(name: Info, info: String, hasBase: Bool = false) {
        self.name = name
        self.info = info
        self.hasBase = hasBase
    }
}
