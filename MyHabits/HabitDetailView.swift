//
//  HabitDetailView.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/26/21.
//

import UIKit

class HabitDetailView: UIViewController {
    
    // MARK: - Init`s
    
    var habit: Habit!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "lightGrayColor")
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        configNavigateBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
    
    // MARK: - Configuration
    
    func configNavigateBar(){
        
        navigationItem.title = habit.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor(named: "purpleColor")
        
        let rightSaveButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(tapEditButton))
        navigationItem.rightBarButtonItem = rightSaveButton
        
    }
    
    func returnFormated(_ curDate: Date )-> String {
        
        let stringDate =  dateFormatter.string(from: curDate)
        
        return stringDate
    }
    
    // MARK: - Event`s
    
    @objc func tapEditButton(){
        let vc = HabitViewController(habit: habit)
        
        vc.modalPresentationStyle = .overFullScreen
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func backToHabitsVC(){
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension

extension HabitDetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "Активность"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .lightGray
        
        
        headerView.addSubview(label)
        
        return headerView
    }
    
}

extension HabitDetailView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habit.trackDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let curDate = habit.trackDates.reversed()[indexPath.row]
      //  guard let indx = HabitsStore.shared.dates.firstIndex(of: curDate) else {return cell}
        cell.textLabel?.text =   returnFormated(curDate) //HabitsStore.shared.trackDateString(forIndex: indx) //
       
        if HabitsStore.shared.habit(habit, isTrackedIn: curDate) {
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
    
    
    
}
