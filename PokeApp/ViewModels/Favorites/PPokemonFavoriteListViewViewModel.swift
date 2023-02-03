//
//  PPokemonFavoriteListViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/28/23.
//

import UIKit
import FirebaseFirestore

protocol PPokemonFavoriteListViewViewModelDelegate: AnyObject {
    func didLoadFavoritesPokemons()
    func didLoadAdditionalFavoritesPokemons(with newIndexPath: [IndexPath])
    func didSelectPokemon(_ pokemon: PPokemon)
}

final class PPokemonFavoriteListViewViewModel: NSObject {
    
    public weak var delegate: PPokemonFavoriteListViewViewModelDelegate?
    
    private var isLoading = false
    
    private var pokemons: [PPokemon] = [] {
        didSet {
            for pokemon in pokemons {
                let vm = PPokemonCollectionViewCellViewModel(
                    pokemonName: pokemon.name,
                    pokemonImageUrl: URL(string: pokemon.baseImage)
                )
                if !cellViewModels.contains(vm){
                    cellViewModels.append(vm)
                }
            }
        }
    }
    
    public var shouldUpdateIndicator: Bool = false
    
    private var cellViewModels: [PPokemonCollectionViewCellViewModel] = []
    
    public func fetchPokemonFirebase() {
        PFirestoreService.shared.getDocs(
            .favorites) {[weak self] snapshot, error in
                guard let strongSelf = self else { return }
                if let snapshot = snapshot {
                    for snapshot in snapshot.documents {
                        let _ = Result {
                            try strongSelf.pokemons.append(snapshot.data(as: PPokemon.self))
                        }
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { t in
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didLoadFavoritesPokemons()
                    }
                    t.invalidate()
                }
            }
    }
    
    public func fetchAdditionalPokemonFirebase() {
        guard !isLoading else { return }
        isLoading = true
        
        PFirestoreService.shared.getDocs(
            .favorites) {[weak self] snapshot, error in
                guard let strongSelf = self else { return }
                if let snapshot = snapshot {
                    let moreData = snapshot.documents
                    
                    let originalCount = strongSelf.pokemons.count
                    let newCount = moreData.count
                    let startIndex = originalCount - newCount
                    let indexPathToAdd: [IndexPath] = Array(startIndex..<originalCount).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    for snapshot in snapshot.documents {
                        let _ = Result {
                            try strongSelf.pokemons.append(snapshot.data(as: PPokemon.self))
                        }
                    }
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didLoadAdditionalFavoritesPokemons(with: indexPathToAdd)
                    }
                }
                strongSelf.isLoading = false
            }
    }
}

//MARK: - CollectionView
extension PPokemonFavoriteListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PPokemonCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? PPokemonCollectionViewCell else {
            fatalError("Unsopported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let pokemon = pokemons[indexPath.row]
        delegate?.didSelectPokemon(pokemon)
    }
    
    //HEADER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? PFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        header.startAnimating()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard !isLoading else {
//        }
        return .zero
//        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

//MARK: - ScrollView
extension PPokemonFavoriteListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= 0 {
            guard !isLoading,
                  !cellViewModels.isEmpty else {
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {[weak self] t in
//                self?.fetchAdditionalPokemonFirebase()
                t.invalidate()
            }
        }
    }

}
