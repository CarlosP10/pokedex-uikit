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
             baseExperience
        
        var displayTitle: String {
            switch self {
            case .height,
                    .order,
                    .weight:
                return rawValue.capitalized
            case .baseExperience:
                return "Base experience"
            }
        }
    }
    
    init(name: Info, info: String) {
        self.name = name
        self.info = info
    }
}
