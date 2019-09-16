//
//  DashBoardBuildable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


protocol NewDashBoardBuildable {
    
    func createTopView() -> DashBoardCell
    func createMiddleView() -> DashBoardCell
    func createBottomView() -> DashBoardCell
    func createFooterView() -> DashBoardCell
    
    func configureTopView(data: Any)
    func configureMiddleView(data: Any)
    func configureBottomView(data: Any)
    func configureFooterView(data: Any)
}

class ActivityBoardBuildable: NewDashBoardBuildable {
    
    var topCell: LessonCell?
    var middleCell: LessonCell?
    var bottomCell: ArticleCell?
    var footerCell: ProgressCell?
    
    
    func configureTopView(data: Any){
        if let data = data as? ProgramInterface{
            topCell?.configure(data: data)
        }
    }
    func configureMiddleView(data: Any) {
        if let data = data as? ProgramInterface{
            middleCell?.configure(data: data)
        }
    }
    func configureBottomView(data: Any){
        if let data = data as? ArticleDisplayable{
            bottomCell?.configure(data: data)
        }
    }
    func configureFooterView(data: Any){
        if let data = data as? DefaultTileDisplayable{
            footerCell?.configure(data: data)
        }
    }
    
    
    
    func createTopView() -> DashBoardCell{
        self.topCell = LessonCell()
        return self.topCell!
    }
    func createMiddleView() -> DashBoardCell{
        self.middleCell = LessonCell()
        return self.middleCell!
    }
    func createBottomView() -> DashBoardCell{
        self.bottomCell = ArticleCell()
        return self.bottomCell!
    }
    func createFooterView() -> DashBoardCell{
        self.footerCell = ProgressCell()
        return self.footerCell!
    }
}



class TrackingBoardBuildable: NewDashBoardBuildable {
    
    var topCell: UserProfileCell?
    var middleCell: ReminderCell?
    var bottomCell: UpgradeCell?
    var footerCell: SettingsCell?
    //ProgressCell
    
    func configureTopView(data: Any){
        if let data = data as? UserProfileDisplayable{
            topCell?.configure(data: data, isOnDashBoard: true)
        }
    }
    func configureMiddleView(data: Any) {
        if let data = data as? ReminderSettingDisplayable{
            middleCell?.configure(data: data)
        }
    }
    func configureBottomView(data: Any){
        if let data = data as? DogNameDisplayable{
            bottomCell?.configure(data: data)
        }
    }
    func configureFooterView(data: Any){
        footerCell?.configure()
    }
    
    
    
    func createTopView() -> DashBoardCell{
        self.topCell = UserProfileCell()
        return self.topCell!
    }
    func createMiddleView() -> DashBoardCell{
        self.middleCell = ReminderCell()
        return self.middleCell!
    }
    func createBottomView() -> DashBoardCell{
        self.bottomCell = UpgradeCell()
        return self.bottomCell!
    }
    func createFooterView() -> DashBoardCell{
        self.footerCell = SettingsCell()
        return self.footerCell!
    }
}
