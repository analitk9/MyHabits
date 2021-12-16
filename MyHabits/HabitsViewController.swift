//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/19/21.
//

import UIKit

class HabitsViewController: UIViewController {
    
    //MARK: - init`s
    
    private let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private let itemsPerRow: CGFloat = 1
    
    fileprivate enum CellReuseID: String {
        case sectionHeader = "HabitCollectionHeaderCell"
        case habitCell = "HabitCollectionViewCell"
    }
    
    let habitsStore = HabitsStore.shared
    
    let habitsViewCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "lightGrayColor")
        
        return collection
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configTabBar()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Сегодня"
        
        configNavigateBar()
        view.addSubview(habitsViewCollection)
        
        habitsViewCollection.delegate = self
        habitsViewCollection.dataSource = self
        habitsViewCollection.register(HabitCell.self, forCellWithReuseIdentifier: CellReuseID.habitCell.rawValue)
        habitsViewCollection.register(HeaderView.self, forCellWithReuseIdentifier: CellReuseID.sectionHeader.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habitsViewCollection.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [
            habitsViewCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsViewCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsViewCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            habitsViewCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ].forEach { $0.isActive = true }
    }
    
    // MARK: - Configuration
    
    func configTabBar() {
        let item = UITabBarItem()
        item.image = UIImage(named: "Shape")
        item.title = "Привычки"
        tabBarItem.tag = 1
        tabBarItem = item
    }
    
    func configNavigateBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabitPress))
        
        navigationController?.navigationBar.tintColor = UIColor(named: "purpleColor")
    }
    
    // MARK: - Events
    
    @objc func addHabitPress(){
        let vc = HabitViewController(habit: nil)
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension
extension HabitsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let vc = HabitDetailView()
            vc.habit = habitsStore.habits[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return habitsStore.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            guard let cel = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                CellReuseID.habitCell.rawValue, for: indexPath) as? HabitCell  else { fatalError()}
            
            cel.configure(with: habitsStore.habits[indexPath.row])
            cel.tapDelegate = self
            
            return cel
        } else {
            guard let cel = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                CellReuseID.sectionHeader.rawValue, for: indexPath) as? HeaderView  else { fatalError()}
            cel.configure(progress: habitsStore.todayProgress)
            
            return cel
            
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            let paddingSpace = 2*sectionInsets.left + (itemsPerRow + 1)*sectionInsets.left
            let availableWidth = UIScreen.main.bounds.width - paddingSpace
            let widthPerItem = round(availableWidth / itemsPerRow)
            return CGSize(width: widthPerItem, height: widthPerItem / 2)
        }else {
            let paddingSpace = 2*sectionInsets.left + (itemsPerRow + 1)*sectionInsets.left
            let availableWidth = UIScreen.main.bounds.width - paddingSpace
            let widthPerItem = round(availableWidth / itemsPerRow)
            return CGSize(width: widthPerItem, height: widthPerItem / 5.71)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    
}

extension HabitsViewController: tapViewDelegate{
    func tapView() {
        habitsViewCollection.reloadData()
    }
    
    
}
