//
//  PPokemonTeamListView.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/31/23.
//

import UIKit

protocol PPokemonTeamListViewDelegate: AnyObject {
    func didSelectTeam()
}
/// Add View for pokemon teams
final class PPokemonTeamListView: UIView {
    
    public weak var delegate: PPokemonTeamListViewDelegate?
    
    private let viewModel = PPokemonTeamListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
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
        collectionView.register(PPokemonTeamCollectionViewCell.self, forCellWithReuseIdentifier: PPokemonTeamCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
        setUpCollectionView()
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        spinner.startAnimating()
        
        viewModel.delegate = self
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getPokemonTeams()
        }
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
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    public func didTapAdd() -> UIAlertController {
        let ac = UIAlertController(title: "Team name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {[weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.viewModel.savePokemonTeam(name: name)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return ac
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - ViewModel
extension PPokemonTeamListView: PPokemonTeamListViewViewModelDelegate {
    func reloadTeamsCollection() {
        collectionView.reloadData()
    }
    
    func didLoadTeams() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didSelectTeam() {
        delegate?.didSelectTeam()
    }
    
    
}
