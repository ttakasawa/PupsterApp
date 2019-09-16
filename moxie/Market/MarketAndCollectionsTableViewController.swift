//
//  MarketAndCollectionsTableViewController.swift
//  moxie
//
//  Created by Tomoki Takasawa on 6/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

struct MarketAndCollectionsData {
    let dataId: String?
    let title: String?
    let price: String?
    let panelType: String?
    let buttonTitle: String?
    let imageSrc: String?
}

import UIKit
import AVFoundation
import AVKit

class MarketAndCollectionsTableViewController: UITableViewController, isOnline, UITabBarControllerDelegate, LoadingHandling, PlayVideoCellProtocol, RootLevelViewControllerHelper {
    weak var playerController = AVPlayerViewController()
    let searchController = UISearchController(searchResultsController: nil)
    
    func playVideoButtonDidSelect(imageV: UIImageView, vc: AVPlayerViewController) {
        self.playerController = vc
        self.addChildViewController(vc)
        vc.willMove(toParentViewController: self)
        if let vcPlayer = vc.player{
            vcPlayer.play()
            imageV.addSubview(vc.view)
        }
    }
    
    var Offlinepanel: UIView!
    var collectionIdentifier: String = ""
    var tableData: [MarketAndCollectionsData] = []
    var replicatedtableData: [MarketAndCollectionsData] = []
    var filteredData: [MarketAndCollectionsData] = []
    var arrayLength: Int = 0
    var imageLoadCount: Int = 0
    var isVideo: Bool = true
    var thumbnail: String = "none"
    var videoRef: String = "none"
    var videoTitle: String = "none"
    
    var network: TypeNetwork!
    
    init(network: TypeNetwork){
        self.network = network
        super.init(nibName: nil, bundle: nil)
        self.isVideo = false
        self.collectionIdentifier = "market"
    }
    
    init(name: String, network: TypeNetwork) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
        let tempName: String = name
        
        self.collectionIdentifier = tempName
        self.isVideo = false
        
        //self.fetchFirebase(name: tempName)
        //self.tableView.register(MarketTilesWithCachedImage.self, forCellReuseIdentifier: "marketTiles")
        //self.tableView.register(CollectionVideoTableViewCell.self, forCellReuseIdentifier: "collectionVideo")
        //self.tableView.separatorStyle = .none
    }
    
    
    
    deinit {
        print("test marketanccollection deinint")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isVideo = false
    }
    
    func recovery() {
        self.fetchFirebase(name: self.collectionIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.isVideo = false
        
        self.fetchFirebase(name: self.collectionIdentifier)
        self.tableView.register(MarketTilesWithCachedImage.self, forCellReuseIdentifier: "marketTiles")
        self.tableView.register(CollectionVideoTableViewCell.self, forCellReuseIdentifier: "collectionVideo")
        self.tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoading()
        playerController?.player?.pause()
        self.Offlinepanel = nil
        //self.collectionIdentifier = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setHeader()
        //self.isConnectedToNetwork()
        if (!self.isConnectedToNetworkFunc()){
            print("offline")
            self.nothingFound(main: "You are offline!", sub: "We’re having connections issues, please check your Internet and try again.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //self.showDescription(type: .market, network: self.network)

        if let user = self.network.user {
            self.network.checkMessage(user: user){ isUnread in
                self.changeMessageIcon(isUnread: isUnread)
            }
                
        }else{
            self.network.queryUser { (user: UserData?, error: Error?) in
                guard let user = user else { return }
                self.network.checkMessage(user: user){ isUnread in
                    self.changeMessageIcon(isUnread: isUnread)
                }
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func chatPressed(){
        guard let user = self.network.user else { return }
        guard let initialMsg = self.network.initialMessages else{ return }
        self.pupserBase?.navigationController?.navigationBar.isHidden = false
        self.pupserBase?.navigationController?.pushViewController(ChatViewController(network: self.network, user: user, initialMsg: initialMsg, isPrefilled: true), animated: true)
    }
    
    func setHeader(){
        self.navigationController?.isNavigationBarHidden = false
        //self.tabBarController?.tabBar.isHidden = false
        self.pupserBase?.setTabBar(hidden: false)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0), NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-DemiBold", size: 20)!]
        
        
        if (self.collectionIdentifier == "market"){
            navigationItem.title = "Shop"
            navigationController?.navigationBar.prefersLargeTitles = true
            
            
            let chatButton: UIBarButtonItem = {
                let b = UIBarButtonItem()
                b.image = #imageLiteral(resourceName: "chatIcon")
                b.style = .plain
                b.target = self
                b.action = #selector(chatPressed)
                b.tintColor = UIColor(red:0.09, green:0.75, blue:0.93, alpha:1)
                return b
            }()
            
            self.navigationItem.rightBarButtonItem = chatButton
            
        }else{
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = self.collectionIdentifier
        }
    }
    
    func fetchFirebase(name: String){
        if (name == "article"){
            self.fetchArticles()
        }else if (name == "market"){
            self.fetchMarket()
        }else{
            //self.fetchArticles()
            self.fetchProductsInCollection()
        }
    }
    
    func fetchMarket(){
        self.showLoading()
        UserManager.shared.getMarketData(){ incomingData, err in
            self.hideLoading()
            if (err){
                self.nothingFound(main: "Sorry!", sub: "We’re having connections issues, please check your Internet and try again.")
            }
            self.tableData.append(contentsOf: incomingData)
            self.tableView.reloadData()
            self.arrayLength = incomingData.count
            
        }
    }
    
    func fetchArticles(){
        self.showLoading()
        UserManager.shared.getAllArticles(){ articles, err in
            self.hideLoading()
            if (err){
                self.nothingFound(main: "Sorry!", sub: "We’re having connections issues, please check your Internet and try again.")
            }
            self.tableData.append(contentsOf: articles)
            self.replicatedtableData = self.tableData
            self.tableData.reverse()
            self.tableView.reloadData()
            self.arrayLength = articles.count
        }
    }
    
    func fetchProductsInCollection(){
        print("collection!")
        print(self.collectionIdentifier)
        self.showLoading()
        UserManager.shared.getCollection(name: self.collectionIdentifier){ products, err in
            print("getCollection!")
            if (err){
                self.nothingFound(main: "Sorry!", sub: "We’re having connections issues, please check your Internet and try again.")
            }
            self.tableData.append(contentsOf: products)
            self.arrayLength = products.count
            
            
            
            //            if let identifier = self?.collectionIdentifier {
            //                UserManager.shared.getCollectionVideo(name: identifier){  title, videoRef, thumbnail in
            //                    if (videoRef != "none" && thumbnail != "none" && title != "none"){
            //
            //                        self?.isVideo = true
            //                        self?.videoRef = videoRef
            //                        self?.thumbnail = thumbnail
            //                        self?.videoTitle = title
            //                    }else{
            //                        self?.isVideo = false
            //                    }
            //
            //                    self?.hideLoading()
            //                    self?.tableView.reloadData()
            //                }
            //            }
            
            
            
            
            UserManager.shared.getCollectionVideo(name: self.collectionIdentifier){  title, videoRef, thumbnail in
                print("getCollectionVideo!")
                if (videoRef != "none" && thumbnail != "none" && title != "none"){
                    
                    self.isVideo = true
                    self.videoRef = videoRef
                    self.thumbnail = thumbnail
                    self.videoTitle = title
                }else{
                    self.isVideo = false
                }
                
                self.hideLoading()
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.collectionIdentifier != "article" && self.collectionIdentifier != "market" && self.isVideo == true){
            return tableData.count + 1
        }else{
            if isFiltering() {
                return filteredData.count
            }
            return tableData.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let index = indexPath.row
        if (self.collectionIdentifier != "article" && self.collectionIdentifier != "market" && self.isVideo == true){
            
            if (indexPath.row == 0){
                
                let videoCell = self.tableView.dequeueReusableCell(withIdentifier: "collectionVideo") as! CollectionVideoTableViewCell
                videoCell.title = self.videoTitle
                videoCell.setImageForCell(url: self.thumbnail){
                    suceess in
                    //videoCell.layoutSubviews()
                    //self.tableView.reloadData()
                }
                videoCell.delegate = self
                videoCell.placeButtonOnTableCell(videoRef: self.videoRef)
                videoCell.selectionStyle = .none
                
                return videoCell
                
                
                
            } else{
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "marketTiles") as! MarketTilesWithCachedImage
                let dataAtIndex = tableData[indexPath.row - 1]
                cell.title1 = dataAtIndex.title
                cell.actionButtonTitle = dataAtIndex.buttonTitle
                cell.panelType = dataAtIndex.panelType
                cell.setImageForCell(url: dataAtIndex.imageSrc!){
                    success in
                }
                cell.selectionStyle = .none
                return cell
            }
            
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "marketTiles") as! MarketTilesWithCachedImage
            var dataAtIndex = tableData[indexPath.row]
            if isFiltering() {
                dataAtIndex = filteredData[indexPath.row]
            } else {
                dataAtIndex = tableData[indexPath.row]
            }
            cell.title1 = dataAtIndex.title
            cell.actionButtonTitle = dataAtIndex.buttonTitle
            cell.panelType = dataAtIndex.panelType
            cell.setImageForCell(url: dataAtIndex.imageSrc!){
                success in
                self.imageLoadCount = self.imageLoadCount + 1
                if ( self.imageLoadCount == self.arrayLength){
                    self.tableView.reloadData()
                }
            }
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = indexPath.row

        if let navigator = navigationController {
            if (self.collectionIdentifier == "market"){
                if (tableData[selectedData].panelType == "product" || tableData[selectedData].panelType == "Product"){
                    if let navigator = navigationController {
                        let productViewController = productView(productId: tableData[selectedData].dataId ?? "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0LzEzMjk1MTc0OTQzMzA=", network: self.network)
                        navigator.pushViewController(productViewController, animated: true)
                    }
                }else if (tableData[selectedData].panelType == "collection" || tableData[selectedData].panelType == "Collection"){
                    if let navigator = navigationController {
                        let collectionViewController = MarketAndCollectionsTableViewController(name: tableData[selectedData].dataId ?? "Tom's collection", network: self.network)
                        navigator.pushViewController(collectionViewController, animated: true)
                    }
                }
            }else if (self.collectionIdentifier == "article"){
                if isFiltering() {
                    let articleTable = articleTableViewController(name: filteredData[selectedData].dataId ?? "0")
                    navigator.pushViewController(articleTable, animated: true)
                } else {
                    let articleTable = articleTableViewController(name: tableData[selectedData].dataId ?? "0")
                    navigator.pushViewController(articleTable, animated: true)
                }
                
            }else{
                if (self.collectionIdentifier != "article" && self.collectionIdentifier != "market" && self.isVideo == true){
                    if (selectedData > 0){
                        let productViewController = productView(productId: tableData[selectedData - 1].dataId ?? "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0LzEzMjk0OTc0NDAzMTQ=", network: self.network)
                        navigator.pushViewController(productViewController, animated: true)
                    }else{
                    }
                }else{
                    let productViewController = productView(productId: tableData[selectedData].dataId ?? "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0LzEzMjk0OTc0NDAzMTQ=", network: self.network)
                    navigator.pushViewController(productViewController, animated: true)
                }

            }
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension MarketAndCollectionsTableViewController: UISearchResultsUpdating {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            self.tableData = self.replicatedtableData
//            self.tableView.reloadData()
//            return
//        }
//
//        self.tableData = self.replicatedtableData.filter({ (filtered) -> Bool in
//            filtered.title?.lowercased().contains(searchText.lowercased()) ?? true
//        })
//        self.tableView.reloadData()
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredData = tableData.filter({( data : MarketAndCollectionsData) -> Bool in
            return data.title?.lowercased().contains(searchText.lowercased()) ?? true
            //print(tableDat)
        })
        
        tableView.reloadData()
    }
}

