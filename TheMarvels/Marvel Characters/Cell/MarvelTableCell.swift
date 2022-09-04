//
//  MarvelTableCell.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//
import SDWebImage
import UIKit

class MarvelTableCell: UITableViewCell {
    var viewModel: MarvelTableCellViewModel? {
        didSet {
            self.updateData()
        }
    }
    private lazy var mainContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    private lazy var characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        let bookmarkImage = "Icon bookmark-1"
        button.setImage(UIImage(named: bookmarkImage), for: .normal)
        button.addTarget(self, action: #selector(bookmark), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cardView: BaseSquareContentCard = {
        let cardView = BaseSquareContentCard(
            with: mainContent,
            and: CGRect(x: 0, y: 0, width: 300, height: 220)
        )
        return cardView
    }()
    
    @objc func bookmark() {
        if let viewModel = viewModel {
            if viewModel.character.isBookmarked {
                bookmarkButton.setImage(UIImage(named: "Icon bookmark-1"), for: .normal)
            } else {
                bookmarkButton.setImage(UIImage(named: "Icon bookmark"), for: .normal)
            }
            viewModel.character.bookmark()
        }
    }
    
    func configureLayout(with viewModel: MarvelTableCellViewModel) {
        self.addSubview(cardView)
        mainContent.addSubviews([
            titleLabel,
            characterImageView,
            bookmarkButton
        ])
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            characterImageView.leadingAnchor.constraint(equalTo: mainContent.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: mainContent.topAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: mainContent.bottomAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 105),
            characterImageView.widthAnchor.constraint(equalToConstant: 105),
            
            titleLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            
            bookmarkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bookmarkButton.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        backgroundColor = .clear
        self.viewModel = viewModel
    }
    
    func updateData() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.character.name
        if let url = URL(string: viewModel.character.thumbnail.imageURL) {
            characterImageView.sd_setImage(with: url)
        }
        let bookmarkImage = viewModel.character.isBookmarked ? "Icon bookmark" : "Icon bookmark-1"
        bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    }
}
