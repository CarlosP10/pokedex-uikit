//
//  PPokemonDetailView.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import UIKit

/// View for single pokemon info
final class PPokemonDetailView: UIView {
    
    //MARK: - UI
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myPickerViewValues = ["Uno", "Dos" , "Tres"]
    
    private let haptic = UISelectionFeedbackGenerator()
    
    private let segmentedViews: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    public var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PPokemonDetailInfoTableViewCell.self,
            forCellReuseIdentifier: PPokemonDetailInfoTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: PPokemonDetailViewViewModel
    
    //MARK: - Init
    
    init(frame: CGRect, viewModel: PPokemonDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        addSubviews(viewContainer,imageView, spinner)
        viewContainer.addSubviews(tableView, segmentedViews)
        setUpSegmentedView()
        setUpConstraints()
        spinner.startAnimating()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Private
    
    private func setUpConstraints(){
        let bounds = UIScreen.main.bounds
        let width = (bounds.height - 30)/2
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -width),
            
            viewContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -45),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            segmentedViews.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 15),
            segmentedViews.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            segmentedViews.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            segmentedViews.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: segmentedViews.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            
        ])
    }
    
    private func setUpSegmentedView() {
        haptic.prepare()
        segmentedViews.removeAllSegments()
        
        for (index, value) in myPickerViewValues.enumerated() {
            segmentedViews.insertSegment(withTitle: value, at: index, animated: true)
        }
        segmentedViews.selectedSegmentIndex = 0
        segmentedViews.addTarget(self, action: #selector(viewChanged), for: .valueChanged)
    }
    
    @objc
    private func viewChanged() {
        haptic.selectionChanged()
    }
    
    public func configure(){
        DispatchQueue.global(qos: .background).async {[weak self] in
            self?.viewModel.fetchPokemon()
        }
        
        viewModel.registerForData { [weak self] data in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.tableView.dataSource = strongSelf.viewModel
                strongSelf.tableView.delegate = strongSelf.viewModel
            }
            
            strongSelf.viewModel.fetchImage { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        strongSelf.spinner.stopAnimating()
                        
                        let image = UIImage(data: data)
                        strongSelf.imageView.image = image
                        strongSelf.viewContainer.isHidden = false
                        UIView.animate(withDuration: 0.4) {
                            strongSelf.viewContainer.alpha = 1
                        }
                    }
                case .failure(let error):
                    print(String(describing: error))
                    break
                }
            }
            
        }
    }
    
}
