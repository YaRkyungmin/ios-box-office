//
//  BoxOfficeCollectionViewCell.swift
//  BoxOffice
//
//  Created by kyungmin, Erick on 2023/07/31.
//

import UIKit

class BoxOfficeCollectionViewCell: UICollectionViewCell {
    let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    
    let rankChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        
        return label
    }()
    
    let movieInfomationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    let audienceCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    let forwardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .systemGray
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoxOfficeCollectionViewCell {
    func configureUI() {
        rankStackView.addArrangedSubview(rankLabel)
        rankStackView.addArrangedSubview(rankChangeLabel)
        movieInfomationStackView.addArrangedSubview(movieTitleLabel)
        movieInfomationStackView.addArrangedSubview(audienceCountLabel)
        
        contentView.addSubview(rankStackView)
        contentView.addSubview(movieInfomationStackView)
        contentView.addSubview(forwardImageView)
    }
    
    func setupConstraint() {
        setupRankStackVeiwConstraint()
        setupMovieInfomationStackViewConstraint()
        setupForwardImageViewConstraint()
    }
    
    func setupRankStackVeiwConstraint() {
        NSLayoutConstraint.activate([
            rankStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            rankStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupMovieInfomationStackViewConstraint() {
        NSLayoutConstraint.activate([
            movieInfomationStackView.leadingAnchor.constraint(equalTo: rankStackView.trailingAnchor, constant: 32),
            movieInfomationStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupForwardImageViewConstraint() {
        NSLayoutConstraint.activate([
            forwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            forwardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            forwardImageView.widthAnchor.constraint(equalToConstant: 12),
            forwardImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}