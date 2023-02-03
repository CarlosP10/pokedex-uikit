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
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pokedex"
        setUpView()
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        if navigationController == nil {
            doneButton.isHidden = false
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
    
    @objc
    private func doneTapped() {
        dismiss(animated: true)
    }
}

//MARK: - PPokemonListViewDelegate
extension PPokemonViewController: PPokemonListViewDelegate {
    func pPokemonListView(didselectPokemon pokemon: PPokemon) {
        //Open detail controller for that controller
        let viewModel = PPokemonDetailViewViewModel(pokemon: pokemon)
        let detailVC = PPokemonDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
