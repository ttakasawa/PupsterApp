//
//  MarketTableViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 5/23/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView
import AVFoundation
import AVKit
import NotificationCenter
import UserNotifications

struct cellData {
    let image: UIImage?
    let panelTitle: String?
    let actionTitle: String?
}

struct articleHeaderData{
    var title: String
    var header: String
    var author: String
    var authorAddition: String
    var authorImage: String
}

struct recommending{
    let imageSrc: String
    let title: String
    let panelType: String
    let actionType: String
    let id: String
}

class articleTableViewController: UITableViewController, PlayVideoCellProtocol, localNotificationRegistrationProtocol {

    var downloadCount: Int = 0
    var isLoaded: Bool = false
    let blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)

        return blurredEffectView
    }()
    var data = [cellData]()
    var articleIdentifier: String = ""
    var headerData: articleHeaderData = articleHeaderData.init(title: "Title", header: "header", author: "author", authorAddition: "position", authorImage: "https://firebasestorage.googleapis.com/v0/b/moxie1-7fca0.appspot.com/o/others%2FiPhone%20App%20Icon%402x%20copy.png?alt=media&token=a699bd54-9a1d-446f-86f9-ca3e3557e9df")

    var recommendationData: [recommending] = []
    var articleContent: String = ""
    var arrayLength: Int = 0
    var shareUrl: String = ""
    var arrayCount: Int = 0
    var imageDownLoad: Int = 0
    var articleImageStr: String = ""
    var isVideo: Bool = false
    var videoRef: String = "none"
    var playerController = AVPlayerViewController()

    init(name: String) {
        super.init(nibName: nil, bundle: nil)

        self.articleIdentifier = name
        self.isVideo = false

        UserManager.shared.getArticleWithIndex(identifier: name){ headerItem, content, recommended, webUrl, contentImage, videoRef, videoThumbNail  in

            self.headerData = headerItem
            self.recommendationData = recommended
            self.articleContent = content.replacingOccurrences(of: "\\n", with: "\n")
            self.articleImageStr = contentImage
            self.arrayLength = recommended.count
            if(webUrl != "none"){
                self.shareUrl = webUrl
            }

            if (videoRef != "none") && (videoThumbNail != "none"){
                self.articleImageStr = videoThumbNail
                self.isVideo = true
                self.videoRef = videoRef
            }
            self.tableView.reloadData()
            self.hideLoading()
            self.isLoaded = true

            self.arrayCount = recommended.count
            self.activateNotificationForArticle(productName: recommended[0].title, articleName: self.headerData.title)

        }


        self.tableView.register(MarketTilesWithCachedImage.self, forCellReuseIdentifier: "marketTiles")
        self.tableView.register(ArticleContent.self, forCellReuseIdentifier: "articleTile")
        self.tableView.register(ArticleHeader.self, forCellReuseIdentifier: "articleHeaderTile")

        self.tableView.separatorStyle = .none

        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("goBackPressed executed")
        playerController.player?.pause()

        SVProgressHUD.dismiss()

        if self.blur.isDescendant(of: self.view) {
            self.blur.removeFromSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if (isLoaded == false) {
            SVProgressHUD.show(withStatus: "Loading...")
            blur.frame = self.view.bounds
            view.addSubview(blur)

            self.isLoaded = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareButton
        self.navigationItem.largeTitleDisplayMode = .never
    }

    deinit {
        //print("deinit in articletbleViewcontroller")
    }

    func stopVideo(){
        self.playerController.player?.pause()
    }

    @objc func shareAction(){

        self.stopVideo()
        if let shareActivityItem = NSURL(string: self.shareUrl) {
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [shareActivityItem], applicationActivities: nil)

            print(activityViewController)
            activityViewController.popoverPresentationController?.sourceView = self.view

            self.present(activityViewController, animated: true, completion: nil)
        }else{
            self.showNoShare()
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendationData.count + 2
    }

    var contentImageCount: Int = 0

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row == 0){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "articleHeaderTile") as! ArticleHeader
            cell.selectionStyle = .none
            cell.title = self.headerData.title
            cell.header = self.headerData.header
            cell.author = self.headerData.author
            cell.authorAdditional = self.headerData.authorAddition
            cell.setImages(url: self.headerData.authorImage){
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
            cell.content = self.articleContent
            cell.layoutSubviews()

            cell.setImageForCell(url: self.articleImageStr){
                completion in
                self.contentImageCount = self.contentImageCount + 1
                if (self.contentImageCount == 1){
                    self.tableView.reloadData()
                }
            }

            if (self.isVideo){
                cell.delegate = self
                cell.placeButtonOnTableCell(videoRef: self.videoRef)
            }

            return cell
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "marketTiles") as! MarketTilesWithCachedImage

            let dataAtIndex = recommendationData[indexPath.row - 2]

            //cell.mainImage = dataAtIndex.
            cell.title1 = dataAtIndex.title
            cell.actionButtonTitle = "Shop"
            cell.panelType = dataAtIndex.panelType
            cell.selectionStyle = .none

            cell.setImageForCell(url: dataAtIndex.imageSrc){ success in

                self.imageDownLoad = self.imageDownLoad + 1
                self.isLoaded = true
                if (self.arrayCount == self.imageDownLoad){
                    self.tableView.reloadData()
                }
            }

            return cell
        }

    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let recommenderIndex = indexPath.row - 2
//
//        print(recommenderIndex)
//
//        if(recommenderIndex >= 0){
//            if (recommendationData[recommenderIndex].panelType == "collection") || (recommendationData[recommenderIndex].panelType == "Collection"){
//
//                if let navigator = navigationController {
//                    let collectionViewController = MarketAndCollectionsTableViewController(name: recommendationData[recommenderIndex].title)
//                    navigator.pushViewController(collectionViewController, animated: true)
//                }else{
//                    let collectionViewController = MarketAndCollectionsTableViewController(name: recommendationData[recommenderIndex].title)
//                    self.present(collectionViewController, animated: true, completion: nil)
//                }
//            }else if (recommendationData[recommenderIndex].panelType == "product") || (recommendationData[recommenderIndex].panelType == "Product"){
//
//                if let navigator = navigationController {
//                    let productViewController = productView(productId: recommendationData[recommenderIndex].id)
//
//                    navigator.pushViewController(productViewController, animated: true)
//                }else{
//                    let productViewController = productView(productId: recommendationData[recommenderIndex].id)
//                    self.present(productViewController, animated: true, completion: nil)
//                }
//
//            }else{
//                self.showSelectionError()
//                return
//            }
//        }else{
//            print("nothing should happen")
//        }


    }

    func showSelectionError(){
        SCLAlertView().showNotice("Whoops..", subTitle: "The item you selested is no longer available!")
    }

    func showNoShare(){
        SCLAlertView().showNotice("Whoops..", subTitle: "The content you selected cannot be shared at the moment..")
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL, completion: @escaping(_ imageData: UIImage) -> Void) {
        //print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                completion(UIImage(data: data)!)
            }
        }
    }

    func hideLoading(){
        SVProgressHUD.dismiss()
        if self.blur.isDescendant(of: self.view) {
            self.blur.removeFromSuperview()
        }
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



    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     print("in test1 tableView:")
     print(fromIndexPath)
     print(to)
     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}


