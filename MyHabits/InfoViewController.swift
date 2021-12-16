//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Denis Evdokimov on 11/19/21.
//

import UIKit

class InfoViewController: UIViewController {

    let infoText: UITextView = {
        let infoText = UITextView()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.textAlignment = .left
        infoText.isEditable = false
        return infoText
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configTabBar()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "lightGrayColor")
        
        
        navigationItem.title = "Информация"
    
        var allText = AttributedString("Привычка за 21 день")
        allText.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
       
        var addAtribString = AttributedString(createText())
        addAtribString.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        allText.append(addAtribString)
        infoText.attributedText = NSAttributedString(allText)
        infoText.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        view.addSubview(infoText)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoText.setContentOffset(.zero, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
       
        super.viewWillLayoutSubviews()
        [
            infoText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ].forEach { $0.isActive = true }
        
    }
    
    func configTabBar(){
        let item = UITabBarItem()
        item.image = UIImage(systemName: "info.circle.fill")
        item.title = "Информация"
        item.tag = 2
        tabBarItem = item
    }
    
    func createText()-> String {
          """
        
        
        Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:
        
            1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.
        
            2. Выдержать 2 дня в прежнем состоянии самоконтроля.
        
            3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче,
            с чем еще предстоит серьезно бороться.

            4. Поздравить себя с прохождением первого серьезного порога в 21 день.
            За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

            5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

            6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.
        """
        
    }
}


