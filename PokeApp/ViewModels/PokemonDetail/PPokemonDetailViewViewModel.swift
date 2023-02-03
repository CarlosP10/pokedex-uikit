//
//  PPokemonDetailViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import Foundation
import UIKit

/// Get Detail Pokemon
final class PPokemonDetailViewViewModel: NSObject {
    
    public var cellView: Int = 0
    
    public var pokemon: PPokemon
    
    enum DetailType {
        case infoDetail(viewModel: [PPokemonDetailInfoTableViewCellViewModel])
        case statsDetail(viewModel: [PPokemonDetailStatsTableViewCellViewModel])
        
        var displayTitle: String {
            switch self {
            case .infoDetail(viewModel: _):
                return "Info"
            case .statsDetail(viewModel: _):
                return "Base Stats"
            }
        }
    }
    
    public var details: [DetailType] = []
    
    init(pokemon: PPokemon) {
        self.pokemon = pokemon
    }
    
    public var title: String {
        pokemon.name.capitalized
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        setUpDetailInfo()
        guard let url = URL(string: pokemon.proImage) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        PImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    private func setUpDetailInfo() {
        let hasAbilities = pokemon.abilities.count > 1
        details = [
            .infoDetail(viewModel: [
                .init(name: .type, info: "\(pokemon.typeString)"),
                .init(name: .height, info: pokemon.heightString),
                .init(name: .weight, info: pokemon.weightString),
                hasAbilities ?
                    .init(name: .abilities, info: pokemon.abilitiesString) :
                        .init(name: .ability, info: pokemon.abilitiesString),
                .init(name: .baseExperience, info: "\(pokemon.base_experience)", hasBase: true),
            ]),
            .statsDetail(viewModel: pokemon.stats.compactMap({
                return PPokemonDetailStatsTableViewCellViewModel(titleStat: $0.stat.name, scoreStat: $0.base_stat)
            }))
        ]
    }
}

//MARK: - TableView
extension PPokemonDetailViewViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let details = details[cellView]
        switch details {
        case .infoDetail(viewModel: let viewModel):
            return viewModel.count
        case .statsDetail(viewModel: let viewModel):
            return viewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = details[cellView]
        switch details {
        case .infoDetail(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier:PPokemonDetailInfoTableViewCell.identifier,
                for: indexPath
            ) as? PPokemonDetailInfoTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case .statsDetail(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PPokemonDetailStatsTableViewCell.identifier,
                for: indexPath
            ) as? PPokemonDetailStatsTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
    }
}
