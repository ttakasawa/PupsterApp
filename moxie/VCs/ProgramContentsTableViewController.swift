//
//  ProgramContentsTableViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
//import Spring
import SCLAlertView

enum ProgramContentsType {
    case lesson
    case article
}

protocol ProgramContentsDisplayable {
    var name: String { get }
    var id: String { get }
    var cellType: ProgramContentsType { get }
}

extension GlobalLesson: ProgramContentsDisplayable {
    var cellType: ProgramContentsType {
        return ProgramContentsType.lesson
    }
}

extension Article: ProgramContentsDisplayable{
    var name: String {
        return self.title
    }
    
    var cellType: ProgramContentsType {
        return ProgramContentsType.article
    }
}


class ProgramContentsTableViewController: UITableViewController, Stylable {
    
    var network: TypeNetwork
    var user: UserData
    var program: Program
    var contentsType: ProgramContentsType = .lesson
    
    var cellData: [ProgramContentsDisplayable] = []
    
    var enrolledLessons: [GlobalLesson] = []
    var lessonCompleted: [Bool] = []
    
    var recommendedArticles: [Article] = []
    
    init(network: TypeNetwork, user: UserData){
        self.network = network
        self.user = user
        self.program = user.programs![0]
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.register(ProgramContentsTableViewCell.self, forCellReuseIdentifier: "contentCell")
        
        self.tableView.separatorStyle = .none
        
        self.contentsType = .lesson
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        
        backButton.addTarget(self, action: #selector(self.removeMenu), for: .touchUpInside)
        lessonButton.addTarget(self, action: #selector(self.injectLessonsData), for: .touchUpInside)
        articlButton.addTarget(self, action: #selector(self.injectArticleData), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.maximizeView()
    }
    
    func setNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
        
        let switchTypeButton: UIBarButtonItem = {
            let b = UIBarButtonItem()
            //b.image = #imageLiteral(resourceName: "chatIcon")
            b.title = "Articles"
            b.style = .plain
            b.target = self
            b.action = #selector(optionOpen)
            b.tintColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
            return b
        }()
        
        self.navigationItem.rightBarButtonItem = switchTypeButton
    }
    
    
    @objc func minimizeView() {
        UIView.animate(withDuration: 0.7) {
            self.view.transform = CGAffineTransform(scaleX: 0.935, y: 0.935)
        }
    }
    
    @objc func maximizeView() {
        UIView.animate(withDuration: 0.7) {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }

        //UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
    
    var count: Int = 0
    
    func configure(){
        
        for i in 0..<self.user.programs![0].subPrograms.count {
            let subProgram = self.user.programs![0].subPrograms[i]
            for j in 0..<subProgram.globalLessonIds.count {
                
                self.lessonCompleted.append(subProgram.areCompleted[j])
                
                self.network.getLessonContent(lessonId: subProgram.globalLessonIds[j]) { (lessonContent) in
                    self.enrolledLessons.append(lessonContent)
                    self.tableView.reloadData()
                    self.switchContentsType(type: .lesson)
                }
            }
        }
        
        if let readArticleIds = self.user.readArticleIds {
            var tampIdArray: [String] = []
            for i in 0..<readArticleIds.count {
                self.network.getArticleContent(articleId: readArticleIds[i]) { (articleContent) in
                    
                    if (tampIdArray.contains(obj: articleContent.id) == false){
                        self.recommendedArticles.append(articleContent)
                        tampIdArray.append(articleContent.id)
                    }
                    
                    self.tableView.reloadData()
                    //self.switchContentsType(type: .article)
                }
            }
        }
        
    }
    
    
    
    func articleEmptyAlert(){
        let alert = SCLAlertView()
        alert.addButton("Okay") {
            self.switchContentsType(type: .lesson)
        }
        alert.showInfo("Hey there", subTitle: "All of the articles you read will appear here.")
    }
    
    func switchContentsType(type: ProgramContentsType){
        if type == .lesson{
            self.contentsType = .lesson
            self.cellData = self.enrolledLessons
            self.navigationItem.rightBarButtonItem?.title = "Articles"
        }else{
            self.contentsType = .article
            self.cellData = self.recommendedArticles
            if self.recommendedArticles.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.articleEmptyAlert()
                }
                
            }
            self.navigationItem.rightBarButtonItem?.title = "Lessons"
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! ProgramContentsTableViewCell

        cell.selectionStyle = .none
        cell.title = cellData[indexPath.row].name
        
        if self.contentsType == .lesson {
            cell.isCompleted = lessonCompleted[indexPath.row]
        }else{
            cell.isCompleted = true
        }
        cell.layoutSubviews()
        
        return cell
    }
    
    
    let baseView = UIView()
    let backButton = UIButton()
    let leftView = UIView()
    let articlButton = UIButton()
    let lessonButton = UIButton()
    
    @objc func optionOpen(){
        
        articlButton.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(articlButton)
        articlButton.backgroundColor = .clear
        articlButton.setTitleColor(.white, for: .normal)
        articlButton.setTitle("Articles", for: .normal)
        articlButton.titleLabel?.font = self.getTitleFont()
        
        
        
        lessonButton.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(lessonButton)
        lessonButton.backgroundColor = .clear
        lessonButton.setTitleColor(.white, for: .normal)
        lessonButton.setTitle("Lessons", for: .normal)
        lessonButton.titleLabel?.font = self.getTitleFont()
        
        
        articlButton.topAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        articlButton.leftAnchor.constraint(equalTo: leftView.leftAnchor, constant: 20).isActive = true
        articlButton.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        articlButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lessonButton.bottomAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        lessonButton.leftAnchor.constraint(equalTo: leftView.leftAnchor, constant: 20).isActive = true
        lessonButton.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        lessonButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //self.tableView
        baseView.backgroundColor = UIColor.black
        baseView.alpha = 0.8
        
        backButton.backgroundColor = UIColor.clear
        
        guard let baseVC = self.pupserBase else { return }
        baseVC.view.addSubview(baseView)
        baseView.addSubview(backButton)
        baseView.addSubview(leftView)
        
        self.baseView.frame = CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: baseVC.view.frame.height)
        self.leftView.frame = CGRect(x: baseVC.view.frame.width, y: 0, width: baseVC.view.frame.width * 0.75, height: baseVC.view.frame.height)
        self.backButton.frame = CGRect(x: 0, y: 0, width: baseVC.view.frame.width * 0.25, height: baseVC.view.frame.height)
        
    
        
//        if let nav = self.parent {
//
//            if let base = nav.parent as? BaseVC {
//                base.view.addSubview(baseView)
//                baseView.addSubview(backButton)
//                baseView.addSubview(leftView)
//
//                self.baseView.frame = CGRect(x: 0, y: 0, width: base.view.frame.width, height: base.view.frame.height)
//                self.leftView.frame = CGRect(x: base.view.frame.width, y: 0, width: base.view.frame.width * 0.75, height: base.view.frame.height)
//                self.backButton.frame = CGRect(x: 0, y: 0, width: base.view.frame.width * 0.25, height: base.view.frame.height)
//            }
//
//        }
        
        
        
        
        leftView.backgroundColor = self.getMainColor()
        leftView.alpha = 1.0
        
        
        
        
        //self.minimizeView()
        UIView.animate(withDuration: 0.5, animations: {
            //let sdv = UIScreen.bou
            
            guard let baseVC = self.pupserBase else { return }
            self.leftView.frame = CGRect(x: baseVC.view.frame.width * 0.25, y: 0, width: baseVC.view.frame.width * 0.75, height: baseVC.view.frame.height)
            self.leftView.layer.opacity = 1.0
            
            
//            if let nav = self.parent {
//                if let base = nav.parent as? BaseVC {
//                    self.leftView.frame = CGRect(x: base.view.frame.width * 0.25, y: 0, width: base.view.frame.width * 0.75, height: base.view.frame.height)
//                    self.leftView.layer.opacity = 1.0
//                }
//            }
            
            
        }) { (bol) in
            //
        }
    }
    
    @objc func removeMenu(){
        
        UIView.animate(withDuration: 0.5, animations: {
            
            guard let baseVC = self.pupserBase else { return }
            self.leftView.frame = CGRect(x: baseVC.view.frame.width, y: 0, width: baseVC.view.frame.width * 0.75, height: baseVC.view.frame.height)
            
            
        }) { (bol) in
            self.baseView.removeFromSuperview()
        }
              
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.contentsType == .lesson {
            
            if lessonCompleted[indexPath.row] {
                let vc = LessonContentsTableViewController(lesson: enrolledLessons[indexPath.row], user: self.user, network: self.network)
                if let navigator = self.navigationController {
                    navigator.pushViewController(vc, animated: true)
                }
            }else{
                //they can pick for dashboard
                self.toDashboardPressed(lesson: enrolledLessons[indexPath.row])
            }
            
            
        }else{
            let vc = ArticleViewController(article: self.recommendedArticles[indexPath.row], network: self.network, user: self.user)
            if let navigator = self.navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func injectArticleData(){
        self.switchContentsType(type: .article)
        self.removeMenu()
    }
    
    @objc func injectLessonsData(){
        self.switchContentsType(type: .lesson)
        self.removeMenu()
    }
 
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


extension ProgramContentsTableViewController {
    
    func toDashboardPressed(lesson: GlobalLesson) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let popup = SCLAlertView(appearance: appearance)
        popup.addButton("YES") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setToDashboard(lesson: lesson)
            }
        }
        
        popup.addButton("NOT NOW") {
            //do nothing
        }
        
        popup.showInfo("Add to dashboard?", subTitle: "Do you want to add '\(lesson.name)' to your dashboard?")
    }
    
    func setToDashboard(lesson: GlobalLesson){
        
        if self.user.isOnSubscription == false {
            if self.program.completedLessons == 3 {
                SCLAlertView().showWarning("Whoops...", subTitle: "Please subscribe to get more content!")
                return
            }
            if let userSelections = self.program.userSelectedLessonId {
                if userSelections.count == 1 {
                    SCLAlertView().showWarning("Whoops...", subTitle: "Please complete \(userSelections[0]) or subscribe to choose another lesson.")
                    return
                }
            }
        }
        
        
        self.network.updateUserPickedLessons(lessonId: lesson.id, program: self.program, user: self.user) { (success) in
            if success {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let successPopup = SCLAlertView(appearance: appearance)
                successPopup.addButton("OKAY") {
                    if let navigator = self.navigationController {
                        navigator.popToRootViewController(animated: true)
                    }
                }
                
                successPopup.showSuccess("Added!", subTitle: "\(lesson.name) has been successfully added to your dashboard.")
            }else{
                SCLAlertView().showWarning("Whoops...", subTitle: "\(lesson.name) is already on the dashboard")
                return
            }
        }
    }
}
