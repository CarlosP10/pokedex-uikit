//
//  PPokemonTeamListViewViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 2/7/23.
//

import UIKit
import FirebaseFirestore

protocol PPokemonTeamListViewViewModelDelegate: AnyObject {
    func didSelectTeam()
    func didLoadTeams()
    func reloadTeamsCollection()
}

final class PPokemonTeamListViewViewModel: NSObject {
    //MARK: - Constants
    private var teams = [PPokemonTeams]()
    
    public weak var delegate: PPokemonTeamListViewViewModelDelegate?
    
    public func getPokemonTeams() {
        PFirestoreService.shared.getDocs(
            .teams) {[weak self] snapshot, error in
                guard let strongSelf = self else { return }
                if let snapshot = snapshot {
                    for snapshot in snapshot.documents {
                        let _ = Result {
                            try strongSelf.teams.append(snapshot.data(as: PPokemonTeams.self))
                        }
                    }
                }
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadTeams()
                }
            }
    }
    
    public func savePokemonTeam(name: String) {
        let date = Double(Date().timeIntervalSince1970)
        let team = PPokemonTeams(teamName: name, createdDate: date)
        PFirestoreService.shared.setData(
            .teams,
            name,
            team
        )
        teams.append(team)
        delegate?.reloadTeamsCollection()
    }
    
    public func deletePokemonTeam(name: String) {
        PFirestoreService.shared.deleteData(
            .teams,
            name
        )
        //TODO: Remove teams from index or name
//        teams.append(team)
        delegate?.reloadTeamsCollection()
    }
}

//MARK: - CollectionView
extension PPokemonTeamListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PPokemonTeamCollectionViewCell.identifier,
            for: indexPath
        ) as? PPokemonTeamCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(name: teams[indexPath.row].teamName)
        
        //TODO: CELL
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-45)/2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectTeam()
    }
}
