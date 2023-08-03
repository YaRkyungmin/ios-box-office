//
//  BoxOfficeViewController.swift
//  BoxOffice
//
//  Created by kyungmin, Erick on 2023/07/24.
//

import UIKit

final class BoxOfficeViewController: UIViewController {
    private let boxOfficeManager = BoxOfficeManager()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DailyBoxOfficeData>!
    private var collectionView: UICollectionView!
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupCollectionView()
        setupDataSource()
        setupRefreshControl()
        loadBoxOfficeData()
        
        configureUI()
        setupConstraint()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = FormatManager.bringDateString(before: 1, with: FormatManager.navigationDateFormat)
    }
    
    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BoxOfficeCollectionViewCell.self, forCellWithReuseIdentifier: BoxOfficeCollectionViewCell.identifier)
        collectionView.dataSource = dataSource
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.21))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2.1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOfficeData>(collectionView: collectionView) { collectionView, indexPath, dailyBoxOfficeData in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeCollectionViewCell.identifier, for: indexPath) as? BoxOfficeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setupBoxOfficeData(dailyBoxOfficeData)
            return cell
        }
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadBoxOfficeData(refresh:)), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func loadBoxOfficeData() {
        boxOfficeManager.fetchBoxOffice { error in
            if let error {
                print(error.localizedDescription)
                
                let alert = UIAlertController.makedBasicAlert(NameSpace.fail, NameSpace.loadDataFail, actionTitle: NameSpace.check, actionType: .default)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(alert, animated: true)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.updateCollectionViewData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func reloadBoxOfficeData(refresh: UIRefreshControl) {
        boxOfficeManager.fetchBoxOffice { error in
            if let error {
                print(error.localizedDescription)
                
                let alert = UIAlertController.makedBasicAlert(NameSpace.fail, NameSpace.loadDataFail, actionTitle: NameSpace.check, actionType: .default)
                
                DispatchQueue.main.async {
                    refresh.endRefreshing()
                    self.present(alert, animated: true)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.updateCollectionViewData()
                refresh.endRefreshing()
            }
        }
    }
    
    private func updateCollectionViewData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DailyBoxOfficeData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(boxOfficeManager.dailyBoxOfficeDatas, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: setup UI
extension BoxOfficeViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraint() {
        setupCollectionViewConstraint()
        setupActivityIndicatorConstraint()
    }
    
    private func setupCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicatorConstraint() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}

// MARK: Name Space
extension BoxOfficeViewController {
    enum NameSpace {
        static let fail = "실패"
        static let loadDataFail = "데이터 로드에 실패했습니다."
        static let check = "확인"
    }
}
