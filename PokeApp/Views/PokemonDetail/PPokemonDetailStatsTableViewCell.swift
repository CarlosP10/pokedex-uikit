//
//  PPokemonDetailStatsTableViewCell.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/26/23.
//

import UIKit

/// Custom cell for Detail stats pokemon
class PPokemonDetailStatsTableViewCell: UITableViewCell {
    static let identifier = "PPokemonDetailStatsTableViewCell"
    
    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressViewIndicator: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = .secondarySystemBackground
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel, statsLabel, progressViewIndicator)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let frame = contentView.frame
        let width = frame.width
        let hConstant: CGFloat = 15
        let vConstant: CGFloat = 10
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: vConstant),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: hConstant),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -hConstant),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -vConstant),
            
            titleLabel.widthAnchor.constraint(equalToConstant: width/3),
            
            statsLabel.widthAnchor.constraint(equalToConstant: width/6),
            
            progressViewIndicator.widthAnchor.constraint(equalToConstant: width/2),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        statsLabel.text = nil
        progressViewIndicator.progress = 0
    }
    
    public func configure(with viewModel: PPokemonDetailStatsTableViewCellViewModel){
        titleLabel.text = viewModel.titleStatDisplay
        statsLabel.text = "\(viewModel.scoreStat)"
        
        let color = viewModel.scoreStat > 50 ? UIColor(red: 0.55, green: 0.82, blue: 0.65, alpha: 1.00) : UIColor.red
        progressViewIndicator.progress = Float(viewModel.scoreStat) / Float(100)
        progressViewIndicator.progressTintColor = color
    }
}
