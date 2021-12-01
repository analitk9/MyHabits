//
//  HeaderCell.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/22/21.
//

import UIKit

class HeaderView:  UICollectionViewCell{
    
    //MARK: - init`s
    
    let motivationLabel: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
        
    }()
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.progress = 0.0
        progressBar.progressTintColor = UIColor(named: "purpuleColor")
        return progressBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8.0
        contentView.addSubviews([motivationLabel, progressLabel, progressBar])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        [
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            motivationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -115),
            motivationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            progressLabel.centerYAnchor.constraint(equalTo: motivationLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressBar.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ].forEach { $0.isActive = true}
    }
    
    // MARK: - Configuration
    
    func configure(progress: Float){
        progressBar.progress = progress
        progressLabel.text = "\(Int(progress*100))%"
    }
    
}
