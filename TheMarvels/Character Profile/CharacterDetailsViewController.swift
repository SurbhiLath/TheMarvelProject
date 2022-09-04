//
//  CharacterDetailsViewController.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 03/09/22.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    var viewModel: CharacterDetailsViewModel? {
        didSet {
            updateData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
   
    
    private var backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var comicsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Comics"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var comicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 267, height: 252)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 45, width: 100, height: 120), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    func configureLayout(with characterDetails: Marvel) {
        view.addSubviews([backgroundImage, descriptionLabel, titleLabel, comicCollectionView, comicsLabel])
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: backgroundImage.widthAnchor, multiplier: 1),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            comicsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            comicsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            comicsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            comicCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicCollectionView.topAnchor.constraint(equalTo: comicsLabel.bottomAnchor, constant: 10),
            comicCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        view.backgroundColor = .white
        initaliseCollectionView()
        viewModel = CharacterDetailsViewModel(character: characterDetails)
    }
    
    func initaliseCollectionView() {
        comicCollectionView.register(ComicCollectionCell.self, forCellWithReuseIdentifier: "ComicCollectionCell")
        comicCollectionView.dataSource = self
        comicCollectionView.delegate = self
    }
    
    func updateData() {
        if let viewModel = viewModel {
            if let url = viewModel.thumbnail {
                backgroundImage.sd_setImage(with: url)
            }
            descriptionLabel.text = viewModel.characterDescription
            titleLabel.text = viewModel.name
            comicCollectionView.reloadData()
        }
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCollectionCell", for: indexPath) as? ComicCollectionCell {
            if let comic = viewModel?.getComic(for: indexPath) {
                cell.configureLayout(with: comic)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.comicsCount ?? 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }

}
