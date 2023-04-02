//
//  PPokemonDetailViewController.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import UIKit

/// Controller to show info about single pokemon
final class PPokemonDetailViewController: UIViewController {
    private let viewModel: PPokemonDetailViewViewModel
    
    private let detailView: PPokemonDetailView
    
    private var isFavorite: Bool = false
    
    //MARK: - Init
    init(viewModel: PPokemonDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = PPokemonDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        PFirestoreService.shared.getData(
            .favorites,
            viewModel.title) { document, error in
                if let document = document, document.exists {
                    self.isFavorite = true
                }
                let likeItem = self.setUpFavoriteButton(self.isFavorite)
                self.navigationItem.rightBarButtonItems = [shareItem, likeItem]
            }
        
        title = viewModel.title
        view.addSubview(detailView)
        addConstraints()
        
    }
    
    private func setUpFavoriteButton(_ isFavorite: Bool) -> UIBarButtonItem {
        let name = isFavorite ? "heart.fill" : "heart"
        let likeItem = UIBarButtonItem(
            image: UIImage(systemName: name)?.withTintColor(.red, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapSave)
        )
        return likeItem
    }
    
    @objc
    private func didTapShare() {
        // Share Pokemon info
    }
    
    @objc
    private func didTapSave() {
        // Save Pokemon info
        if isFavorite {
            PFirestoreService.shared.deleteData(
                .favorites,
                viewModel.title
            )
        }
        if !isFavorite {
            PFirestoreService.shared.setData(
                .favorites,
                viewModel.title,
                viewModel.pokemon
            )
        }
        isFavorite.toggle()
        navigationItem.rightBarButtonItems![1] = setUpFavoriteButton(isFavorite)
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
           detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
