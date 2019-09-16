//
//  LessonContentsTableViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/11/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SCLAlertView

class LessonContentsTableViewController: UITableViewController, VideoProtocol, Stylable {
    
    var lesson: GlobalLesson
    var program: Program
    var user: UserData
    var network: LessonNetwork
    
    var setDashboardButton = DashBoardButton(title: "SET ON DASHBOARD")
    
    init(lesson: GlobalLesson, user: UserData, network: TypeNetwork) {
        
        self.lesson = lesson
        self.user = user
        self.program = user.programs![0]
        self.network = network
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.register(LessonsContentsTableViewCell.self, forCellReuseIdentifier: "videoView")
        self.tableView.separatorStyle = .none
        
        setDashboardButton.addTarget(self, action: #selector(self.setToDashboard), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDashboardButton.translatesAutoresizingMaskIntoConstraints = false
        setDashboardButton.configureStyle(style: DashBoardMainButtonStyle(themeColor: self.getMainColor()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.lesson.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.lesson.videos.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        if index > self.lesson.videos.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
            
            cell.addSubview(setDashboardButton)
            
            setDashboardButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            setDashboardButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -60).isActive = true
            setDashboardButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            setDashboardButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
            setDashboardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            return cell
            
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "videoView") as! LessonsContentsTableViewCell
            
            cell.selectionStyle = .none
            cell.thumbnailUrl = self.lesson.videos[index].thumbnailUrl
            cell.title = "Lesson " + self.lesson.name + " - Video " + String(describing: index + 1)
            cell.videoView.isUserInteractionEnabled = false
            cell.layoutSubviews()
            
            return cell
        }
        
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > self.lesson.videos.count - 1 {
        }else{
            self.playVideo(with: .wistia, token: self.lesson.videos[indexPath.row].videoUrl)
        }
        
    }
}


@objc
extension LessonContentsTableViewController {
    func setToDashboard(){
        
        if (self.program.completedLessons == 3) && (self.user.isOnSubscription == false) {
            SCLAlertView().showWarning("Whoops...", subTitle: "Please subscribe to get more content!")
        }
        
        self.network.updateUserPickedLessons(lessonId: self.lesson.id, program: self.program, user: self.user) { (success) in
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
                
                successPopup.showSuccess("Added!", subTitle: "\(self.lesson.name) has been successfully added to your dashboard.")
            }else{
                SCLAlertView().showInfo("Whoops...", subTitle: "\(self.lesson.name) is already on the dashboard")
            }
        }
    }
}
