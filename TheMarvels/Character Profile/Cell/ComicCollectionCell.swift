//
//  ComicCollectionCell.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 04/09/22.
//

import UIKit

class ComicCollectionCell: UICollectionViewCell {
    
    private lazy var comicImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "AppIcon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 11)
        label.textColor = .black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    
    func configureLayout(with data: Item) {
        self.addSubviews([comicImageView, titleLabel])
        
        NSLayoutConstraint.activate([
            comicImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            comicImageView.topAnchor.constraint(equalTo: self.topAnchor),
            comicImageView.heightAnchor.constraint(equalToConstant: 100),
            comicImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: comicImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: comicImageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: comicImageView.bottomAnchor, constant: 5)
        ])
        titleLabel.text = data.name
    }
}
