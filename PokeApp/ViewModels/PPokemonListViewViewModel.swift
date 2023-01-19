//
//  PPokemonListViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import UIKit

protocol PPokemonListViewViewModelDelegate: AnyObject {
    func didLoadInitialPokemons()
}

final class PPokemonListViewViewModel: NSObject {
    
    //Weak to avoid memory leak
    public weak var delegate: PPokemonListViewViewModelDelegate?
    
    private var pokemons: [PPokemonNamedAPIResource] = [] {
        didSet {
            for pokemon in pokemons {
                let viewModel = PPokemonCollectionViewCellViewModel(
                    pokemonName: pokemon.name,
                    pokemonImageUrl: URL(string: pokemon.baseImage)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [PPokemonCollectionViewCellViewModel] = []
    
    func fetchPokemons() {
        PService.shared.execute(.listPokemonsRequest, expecting: PGetAllPokemonResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.pokemons = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialPokemons()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension PPokemonListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PPokemonCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? PPokemonCollectionViewCell else {
            fatalError("Unsopported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    
}
