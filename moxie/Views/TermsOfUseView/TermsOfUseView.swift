//
//  TOSLink.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class TermsOfUseView: TappableView {

    static let normalHeight: CGFloat = 38.0
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var linkView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TermsOfUseView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        configureUI()
    }
    
    func configureUI() {
        
    }
    
    override func setHighlighted(_ highlighted: Bool) {
        let alpha: CGFloat = highlighted ? 0.25 : 1.0
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.linkView.alpha = alpha
        }
    }

}
