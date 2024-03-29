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
    func dismissButtonTapped()
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
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .yellow
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "x.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
//        button.backgroundColor = .red
//        button.contentVerticalAlignment = .top
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
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .trailing
        stack.spacing = -9
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView, spinner)
        stackView.addArrangedSubviews(buttonsStackView,collectionView)
        buttonsStackView.addArrangedSubviews(doneButton,dismissButton)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        DispatchQueue.global(qos: .background).async {[weak self] in
            self?.viewModel.fetchPokemons()
        }
        showHeaderIsHidden(true)
        setUpCollectionView()
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public func showHeaderIsHidden(_ bool: Bool){
        buttonsStackView.isHidden = bool
        viewModel.isHeaderHidden = bool
        collectionView.allowsMultipleSelection = !bool
    }
    
    @objc
    private func doneTapped() {
        viewModel.doneTapped()
        doneButton.shine()
    }
    
    @objc
    private func dismissButtonTapped() {
        viewModel.dismissTapped()
        delegate?.dismissButtonTapped()
        dismissButton.shine()
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension PPokemonListView: PPokemonListViewViewModelDelegate {
    func didDeselectPokemon(at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func didSetModeSelect(isEmpty: Bool) {
        isEmpty
        ? doneButton.setTitle("Select", for: .normal)
        : doneButton.setTitle("Done", for: .normal)
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
