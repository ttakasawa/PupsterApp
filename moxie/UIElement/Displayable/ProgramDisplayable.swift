//
//  ProgramDisplayable.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation


protocol ProgramDisplayable: TileDisplayable {
    var program: Program { get }
    var globalLesson: GlobalLesson{ get }
    
    var subProgramName: String { get }
}
