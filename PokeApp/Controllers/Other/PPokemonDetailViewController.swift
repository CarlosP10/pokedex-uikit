//
//  PPokemonDetailViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import UIKit

/// Controller to show info about single pokemon
final class PPokemonDetailViewController: UIViewController {
    
    init(viewModel: PPokemonDetailViewViewModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}
