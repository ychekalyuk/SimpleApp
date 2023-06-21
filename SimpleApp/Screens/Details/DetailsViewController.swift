//
//  DetailViewController.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//

import UIKit

protocol DetailsViewControllerProtocol: AnyObject {
    func loadUI(with item: Media)
    func loadUI(savedMedia: SavedMedia)
}

final class DetailsViewController: UIViewController {
    //MARK: - Views
    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .SimpleApp.Details.artistNameLabelText
        return label
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .SimpleApp.Details.trackNameLabelText
        return label
    }()
    
    //MARK: - Public Properties
    var presenter: DetailsViewPresenterProtocol!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.didLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumImageView.layer.cornerRadius = 10.dhs
        albumImageView.clipsToBounds = true
    }
}

//MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {
    func loadUI(with item: Media) {
        guard let albumImageURLString = item.artworkUrl100 else { return }
        albumImageView.kf.setImage(with: URL(string: albumImageURLString))
        artistNameLabel.text = item.artistName
        trackNameLabel.text = item.trackName
    }
    
    func loadUI(savedMedia: SavedMedia) {
        artistNameLabel.text = savedMedia.artistName
        trackNameLabel.text = savedMedia.trackName
        guard let data = savedMedia.artworkUrl100 else { return }
        albumImageView.image =  UIImage(data: data)
    }
}

//MARK: - SetupUI & Layout
private extension DetailsViewController {
    func setupUI() {
        view.backgroundColor = .SimpleApp.Details.background
        view.addAutolayoutSubviews(albumImageView, artistNameLabel, trackNameLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.dvs),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 600.dhs),
            albumImageView.heightAnchor.constraint(equalToConstant: 600.dhs),
            
            artistNameLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 24.dvs),
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.dhs),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.dhs),
            
            trackNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 24.dvs),
            trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.dhs),
            trackNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.dhs),
        ])
    }
}
