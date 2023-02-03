//
//  PPokemonDetailView.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import UIKit
import SVGKit

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
    
    private let haptic = UISelectionFeedbackGenerator()
    
    private let segmentedViews: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.backgroundColor = .clear
        segmented.tintColor = .clear
        segmented.alpha = 0
        segmented.setTitleTextAttributes([.foregroundColor : UIColor.label ], for: .selected)
        segmented.setTitleTextAttributes([.foregroundColor : UIColor.secondaryLabel], for: .normal)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.alpha = 0
        tableView.register(
            PPokemonDetailInfoTableViewCell.self,
            forCellReuseIdentifier: PPokemonDetailInfoTableViewCell.identifier
        )
        tableView.register(
            PPokemonDetailStatsTableViewCell.self,
            forCellReuseIdentifier: PPokemonDetailStatsTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
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
            
            viewContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -25),
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
        
        for (index, value) in viewModel.details.enumerated() {
            segmentedViews.insertSegment(withTitle: value.displayTitle, at: index, animated: true)
        }
        segmentedViews.selectedSegmentIndex = 0
        segmentedViews.addTarget(self, action: #selector(viewChanged), for: .valueChanged)
    }
    
    @objc
    private func viewChanged() {
        haptic.selectionChanged()
        viewModel.cellView = segmentedViews.selectedSegmentIndex
        tableView.reloadData()
    }
    
    private func loadViewInitial(data: Data) {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        spinner.stopAnimating()
        let image = SVGKImage(data: data)
//        let image = UIImage(data: data)
        imageView.image = image?.uiImage
        viewContainer.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.viewContainer.alpha = 1
            self.segmentedViews.alpha = 1
            self.tableView.alpha = 1
        }
        
        setUpSegmentedView()
    }
    
    public func configure(){
        viewModel.fetchImage { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.loadViewInitial(data: data)
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
