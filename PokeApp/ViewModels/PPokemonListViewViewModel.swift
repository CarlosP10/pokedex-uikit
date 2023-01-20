//
//  PPokemonListViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import UIKit

protocol PPokemonListViewViewModelDelegate: AnyObject {
    func didLoadInitialPokemons()
    func didLoadMorePokemons(with newIndexPath: [IndexPath])
    func didSelectPokemon(_ pokemonUrl: URL?)
}

/// View model to handle character list view logic
final class PPokemonListViewViewModel: NSObject {
    
    //Weak to avoid memory leak
    public weak var delegate: PPokemonListViewViewModelDelegate?
    
    private var isLoadingMorePokemons = false
    
    private var pokemons: [PPokemonNamedAPIResource] = [] {
        didSet {
            for pokemon in pokemons {
                let viewModel = PPokemonCollectionViewCellViewModel(
                    pokemonName: pokemon.name,
                    pokemonImageUrl: URL(string: pokemon.baseImage)
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [PPokemonCollectionViewCellViewModel] = []
    
    private var apiNext: String? = nil
    
    /// Fetch initial set of Pokemon
    public func fetchPokemons() {
        PService.shared.execute(.listPokemonsRequest, expecting: PGetAllPokemonResponse.self)
        {[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.pokemons = results
                self?.apiNext = responseModel.next
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialPokemons()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
//    func fetchPokemon(_ url: URL?) {
//        PService.shared.execute(.pokemonRequest, expecting: PPokemon.self) {[weak self] result in
//            switch result {
//            case .success(let responseModel):
//                let results = responseModel.results
//                self?.pokemons = results
//                DispatchQueue.main.async {
//                    self?.delegate?.didLoadInitialPokemons()
//                }
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
//    }
    
    /// Paginate if additional pokemon are needed
    public func fetchAdditionalPokemon(url: URL) {
        guard !isLoadingMorePokemons else {
            return
        }
        isLoadingMorePokemons = true
        //Fetch Pokemon
        guard let request = PRequest(url: url) else {
            isLoadingMorePokemons = false
            print("Failed to create request")
            return
        }
        PService.shared.execute(request,
                                expecting: PGetAllPokemonResponse.self) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                
                strongSelf.apiNext = responseModel.next
                strongSelf.pokemons.append(contentsOf: moreResults)
                
                let originalCount = strongSelf.pokemons.count
                let newCount = moreResults.count
                let startingIndex = originalCount - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(originalCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMorePokemons(
                        with: indexPathsToAdd
                    )
                    strongSelf.isLoadingMorePokemons = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMorePokemons = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiNext != nil
    }
}

//MARK: - CollectionView
extension PPokemonListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let pokemonUrl = URL(string: pokemons[indexPath.row].url)
        delegate?.didSelectPokemon(pokemonUrl)
    }
    
    //FOOTER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: PFooterLoadingCollectionReusableView.identifier,
                    for: indexPath
                ) as? PFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

//MARK: - ScrollView
extension PPokemonListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMorePokemons,
              !cellViewModels.isEmpty,
              let nextUrlString = apiNext,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalPokemon(url: url)
//                DispatchQueue.global(.background).async {
//                }
            }
            
            t.invalidate()
        }
    }
}
