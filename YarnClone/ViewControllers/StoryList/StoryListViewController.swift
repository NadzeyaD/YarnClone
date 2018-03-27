//
//  StoryListViewController.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit
import URLNavigator
import Nuke

class StoryListViewController: UIViewController {

    //MARK : Constants
    let cellIdentifier = "storyViewCell"
    let rowHeight: CGFloat = 220
    
    //MARK : Properties
    @IBOutlet weak var tableView: UITableView!
    var stories = [StoryHeader]() {
        didSet {
            updateProgressBars()
        }
    }
    
    //MARK : Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        ServiceManager.instance.getStories(completion: {
            [weak self] (stories, error) in
            guard let `self` = self, let stories = stories else { return }
            
            self.stories = stories
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProgressBars()
    }
    
    func setupTableView() {
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func updateProgressBars() {
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

// MARK: - UITableViewDelegate
extension StoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StoryTableViewCell else { fatalError() }
        
        let story = self.stories[indexPath.row]
        cell.descriptionLabel.text = story.shortDescription
        cell.storyNameLabel.text = story.name
        cell.progressView.setProgress(story.progress, animated: true)
        Nuke.loadImage(with: URL(string: story.coverImageUrl)!, into: cell.coverImageView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let story = stories[indexPath.row]
        Navigator.present("navigator://story/\(story.contentFileName)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
