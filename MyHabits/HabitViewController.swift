//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/22/21.
//

import UIKit

class HabitViewController: UIViewController {
    
    // MARK: - Init`s
    
    var habit: Habit!
    var isNew: Bool = true
    
    let colorPicker = UIColorPickerViewController()
    
    let namelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название"
        return label
    }()
    
    let nameHabit: UITextField = {
        let textFieald = UITextField()
        textFieald.translatesAutoresizingMaskIntoConstraints = false
        textFieald.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textFieald.textColor = .blue
        textFieald.returnKeyType = .done
        return textFieald
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цвет"
        return label
    }()
    
    let colorView: UIImageView = {
        let colorView = UIImageView()
        colorView.image = UIImage(systemName: "circle.fill")
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Время"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let deleteButton: UIButton = {
        let but = UIButton()
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitle("Удалить привычку", for: .normal)
        but.setTitleColor(.red, for: .normal)
        return but
    }()
    
    init(habit: Habit?){
        super.init(nibName: nil, bundle: nil)
        if let habit = habit {
            self.habit = habit
            isNew = false
        }else {
            self.habit = Habit(name: "", date: Date(), color: .black)
            
        }
        configureModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigateBar()
        configureUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        [
            namelabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            namelabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            
            nameHabit.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameHabit.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 7),
            nameHabit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -65),
            
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorLabel.topAnchor.constraint(equalTo: nameHabit.bottomAnchor, constant: 15),
            
            colorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorView.widthAnchor.constraint(equalToConstant: 30),
            colorView.heightAnchor.constraint(equalToConstant: 30),
            
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 15),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
            
        ].forEach { $0.isActive = true }
    }
    
    // MARK: - Configuration
    
    func configureModel(){
        
        nameHabit.text = habit.name
        colorView.tintColor = habit.color
        
        dateLabel.attributedText = createAttributeString(from: habit.dateString)
        
        deleteButton.isHidden = isNew
    }
    
    func configureUI(){
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        view.addSubviews([namelabel, nameHabit, colorLabel, colorView, timeLabel, dateLabel, datePicker, deleteButton])
        
        colorPicker.delegate = self
        
        nameHabit.delegate = self
        nameHabit.addTarget(self, action: #selector(namehabitChanged), for: .editingChanged)
        
        colorView.isUserInteractionEnabled = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapColorView))
        colorView.addGestureRecognizer(touch)
        
        deleteButton.isUserInteractionEnabled = true
        deleteButton.addTarget(self, action:#selector(tapDelButton), for: .touchUpInside)
        
        datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        
    }
    
    func configNavigateBar(){
        
        navigationItem.title = "Создать"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor(named: "purpuleColor")
        
        let rightSaveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveNewHabit))
        rightSaveButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightSaveButton
        
        let leftBeckButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(backToHabitsVC))
        self.navigationItem.leftBarButtonItem = leftBeckButton
    }
    
    
    func createAttributeString(from dateString: String)->  NSAttributedString {
        
        var result: NSMutableAttributedString
        let stringArray = dateString.components(separatedBy: " ")
        let firstPhrase = stringArray.dropLast(1).reduce("") { partialResult, str in partialResult + " " + str }
        let secondPhrase = stringArray.dropFirst(3).joined()
        let attributesFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        result = NSMutableAttributedString(string: firstPhrase+" ",attributes: attributesFont)
        let attributesColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "purpuleColor") ?? UIColor.black]
        result.append(NSAttributedString(string: "\(secondPhrase)", attributes: attributesColor))
        
        return result
    }
    
    // MARK: - Event`s
    
    @objc func saveNewHabit(){
        guard nameHabit.text != nil else {return}
        if let inxdHabit = HabitsStore.shared.habits.firstIndex(of: habit){
            HabitsStore.shared.habits[inxdHabit] = habit
        }else{
            HabitsStore.shared.habits.append(habit)
            
        }
        backToHabitsVC()
    }
    
    
    @objc func selectDate(_ sender: UIDatePicker){
        habit?.date = sender.date
        dateLabel.attributedText = createAttributeString(from: habit.dateString)
    }
    
    @objc func tapDelButton(){
        let nameHabit = habit.name
        let msgtext = "Вы точно хотите удалить \(nameHabit) ?"
        let alert = UIAlertController(title: "Удалить привычку", message: msgtext, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            
            HabitsStore.shared.habits.removeAll { $0 == self.habit }
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backToHabitsVC(){
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapColorView(gesture: UITapGestureRecognizer) {
        colorPicker.selectedColor = colorView.tintColor
        present(colorPicker, animated: true, completion: nil)
        
    }
    
    @objc func namehabitChanged(_ textField: UITextField) {
        guard let name =  textField.text else { return }
        habit.name = name
        
    }
}

// MARK: - Extension

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorView.tintColor = viewController.selectedColor
        habit.color = viewController.selectedColor
        
    }
    
    
}

extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}
