//
//  ArtistTableViewCell.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

import UIKit
import Kingfisher

final class ArtistTableViewCell: UITableViewCell {
    //MARK: - Constants
    static let cellIdentifier = "ArtistTableViewCell"
    
    //MARK: - Views
    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumImageView.layer.cornerRadius = 10.dhs
        albumImageView.clipsToBounds = true
    }
}

//MARK: - Public Methods
extension ArtistTableViewCell {
    func configure(with item: Media) {
        guard let albumImageURLString = item.artworkUrl100 else { return }
        albumImageView.kf.setImage(with: URL(string: albumImageURLString))
        artistNameLabel.text = item.artistName
        trackNameLabel.text = item.trackName
    }
}

//MARK: - SetupUI & Layout
private extension ArtistTableViewCell {
    func setupUI() {
        contentView.backgroundColor = .SimpleApp.Main.tableViewCellBackground
        contentView.addAutolayoutSubviews(albumImageView, artistNameLabel, trackNameLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.dvs),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.dhs),
            albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.dvs),
            albumImageView.heightAnchor.constraint(equalToConstant: 300.dhs),
            albumImageView.widthAnchor.constraint(equalToConstant: 300.dhs),
            
            artistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.dvs),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 24.dhs),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.dhs),
            
            trackNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 24.dvs),
            trackNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 24.dhs),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.dhs),
        ])
    }
}
