//
//  ViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import UIKit

final class PTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setUpTabs()
    }
    
    private func setUpTabs() {
        let pokemonVC = PPokemonViewController()
        let favoriteVC = PFavoriteViewController()
        let teamVC = PTeamViewController()
        
        pokemonVC.navigationItem.largeTitleDisplayMode = .automatic
        favoriteVC.navigationItem.largeTitleDisplayMode = .automatic
        teamVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: pokemonVC)
        let nav2 = UINavigationController(rootViewController: favoriteVC)
        let nav3 = UINavigationController(rootViewController: teamVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Character",
            image: UIImage(systemName: "circle.circle.fill"),
            tag: 1
        )
        
        nav2.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            tag: 2
        )
        
        nav3.tabBarItem = UITabBarItem(
            title: "Teams",
            image: UIImage(systemName: "person.3"),
            tag: 3
        )
        
        
        for nav in [nav1, nav2, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3],
            animated: true
        )
    }
    
}

