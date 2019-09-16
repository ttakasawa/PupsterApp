//
//  ChatViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 8/14/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import CoreLocation
import AVFoundation
import SafariServices

class ChatViewController: MessagesViewController, Stylable {
    
    
    let refreshControl = UIRefreshControl()
    var imagePicker = UIImagePickerController()
    var messageList: [Message] = []
    var user: UserData
    var network: TypeNetwork
    var initialMsg:  [Message]
    
    var isTyping = false
    var isPrefilled: Bool
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(network: TypeNetwork, user: UserData, initialMsg: [Message], isPrefilled: Bool) {
        self.network = network
        self.user = user
        self.initialMsg = initialMsg
        self.isPrefilled = isPrefilled
        super.init(nibName: nil, bundle: nil)
        
    }
    
    deinit{
        print("deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true
        
        let infoButton: UIBarButtonItem = {
            let b = UIBarButtonItem()
            b.image = #imageLiteral(resourceName: "infoIcon")
            b.style = .plain
            b.target = self
            b.action = #selector(showDetail)
            b.tintColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
            return b
        }()
        
        self.navigationItem.rightBarButtonItem = infoButton
        self.navigationItem.title = self.user.isOnSubscription ? "Gwen" : "Bill"
        
        self.messageInputBar.inputTextView.resignFirstResponder()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: self.messageInputBar.bounds.height, right: 0)
        self.messagesCollectionView.contentInset = insets
        self.messagesCollectionView.scrollToBottom()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesCollectionView.scrollToBottom()
        setMessageInputBarUI()
        
        self.network.logFirebaseEvents(logEventsName: "ChatOpened", parameterd: ["name" : "ChatViewOpened"])
        
            
        let tempView = UIView()
        tempView.backgroundColor = .white
        tempView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempView)
        tempView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tempView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tempView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tempView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        if self.isPrefilled {
            
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.messageList = self.initialMsg
                    if self.initialMsg.count < 30 {
                        self.addIntroduction()
                    }
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        tempView.removeFromSuperview()
                    }
                }
            }
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.network.getMessages(user: self.user, count: 15, completion: { (messages) in
                DispatchQueue.main.async {
                    self.messageList = messages
                    
                    if self.isPrefilled {
                        if self.initialMsg.count < 30 {
                            self.addIntroduction()
                        }
                    }else{
                        if self.messageList.count < 30 {
                            self.addIntroduction()
                        }
                    }
                    
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                    if self.isPrefilled == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            tempView.removeFromSuperview()
                        }
                    }
                }
            })
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        constantReload()
        
        self.network.markMessageRead(user: self.user)
    }
    
    
    
    func constantReload(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.messagesCollectionView.reloadData()
            self.constantReload()
        }
    }
    @objc func loadMoreMessages(){
        
        let currentYFromBottom = self.messagesCollectionView.contentSize.height - self.messagesCollectionView.contentOffset.y
        DispatchQueue.global(qos: .userInitiated).async {
            self.network.getMessages(user: self.user, count: nil, completion: { (messages) in
                DispatchQueue.main.async {
                    
                    self.messageList = messages
                    self.addIntroduction()
                    self.messagesCollectionView.reloadData()
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.messagesCollectionView.reloadData()
//                        let contentHeight = self.messagesCollectionView.contentSize.height
//                        let newYOffset = contentHeight - currentYFromBottom
//                        let newPosition = CGPoint(x: self.messagesCollectionView.contentOffset.x, y: newYOffset)
//                        self.messagesCollectionView.setContentOffset(newPosition, animated: true)
//                    }
                    
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setMessageInputBarUI() {
        
        messageInputBar.sendButton.tintColor = self.getMainColor()
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.loadMoreMessages), for: .valueChanged)
        
        defaultStyle()
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.sendButton.imageView?.backgroundColor = self.getMainColor()
        //here?
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "sendButton")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 13
        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
        
        
        let button = InputBarButtonItem()
        button.onKeyboardEditingBegins { (inputbarbuttonitem) in
            inputbarbuttonitem.messageInputBar?.setLeftStackViewWidthConstant(to: 0, animated: true)
            
        }
        button.onKeyboardEditingEnds { (inputbarbuttonitem) in
            inputbarbuttonitem.messageInputBar?.setLeftStackViewWidthConstant(to: 36, animated: true)
            
        }
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(#imageLiteral(resourceName: "cameraIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = self.getTextColor()
        //?
        button.addTarget(self, action: #selector(self.getImage), for: .touchUpInside)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    func defaultStyle() {
        let newMessageInputBar = MessageInputBar()
        //newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.sendButton.tintColor = self.getMainColor()
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
    }
    
    
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func getImage(_ sender: UIButton){
        //kUTTypeMovie as String
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage: UIImage?
        //var videoUrl: String?
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] {
            let localVideoStringUrl = String(describing: videoUrl)
            let thumbnail = self.thumbnailForVideoAtURL(stringUrl: localVideoStringUrl)
            
            let videoMessage = Message(toId: self.network.adminId, fromId: "ThisDoesNotMatter", messageId: UUID().uuidString, date: Date(), sender: currentSender(), thumbnail: thumbnail, videoUrl: localVideoStringUrl)
            self.network.processMessageForUpload(message: videoMessage, user: self.user)
            
            //                messageList.append(imageMessage)
            //                messagesCollectionView.insertSections([messageList.count - 1])
            //                return

            
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenImage = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chosenImage = originalImage
        }
        
        if let selectedImage = chosenImage {
            //MustDo: replace all to id
            let message = Message(toId: self.network.adminId, fromId: "ThisDoesNotMatter", messageId: UUID().uuidString, date: Date(), sender: currentSender(), image: selectedImage)
            self.network.processMessageForUpload(message: message, user: self.user)
            
            self.messagesCollectionView.scrollToBottom()
            self.messagesCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil) //5
    }

    private func thumbnailForVideoAtURL(stringUrl: String) -> UIImage? {
        
        guard let url = URL(string: stringUrl) else { return nil }
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
            //return UIImage(CGImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        if let current = Global.network.currentSender {
            return current
        }
        return Sender(id: "dfgdfvbdf", displayName: "Umm")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
        
        return nil
    }
    
}



extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        
        if detector == .url {
            let attribute: [NSAttributedStringKey: Any] = {
                return [
                    NSAttributedStringKey.foregroundColor: UIColor.blue,
                    NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                    NSAttributedStringKey.underlineColor: UIColor.blue
                ]
            }()
            return attribute
        }else{
            let attribute: [NSAttributedStringKey: Any] = {
                return [
                    NSAttributedStringKey.foregroundColor: UIColor.darkText,
                    NSAttributedStringKey.underlineStyle: 0,
                    NSAttributedStringKey.underlineColor: UIColor.darkText
                ]
            }()
            return attribute
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        //return [.url, .address, .phoneNumber, .date, .transitInformation]
        return [.url]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        //return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return isFromCurrentSender(message: message) ? self.getMainColor() : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //        let avatar = messageData.shared.getAvatarFor(sender: message.sender)
        let avatar = Global.network.getAvatarFor(sender: message.sender, user: self.user, image: Global.network.userProfileImage)
        avatarView.set(avatar: avatar)
    }
    
    // MARK: - Location Messages
    //
    //    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
    //        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
    //        let pinImage = #imageLiteral(resourceName: "pin")
    //        annotationView.image = pinImage
    //        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
    //        return annotationView
    //    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
            view.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions()
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        
        print(message.imageUrl ?? "no image")
        print(message.videoUrl ?? "no video")
        if let videoUrl = message.videoUrl {
            self.playFirebaseVideo(url: videoUrl)
        }
        
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}


// MARK: - play video
extension ChatViewController: VideoProtocol {
    func playFirebaseVideo(url: String){
        self.playVideo(with: .firebase, url: url)
    }
}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        //print("URL Selected: \(url)")
        self.openSafari(url: url)
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        
        self.network.logFirebaseEvents(logEventsName: "UserMessageSentAction", parameterd: ["name" : "UserSentMessageAction"])
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        //print(Global.network.getUser().firstName! + "  sent " + text)
        
        for component in inputBar.inputTextView.components {
            
            if let image = component as? UIImage {
                
                //TODO: Upload image here
                let imageMessage = Message(toId: self.network.adminId, fromId: "ThisDoesNotMatter", messageId: UUID().uuidString, date: Date(), sender: currentSender(), image: image)
                
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
                self.network.processMessageForUpload(message: imageMessage, user: self.user)
                
                //TODO: Global.network.send(message: message), upload image to firebase storage, get url
            }
            else if let text = component as? String {
                
                let message = Message(toId: self.network.adminId, fromId: "ThisDoesNotMatter", messageId: UUID().uuidString, date: Date(), sender: currentSender(), text: text)
                //replace this with iphone
                
                self.network.send(message: message, user: self.user)
//                messageList.append(message)
//                messagesCollectionView.insertSections([messageList.count - 1])
                
            }
            
        }
        inputBar.inputTextView.text = String()
        
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom()
    }
    
}

@objc
extension ChatViewController {
    func showDetail(){
        if let nevigator = self.navigationController {
            nevigator.pushViewController(PupsterConciergeIntroductionViewController(subscriptionType: self.user), animated: true)
        }
    }
}

extension ChatViewController {
    func openSafari(url: URL){
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true, completion: nil)
    }
}

extension UserDefaults {
    
    static let messagesKey = "realMessages"
    
    // MARK: - Mock Messages
    
    func setMessages(count: Int){
        set(count, forKey: "realMessages")
        synchronize()
    }
    
    func MessagesCount() -> Int {
        if let value = object(forKey: "realMessages") as? Int {
            return value
        }
        return 20
    }
    
}

extension ChatViewController {
    func addIntroduction(){
        var firstMessage: Message!
        var secondMessage: Message!
        
        if let userDogs = user.dogs {
            var firstMessageTime: Date!
            let dogName = userDogs[0].name
            
            if let sessions = user.sessions {
                if (sessions.count == 0){
                    firstMessageTime = Date()
                }else{
                    firstMessageTime = sessions[0].startTime
                }
            }else{
                firstMessageTime = Date()
            }
            
            let fiestText = user.isOnSubscription ? "Hey \(user.firstName)! 👋\nI’m Gwen, your personal Pupster Expert. I’m your go-to source for behavior help, product recommendations, training, and care advice.\n\nAs you explore the Pupster Program, you can message me with any questions you have." : "Hey \(user.firstName)! 👋\nI’m Bill, your personal Pupster Expert. I’m your go-to source for behavior help, product recommendations, training, and care advice.\n\nAs you explore the Pupster Program, you can message me with any questions you have."
            
            firstMessage = Message(toId: user.id, fromId: self.network.adminId, messageId: "firstMessage", date: firstMessageTime, sender: Sender(id: self.network.adminId, displayName: "Gwen"), text: fiestText)
            
            secondMessage = Message(toId: user.id, fromId: self.network.adminId, messageId: "secondMessage", date: firstMessageTime, sender: Sender(id: self.network.adminId, displayName: "Gwen"), text: "Pupster is the best way to help \(dogName) become a well trained pup—our training program was designed by Nicole Ellis (CPDT-KA), a world class certified professional dog trainer.\n\nSo let’s get started! What do you want to work on first with \(dogName)?")
            
            self.messageList.insert(firstMessage, at: 0)
            self.messageList.insert(secondMessage, at: 1)
        }
        
    }
}
