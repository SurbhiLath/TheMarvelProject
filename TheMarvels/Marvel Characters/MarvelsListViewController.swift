//
//  ViewController.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//

import UIKit

class MarvelsListViewController: UIViewController {
    
    var viewModel: MarvelsViewModel?
    let refreshControl = UIRefreshControl()
    var isSearching : Bool = false
    var filteredTableData:[String] = []
    
    private lazy var marvelTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "No marvels found"
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "The Marvels"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
//            UIColor.cyan.cgColor
        ]
//        [UIColor(hexCode: 0xBC2E23), UIColor(hexCode: 0x376593)],
        gradient.locations = [0, 1]
        return gradient
    }()
        
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "Background Cover")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search.. "
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MarvelsViewModel(delegate: self)
        configureLayout()
        initiateTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initiateTableView() {
        marvelTableView.dataSource = self
        marvelTableView.delegate = self
        marvelTableView.register(MarvelTableCell.self, forCellReuseIdentifier: "MarvelTableCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Reload")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        marvelTableView.addSubview(refreshControl)
    }
    
    private func configureLayout() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        self.view.addSubviews([
            backgroundImageView,
            searchBar,
            statusLabel,
            marvelTableView,
            activityIndicator
        ])
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: margins.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            marvelTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            marvelTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            marvelTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            marvelTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.reloadMarvels()
    }
}

extension MarvelsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfCharacters ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = viewModel, let cell = marvelTableView.dequeueReusableCell(withIdentifier: "MarvelTableCell") as? MarvelTableCell {
            cell.configureLayout(with: viewModel.cellViewModel(for: indexPath))
            cell.selectionStyle = .none
           return cell
        }
         return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            let details = CharacterDetailsViewController()
            details.configureLayout(with: viewModel.character(for: indexPath))
            self.navigationController?.pushViewController(details, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension MarvelsListViewController: MarvelsViewModelProtocol {
    func updateMarvels() {
        self.marvelTableView.isHidden =  false
        self.activityIndicator.isHidden = true
        self.statusLabel.isHidden = true
        self.marvelTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    func loadingData() {
        self.marvelTableView.isHidden =  true
        self.activityIndicator.isHidden = false
        self.statusLabel.isHidden = true
    }
    
    func failedToFetchMarvels() {
        self.activityIndicator.isHidden = true
        self.marvelTableView.isHidden = true
        self.statusLabel.isHidden = false
        self.refreshControl.endRefreshing()
    }
}

extension MarvelsListViewController: UISearchBarDelegate {
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel?.isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel?.isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel?.isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel?.isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            viewModel?.isSearching = false
        } else {
            viewModel?.search(for: searchText)
        }
        self.marvelTableView.reloadData()
    }
}
