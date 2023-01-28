//
//  PPokemonDetailViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import Foundation
import UIKit

protocol PPokemonDataRender {
    var id: Int { get }
    var name: String { get }
    var base_experience: Int { get }
    var height: Int { get }
    var order: Int { get }
    var weight: Int { get }
    var abilities: [PPokemonAbility] { get }
    var stats: [PPokemonStats] { get }
    var types: [PPokemonTypes] { get }
}

/// Get Detail Pokemon
final class PPokemonDetailViewViewModel: NSObject {
    
    private let pokemonUrl: PPokemonNamedAPIResource?
    
    private var isFetching = false
    private var dataBlock: ((PPokemonDataRender) -> Void)?
    public var cellView: Int = 0
    
    public var pokemon: PPokemon? {
        didSet {
            guard let model = pokemon else {
                return
            }
            dataBlock?(model)
        }
    }
    
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
    
    init(pokemonUrl: PPokemonNamedAPIResource?) {
        self.pokemonUrl = pokemonUrl
    }
    
    public var title: String {
        pokemonUrl?.name.capitalized ?? ""
    }
    
    private var requestUrl: URL? {
        return URL(string: pokemonUrl?.url ?? "")
    }
    
    public func fetchPokemon() {
        guard !isFetching else {
            if let model = pokemon {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = requestUrl,
              let request = PRequest(url: url) else {
            print("Failed to create request")
            return
        }
        
        isFetching = true
        
        PService.shared.execute(request, expecting: PPokemon.self) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                strongSelf.pokemon = responseModel
                strongSelf.setUpDetailInfo()
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func registerForData(_ block: @escaping (PPokemonDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let pokemongImage = pokemon?.proImage,
              let url = URL(string: pokemongImage) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        PImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    private func setUpDetailInfo() {
        guard let pokemon = pokemon else { return }
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
