//
//  PPokemonFavoriteListView.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/28/23.
//

import UIKit
import FirebaseFirestore

protocol PPokemonFavoriteListViewDelegate: AnyObject {
    func pPokemonListView(
        _ pokemonListView: PPokemonFavoriteListView,
        didSelectPokemon pokemon: PPokemon
    )
}

final class PPokemonFavoriteListView: UIView {
    
    public weak var delegate: PPokemonFavoriteListViewDelegate?
    
    private let viewModel = PPokemonFavoriteListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PPokemonCollectionViewCell.self,
                                forCellWithReuseIdentifier: PPokemonCollectionViewCell.cellIdentifier
        )
        collectionView.register(PFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PFooterLoadingCollectionReusableView.identifier
        )
        return collectionView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        setUpConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchPokemonFirebase()
        setUpCollectionView()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PPokemonFavoriteListView: PPokemonFavoriteListViewViewModelDelegate {
    func didSelectPokemon(_ pokemon: PPokemon) {
        delegate?.pPokemonListView(self, didSelectPokemon: pokemon)
    }
    
    func didLoadAdditionalFavoritesPokemons(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
    
    func didLoadFavoritesPokemons() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    
}
