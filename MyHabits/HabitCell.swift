//
//  HabitCell.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/22/21.
//

import UIKit


protocol tapViewDelegate{
    func tapView()
}

class HabitCell: UICollectionViewCell {
    
    // MARK: - Init`s
    
    var tapDelegate: tapViewDelegate?
    
    var habit: Habit?
    
    let nameHabitLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateHabitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let countMakeHabitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let checkViewImage: UIImageView = {
        let checkImage = UIImageView(frame: .zero)
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        checkImage.isUserInteractionEnabled = true
        
        return checkImage
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([nameHabitLabel, dateHabitLabel,countMakeHabitLabel,checkViewImage])
        layer.cornerRadius = 8.0
        backgroundColor = .white
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapCheckView))
        checkViewImage.addGestureRecognizer(touch)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        [
            nameHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            nameHabitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            dateHabitLabel.leadingAnchor.constraint(equalTo: nameHabitLabel.leadingAnchor),
            dateHabitLabel.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor,constant: 5),
            dateHabitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            countMakeHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countMakeHabitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            countMakeHabitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            
            
            checkViewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            checkViewImage.widthAnchor.constraint(equalToConstant: 40),
            checkViewImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkViewImage.heightAnchor.constraint(equalToConstant: 40)
        ].forEach { $0.isActive = true }
        
    }
    
    override func prepareForReuse() {
        nameHabitLabel.text = nil
        dateHabitLabel.text = nil
        countMakeHabitLabel.text = nil
        checkViewImage.image = nil
    }
    
    // MARK: - Configuration
    
    func configure(with habit: Habit){
        self.habit = habit
        nameHabitLabel.text = habit.name
        nameHabitLabel.textColor = habit.color
        
        dateHabitLabel.text = habit.dateString
        countMakeHabitLabel.text = "Счётчик: \(String(habit.trackDates.count))"
        let checkImage = habit.isAlreadyTakenToday ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        checkViewImage.image = checkImage
        checkViewImage.tintColor = habit.color
        
    }
    
    // MARK: - Event
    
    @objc func tapCheckView(){
        // нажатие должна обрабатывать коллекция и после обновлять данные
        guard let habit = habit, !habit.isAlreadyTakenToday  else {return}
        
        checkViewImage.image = UIImage(systemName: "checkmark.circle.fill")
        HabitsStore.shared.track(habit)
        tapDelegate?.tapView()
        
    }
    
    
}
