//
//  PPokemonCollectionViewCell.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import UIKit

/// Single Cell for a Pokemon
class PPokemonCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "PPokemonCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let highlightIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.blue)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(highlightIndicator,checkImage,imageView, nameLabel)
        addConstraints()
        setUpLayer() 
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            checkImage.isHidden = !isSelected
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            checkImage.heightAnchor.constraint(equalToConstant: 40),
            checkImage.widthAnchor.constraint(equalToConstant: 40),
            checkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            checkImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            highlightIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    public func configure(with viewModel: PPokemonCollectionViewCellViewModel){
        nameLabel.text = viewModel.pokemonName.capitalized
        viewModel.fetchImage {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
