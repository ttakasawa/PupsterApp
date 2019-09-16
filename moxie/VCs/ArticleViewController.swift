//
//  ArticleViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/8/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView
import AVFoundation
import AVKit
import NotificationCenter
import UserNotifications



class ArticleViewController: UITableViewController, PlayVideoCellProtocol, LoadingHandling {
    
    
    var playerController = AVPlayerViewController()
    var recommendationData: [ProductRecommendation]
    var article: Article
    var network: TypeNetwork
    var user: UserData
    var author = Author(id: "NicoleEllis", name: "Nicole Ellis", position: "position", imageUrl: "https://firebasestorage.googleapis.com/v0/b/moxie1-7fca0.appspot.com/o/others%2FiPhone%20App%20Icon%402x%20copy.png?alt=media&token=a699bd54-9a1d-446f-86f9-ca3e3557e9df")
    
    var contentImageCount: Int = 0
    var imageDownLoad: Int = 0
    
    init(article: Article, network: TypeNetwork, user: UserData) {
        self.article = article
        self.network = network
        self.user = user
        self.recommendationData = article.productRecommendations ?? []
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.register(MarketTilesWithCachedImage.self, forCellReuseIdentifier: "marketTiles")
        self.tableView.register(ArticleContent.self, forCellReuseIdentifier: "articleTile")
        self.tableView.register(ArticleHeader.self, forCellReuseIdentifier: "articleHeaderTile")
        
        self.tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func recovery() {
        //when failed
    }
    
    func playVideoButtonDidSelect(imageV: UIImageView, vc: AVPlayerViewController) {
        self.playerController = vc
        self.addChildViewController(vc)
        vc.willMove(toParentViewController: self)
        if let vcPlayer = vc.player{
            vcPlayer.play()
            imageV.addSubview(vc.view)
        }else{
            print("no video")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
        self.markRead()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigation()
    }
    
    func setNavigation(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Article"
    }
    
    func markRead(){
        self.network.markRead(articleId: self.article.id, user: self.user)
    }
    
    func configure(){
        
        self.showLoading()
        self.network.getAuthor(id: self.article.authorID) { (author: Author?, error: Error?) in
            guard let author = author else{
                //do handling error
                return
            }
            self.author = author
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.recommendationData.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == 0){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "articleHeaderTile") as! ArticleHeader
            cell.selectionStyle = .none
            cell.title = self.article.title
            cell.header = self.article.heading
            cell.author = self.author.name
            cell.authorAdditional = self.author.position
            cell.setImages(url: self.author.imageUrl!){
                suceess in
                
                cell.layoutSubviews()
            }
            
            cell.layoutSubviews()
            
            return cell
        }
        if(indexPath.row == 1){
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "articleTile") as! ArticleContent
            
            //let dataAtIndex = data[indexPath.row]
            cell.selectionStyle = .none
            cell.content = self.article.content.replacingOccurrences(of: "\\n", with: "\n")
            cell.layoutSubviews()
            
            cell.setImageForCell(url: self.article.imageUrl){
                completion in
                self.contentImageCount = self.contentImageCount + 1
                if (self.contentImageCount == 1){
                    self.tableView.reloadData()
                }
            }
            
            if (self.article.videoUrl != nil) && (self.article.thumbnail != nil){
                cell.setImageForCell(url: self.article.thumbnail!){
                    completion in
                    self.contentImageCount = self.contentImageCount + 1
                    if (self.contentImageCount == 1){
                        self.tableView.reloadData()
                    }
                }
                print(self.article.videoUrl)
                cell.delegate = self
                cell.placeButtonOnTableCell(videoRef: self.article.videoUrl!)
            }else{
                
                cell.setImageForCell(url: self.article.imageUrl){
                    completion in
                    self.contentImageCount = self.contentImageCount + 1
                    if (self.contentImageCount == 1){
                        self.tableView.reloadData()
                    }
                }
            }
            
            return cell
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "marketTiles") as! MarketTilesWithCachedImage
            
            let dataAtIndex = recommendationData[indexPath.row - 2]
            
            //cell.mainImage = dataAtIndex.
            cell.title1 = dataAtIndex.title
            cell.actionButtonTitle = "Shop"
            cell.panelType = dataAtIndex.recommendingType
            cell.selectionStyle = .none
            
            cell.setImageForCell(url: dataAtIndex.imageSrc){ success in
                
                self.imageDownLoad = self.imageDownLoad + 1
                
                if (self.recommendationData.count - 1 == self.imageDownLoad){
                    self.tableView.reloadData()
                }
            }
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recommenderIndex = indexPath.row - 2
        
        print(recommenderIndex)
        
        if(recommenderIndex >= 0){
            if (recommendationData[recommenderIndex].recommendingType == "collection") || (recommendationData[recommenderIndex].recommendingType == "Collection"){
                if let navigator = navigationController {
                    let collectionViewController = MarketAndCollectionsTableViewController(name: recommendationData[recommenderIndex].title, network: self.network)
                    navigator.pushViewController(collectionViewController, animated: true)
                }
            }else if (recommendationData[recommenderIndex].recommendingType == "product") || (recommendationData[recommenderIndex].recommendingType == "Product"){
                if let navigator = navigationController {
                    let productViewController = productView(productId: recommendationData[recommenderIndex].id, network: self.network)
                    
                    navigator.pushViewController(productViewController, animated: true)
                }
            }else{
                self.showSelectionError()
                return
            }
        }else{
            print("nothing should happen")
        }
    }
    
    
    func stopVideo(){
        self.playerController.player?.pause()
    }
    
    @objc func shareAction(){
        
        self.stopVideo()
        if let shareActivityItem = NSURL(string: self.article.sharableUrl!) {
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [shareActivityItem], applicationActivities: nil)
            
            print(activityViewController)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }else{
            self.showNoShare()
        }
    }
 
    func showSelectionError(){
        SCLAlertView().showNotice("Whoops..", subTitle: "The item you selested is no longer available!")
    }
    
    func showNoShare(){
        SCLAlertView().showNotice("Whoops..", subTitle: "The content you selected cannot be shared at the moment..")
    }

}


protocol ProductRecommendationProtocol {
    var imageSrc: String { get }
    var title: String { get }
    var recommendingType: String { get }
    var id: String { get }
}

extension ProductRecommendation: ProductRecommendationProtocol {
    var imageSrc: String {
        return self.recommendationImage
    }
    var title: String {
        return self.recommendationTitle
    }
    var recommendingType: String {
        return self.recommendationType
    }
    
    var id: String {
        return self.recommendationId
    }
}
