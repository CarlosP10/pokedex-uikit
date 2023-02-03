//
//  PTeamsViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

/// Controller to show and create for pokemon teams
final class PTeamViewController: UIViewController {
    
    private let teamView = PPokemonTeamListView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Teams"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        teamView.delegate = self
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        view.addSubview(teamView)
        NSLayoutConstraint.activate([
            teamView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            teamView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            teamView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            teamView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapAdd() {
        present(teamView.didTapAdd(), animated: true)
    }
}

//MARK: - PPokemonTeamListViewDelegate
extension PTeamViewController: PPokemonTeamListViewDelegate {
    func didSelectTeam() {
        let pokedexController = PPokemonViewController()
        pokedexController.modalPresentationStyle = .fullScreen
        navigationController?.present(pokedexController, animated: true)
//        self.present(pokedexController, animated: true)
    }
    
    
}
