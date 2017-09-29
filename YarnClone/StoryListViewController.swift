//
//  StoryListViewController.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit
import URLNavigator

class StoryListViewController: UIViewController {

    //MARK : Constants
    let cellIdentifier = "storyViewCell"
    let pendingOperations = PendingOperations()
    
    //MARK : Properties
    var tableView = UITableView()
    var stories = [StoryHeader]() {
        didSet{
            updateProgressBars()
        }
    }
    
    //MARK : Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let windowWidth = Int(view.bounds.width)
        
        tableView.frame = CGRect(x: 0, y: 0, width: windowWidth, height: Int(self.view.bounds.height))
        tableView.backgroundColor = .white
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView)
        
        ServiceManager.instance.getStories(completion: {
            [weak self] (stories, error) in
            guard self != nil else {
                return
            }
            if stories != nil {
                self?.stories = stories!
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        updateProgressBars()
    }
    
    func updateProgressBars(){
        let progressData = Database.instance.getStoriesProgress()
        for progress in progressData {
            if let story = stories.first(where: {$0.name == progress.storyName}) {
                story.progress = Float(progress.progress)
            }
        }
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK : Extensions

// MARK: - UITableViewDelegate

extension StoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StoryTableViewCell
        let story = self.stories[indexPath.row]
        cell.storyView.descriptionLabel.text = story.shortDescription
        cell.storyView.storyNameLabel.text = story.name
        cell.storyView.progressView.setProgress(story.progress, animated: true)
        
        let pictureEntity = stories[indexPath.row] as PictureDownloadable
        cell.storyView.coverImageView.image = pictureEntity.image
        
        switch (pictureEntity.downloadState){
        case .failed:
            print("failed")
        case .new:
            if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForPhotoRecord(pictureEntity: pictureEntity, indexPath: indexPath as NSIndexPath)
            }
        case .downloaded:
            print("downloaded")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let story = self.stories[indexPath.row]
        Navigator.present("navigator://story/\(story.contentFileName)")

    }
    
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}


//MARK : Image loading

extension StoryListViewController {

    func startDownloadForRecord(pictureEntity: PictureDownloadable, indexPath: NSIndexPath){
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(record: pictureEntity)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadData()
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startOperationsForPhotoRecord(pictureEntity: PictureDownloadable, indexPath: NSIndexPath){
        switch (pictureEntity.downloadState) {
        case .new:
            startDownloadForRecord(pictureEntity: pictureEntity, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        if let pathsArray = tableView.indexPathsForVisibleRows {
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths as Set<NSIndexPath>)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations as Set<IndexPath>)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                
            }
            
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.stories[indexPath.row] as PictureDownloadable
                startOperationsForPhotoRecord(pictureEntity: recordToProcess, indexPath: indexPath)
            }
        }
        
    }
}
