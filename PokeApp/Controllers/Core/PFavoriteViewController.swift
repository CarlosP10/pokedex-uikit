//
//  PFavoriteViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

/// Controller to show and search for favorites pokemon
final class PFavoriteViewController: UIViewController {
    
    private let pokemonFavorites = PPokemonFavoriteListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        setUpView()
    }
    
    private func setUpView() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationItem.backBarButtonItem = backBarButtonItem
        
        pokemonFavorites.delegate = self
        view.addSubview(pokemonFavorites)
        NSLayoutConstraint.activate([
            pokemonFavorites.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonFavorites.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pokemonFavorites.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pokemonFavorites.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - PPokemonFavoriteListViewDelegate
extension PFavoriteViewController: PPokemonFavoriteListViewDelegate {
    func pPokemonListView(_ pokemonListView: PPokemonFavoriteListView, didSelectPokemon pokemon: PPokemon) {
        ///Open detail controller
        let vm = PPokemonDetailViewViewModel(pokemon: pokemon)
        let vc = PPokemonDetailViewController(viewModel: vm)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
