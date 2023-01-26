//
//  PPokemonDetailViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import Foundation
import UIKit

protocol PPokemonDetailViewViewModelDelegate: AnyObject {
    func didLoadPokemon(with pokemon: PPokemon)
}

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
    
    public weak var delgate: PPokemonDetailViewViewModelDelegate?
    private var isFetching = false
    private var dataBlock: ((PPokemonDataRender) -> Void)?
    
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
        //        case statsDetail(viewModel: [PPokemonDetailInfoTableViewCellViewModel])
        //        case abilitiesDetail(viewModel: [PPokemonDetailInfoTableViewCellViewModel])
        
        var displayTitle: String {
            switch self {
            case .infoDetail(viewModel: _):
                return "Info"
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
        guard let pokemongImage = pokemon?.baseImage,
              let url = URL(string: pokemongImage) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        PImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    private func setUpDetailInfo() {
        guard let pokemon = pokemon else { return }
        details = [
            .infoDetail(viewModel: [
                .init(name: .height, info: "\(pokemon.height)"),
                .init(name: .weight, info: "\(pokemon.weight)"),
                .init(name: .baseExperience, info: "\(pokemon.base_experience)"),
                .init(name: .order, info: "\(pokemon.order)"),
            ])
        ]
    }
}

//MARK: - TableView
extension PPokemonDetailViewViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let details = details[0]
        switch details {
        case .infoDetail(viewModel: let viewModel):
            return viewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = details[0]
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
        }
    }
}
