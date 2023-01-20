//
//  PPokemonViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

/// Controller to show and search for pokemon
final class PPokemonViewController: UIViewController {

    private let pokemonListView = PPokemonListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pokemons"
        setUpView()
    }
    
    private func setUpView() {
        pokemonListView.delegate = self
        view.addSubview(pokemonListView)
        NSLayoutConstraint.activate([
            pokemonListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pokemonListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pokemonListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - PPokemonListViewDelegate
extension PPokemonViewController: PPokemonListViewDelegate {
    func pPokemonListView(_ pokemonListView: PPokemonListView, didselectPokemon pokemonUrl: URL?) {
        //Open detail controller for that controller
        
        let viewModel = PPokemonDetailViewViewModel(pokemonUrl: pokemonUrl)
        let detailVC = PPokemonDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
