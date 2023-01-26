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
        let likeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItems = [shareItem, likeItem]
        
        title = viewModel.title
        view.addSubview(detailView)
        addConstraints()
        
    }
    
    @objc
    private func didTapShare() {
        // Share Pokemon info
    }
    
    @objc
    private func didTapSave() {
        // Save Pokemon info
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
