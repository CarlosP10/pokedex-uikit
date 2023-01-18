//
//  PPokemonViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

/// Controller to show and search for pokemon
final class PPokemonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pokemons"
        let request = PRequest(
            endpoint: .pokemon,
            queryParameters: [
                URLQueryItem(name: "limit", value: "30"),
                URLQueryItem(name: "offset", value: "30"),
            ]
        )
        print(request.url!)
    }
}
