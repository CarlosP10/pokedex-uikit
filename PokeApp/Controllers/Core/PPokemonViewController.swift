//
//  PPokemonViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

/// Controller to show and search for pokemon
final class PPokemonViewController: UIViewController {

    private let pokemonListView = PPokemonListView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pokedex"
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        if navigationController == nil {
            pokemonListView.showHeaderIsHidden(false)
        }
    }
    
    private func setUpView() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationItem.backBarButtonItem = backBarButtonItem
        
        pokemonListView.delegate = self
        view.addSubviews(pokemonListView)
        
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
    func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    func pPokemonListView(didselectPokemon pokemon: PPokemon) {
        //Open detail controller for that controller
        let viewModel = PPokemonDetailViewViewModel(pokemon: pokemon)
        let detailVC = PPokemonDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
