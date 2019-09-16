//
//  DefaultTileDisplayable.swift
//  Pupster2
//
//  Created by Tomoki Takasawa on 8/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol TileDisplayable {
    var title: String { get }
}

protocol DefaultTileDisplayable: TileDisplayable {
    var progressLabel: String { get }
    var progressValue: Float { get }
}

extension UserData: DefaultTileDisplayable {
    var progressLabel: String {
        let progress = self.progressValue * 100
        return self.dogs![0].name + " is " + String(describing: Int(progress)) + "% complete with the program"
    }
    
    var progressValue: Float {
        return Float(self.programs![0].progress)
    }
    
    var title: String {
        return "Pupster Program"
    }
    
}

class DefaultTileDisplaying: DefaultTileDisplayable {
    //MustDo
    var user: UserData
    var progressValue: Float {
        return Float(self.user.programs![0].progress)
    }
    var progressLabel: String {
        let progress = self.progressValue * 100
        return self.user.dogs![0].name + " is " + String(describing: Int(progress)) + "% complete with the program"
        //TODO: change above when we support multiple dog
    }
    
    var title: String = "Pupster Program"
    
    init(network: TypeNetwork){
        self.user = network.user!
    }
}
