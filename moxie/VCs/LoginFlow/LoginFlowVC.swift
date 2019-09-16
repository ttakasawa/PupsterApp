
//
//  LoginFlowVC.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SnapKit

class LoginFlowVC: UIViewController {
    
    weak var continueButton: PLFButton!
    weak var backButton: UIButton!
    weak var tableView: UITableView!
    
    var startInputIndex: IndexPath?
    var currentInputIndex = IndexPath.init(row: 0, section: 0)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
    }
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstInput()
    }
    
    func configureUI() {
        configureBackground()
        configureBackButton()
        configureTableView()
        configureContinueButton()
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureBackground() {
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "LightGradient"))
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints { make in
            make.size.equalTo(view.snp.size)
            make.center.equalTo(view.snp.center)
        }
    }
    
    func configureBackButton() {
        let backButton = UIButton.init(frame: CGRect.zero)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton = backButton
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.equalTo(32.0)
            make.width.equalTo(64.0)
            make.left.equalTo(view.snp.left).offset(24.0)
            make.top.equalTo(view.snp.top).offset(32.0)
        }
        let backImageView = UIImageView.init(image: #imageLiteral(resourceName: "back-white-button"))
        backImageView.contentMode = .scaleAspectFit
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.left.equalTo(backButton.snp.left)
            make.width.equalTo(14.0)
            make.height.equalTo(14.0)
        }
    }
    
    func configureTableView() {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        self.tableView = tableView
        view.addSubview(tableView)
        registerTableViewCells()
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(backButton.snp.bottom)
        }
    }
    
    func registerTableViewCells() {
        tableView.register(UINib.init(nibName: LFFieldCell.identifier, bundle: nil), forCellReuseIdentifier: LFFieldCell.identifier)
        tableView.register(UINib.init(nibName: LFTitleCell.identifier, bundle: nil), forCellReuseIdentifier: LFTitleCell.identifier)
    }
    
    func configureContinueButton() {
        let continueButton = PLFButton.init(frame: CGRect.zero)
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        self.continueButton = continueButton
        setContinueButton(enabled: false)
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(16.0)
            make.right.equalTo(view.snp.right).offset(-16.0)
            make.bottom.equalTo(view.snp.bottom).offset(-10.0)
            make.height.equalTo(56.0)
        }
    }
    
    func setContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
        continueButton.isUserInteractionEnabled = enabled
        continueButton.set(enabled: enabled)
    }
    
    func iterateRows(_ callback: (UITableViewCell)->Void) {
        let sectionCount = tableView.numberOfSections
        guard sectionCount > 0 else { return }
        
        for section in 0...(sectionCount - 1) {
            
            let cellCount = tableView.numberOfRows(inSection: section)
            
            guard cellCount > 0 else { continue }
            
            for row in 0...(cellCount - 1) {
                if let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: section)) {
                    callback(cell)
                }
            }
        }
    }
    
    func selectFirstInput() {
        guard let start = self.startInputIndex else { return }
        if tableView.numberOfSections > start.section && tableView.numberOfRows(inSection: start.section) > start.row {
            if let cell = tableView.cellForRow(at: start) as? LFFieldCell {
                cell.textField.becomeFirstResponder()
            }
        }
    }
    
    @objc func inputDidChange() {
        var isContinueEnabled = true
        
        iterateRows { row in
            if let fillable = row as? LFFillable {
                if !fillable.isFilled {
                    isContinueEnabled = false
                }
            }
        }
        
        setContinueButton(enabled: isContinueEnabled)
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func continueButtonTapped() {}
    
}

fileprivate enum LFIndexTagValue: Int {
    case secret = 4433
    case last = 4432
}

extension LoginFlowVC: UITextFieldDelegate {
    
    /**
     Creates a tag for your cell.
     
     - Parameter indexPath: The index path of the cell.
     
     - Parameter lastStep: Boolean value that indicates whether or not
     app will submit information on return key.
     
     - Returns: A tag for your cell.
     */
    func getTag(indexPath: IndexPath, lastStep: Bool = false) -> Int {
        if lastStep {
            return LFIndexTagValue.last.rawValue
        }
        return indexPath.row * 10 + indexPath.section * 100 + LFIndexTagValue.secret.rawValue
    }
    
    /**
     Creates an index path from the given tag.
     
     - Parameter tag: The tag of the cell.
     
     - Returns: An index path for the tag.
     */
    func getIndexPath(tag: Int) -> IndexPath {
        let tag = tag - LFIndexTagValue.secret.rawValue
        let row = tag % 100 / 10
        let section = tag / 100
        
        return IndexPath.init(row: row, section: section)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == LFIndexTagValue.last.rawValue {
            if continueButton.isEnabled {
                continueButtonTapped()
            }
        } else {
            moveToNextInput(currentInputIndex)
        }
            
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        
        let indexPath = getIndexPath(tag: tag)
        
        currentInputIndex = IndexPath.init(row: indexPath.row, section: indexPath.section)
        
        return true
    }
    
    @objc func moveToNextInput(_ current: IndexPath) {
        var current = current
        if current.row == tableView.numberOfRows(inSection: current.section) - 1 {
            if current.section == tableView.numberOfSections - 1 {
                current.section = 0
            } else {
                current.section += 1
            }
            current.row = 0
        } else {
            current.row += 1
        }
        
        scrollTo(current)
    }
    
    @objc func moveToPreviousInput(_ current: IndexPath) {
        var current = current
        if current.row == 0 {
            if current.section == 0 {
                current.section = tableView.numberOfSections - 1
            } else {
                current.section -= 1
                current.row = tableView.numberOfRows(inSection: current.section) - 1
            }
        } else {
            current.row -= 1
        }
        
        scrollTo(current)
    }
    
    func scrollTo(_ current: IndexPath) {
        selectTextField(at: current)
        if let paths = tableView.indexPathsForVisibleRows {
            if !((paths.contains(current))) {
                self.tableView.scrollToRow(at: current, at: .middle, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.selectTextField(at: current)
                }
            } else {
                selectTextField(at: current)
            }
        }
    }
    
    func selectTextField(at indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? LFFieldCell, let field = cell.textField {
            field.becomeFirstResponder()
        }
    }
    
}

extension LoginFlowVC {
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
            let endFrameY = endFrame.origin.y
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            tableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height - endFrame.height), animated: true)
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.tableView.snp.updateConstraints({ make in
                                make.bottom.equalTo(self.view.snp.bottom).offset(-(self.view.frame.height - endFrameY + 74.0))
                            })
                            
                            self.continueButton.snp.updateConstraints { make in
                                make.bottom.equalTo(self.view.snp.bottom).offset(-(self.view.frame.height - endFrameY + 10.0))
                            }
                            //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height, 0)
//                            print(self.view.frame.height - endFrameY + 74.0,"YEAH")
//                            self.tableView.setContentOffset(CGPoint.init(x: 0, y: self.view.frame.height - endFrameY + 74.0), animated: false)
                            self.view.layoutIfNeeded()
            },completion: { isCompleted in
//                self.tableView.scrollToRow(at: IndexPath.init(row: self.tableView.numberOfRows(inSection: self.tableView.numberOfSections - 1) - 1, section: self.tableView.numberOfSections - 1), at: .bottom, animated: true)
            })
        }
    }
}
