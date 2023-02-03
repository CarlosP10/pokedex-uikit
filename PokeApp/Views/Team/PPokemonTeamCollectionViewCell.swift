//
//  PPokemonTeamCollectionViewCell.swift
//  PokeApp
//
//  Created by Carlos Paredes on 2/1/23.
//

import UIKit

/// Custom cell for Team collections
final class PPokemonTeamCollectionViewCell: UICollectionViewCell {
    static let identifier = "PPokemonTeamCollectionViewCell"
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(teamLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            teamLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            teamLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(name: String) {
        teamLabel.text = name.capitalized
    }
}
