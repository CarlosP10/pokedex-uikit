//
//  PPokemonListView.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import UIKit

protocol PPokemonListViewDelegate: AnyObject {
    func pPokemonListView(
        didselectPokemon pokemon: PPokemon
    )
}

/// View that handles showing list of pokemons, loader, etc
final class PPokemonListView: UIView {

    public weak var delegate: PPokemonListViewDelegate?
    
    private let viewModel = PPokemonListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Donee", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(PPokemonCollectionViewCell.self, forCellWithReuseIdentifier: PPokemonCollectionViewCell.cellIdentifier)
        collectionView.register(
            PFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PFooterLoadingCollectionReusableView.identifier
        )
        return collectionView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.clipsToBounds = true
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView, spinner)
        stackView.addArrangedSubviews(doneButton,collectionView)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        DispatchQueue.global(qos: .background).async {[weak self] in
            self?.viewModel.fetchPokemons()
        }
        setUpCollectionView()
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    @objc
    private func doneTapped() {
        viewModel.doneTapped()
    }
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension PPokemonListView: PPokemonListViewViewModelDelegate {
    func didSetModeView() {
        doneButton.setTitle("Done", for: .normal)
        collectionView.allowsMultipleSelection = false
    }
    
    func didSetModeSelect() {
        doneButton.setTitle("Select", for: .normal)
        collectionView.allowsMultipleSelection = true
    }
    
    func didSelectPokemon(_ pokemon: PPokemon) {
        delegate?.pPokemonListView(didselectPokemon: pokemon)
    }
    
    func didLoadInitialPokemons() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() //Initial Fetch
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }

    func didLoadMorePokemons(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
    
}
