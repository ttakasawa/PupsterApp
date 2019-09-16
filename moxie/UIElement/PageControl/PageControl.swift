//
//  PageControl.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/3/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class PageControl: UIPageControl, Stylable {
    init(){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        self.pageIndicatorTintColor = self.getTextColor()
        self.currentPageIndicatorTintColor = self.getPinkColor()
    }
}
