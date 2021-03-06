//
//  StoryViewController.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit
import URLNavigator
import Nuke

final class StoryViewController: UIViewController {

    //MARK : Constants
    let storyUrl : String
    let cellIdentifier = "messageViewCell"
    
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    fileprivate let contentInsets = UIEdgeInsets(top: 60, left: 0.0, bottom: 270.0, right: 0.0)
    let timerInterval = 10

    //MARK : Properties
    var story : Story? {
        didSet {
            guard let story = story else { return }
            loadReadMessages()
            authorColors = assignColors()
            collectionView.reloadData()
            scrollToBottom()
            storyNameLabel.text = story.name
            authorLabel.text = story.authorName
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storyNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var storyHeaderView: UIView!
    
    var cellWidth: CGFloat = 0
    var gestureRecognizer = UITapGestureRecognizer()
    var isFinished = false
    var storyView : StoryView?
    var count : Int = 0
    var nextStory : StoryHeader? {
        didSet {
             if story?.messages.filter({!$0.isShown}).count == 0 {
                showNextStory()
             }
        }
    }
    var timerView : TimerView?
    var timer : Timer?
    var shownMessages = [StoryMessage]()
    var authorColors = [String: MessageColorSettings]()
    var nextEpisodeLabel = UILabel()
    
    //MARK : Inits
    init(storyUrl: String){
        self.storyUrl = storyUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.storyUrl = ""
        super.init(coder: aDecoder)
    }
    
    //MARK : Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ServiceManager.instance.getFullStory(fileName: storyUrl, completion: {
            [weak self] (story, error) in
            guard self != nil else {
                return
            }
            if story != nil {
                self?.story = story
                ServiceManager.instance.getStories(completion: {(stories, error) in
                    if let stories = stories {
                        var index = stories.index(where: {$0.name == story?.name})
                        if index != nil && index! >= stories.count - 1 {
                            index = 0
                        } else { index = index! + 1 }
                            self?.nextStory = stories[index!]
                        }
                })
            }
        })

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let story = story, shownMessages.count > 0 else { return }

        Database.instance.updateStoryProgress( storyProgressRecord: StoryProgress(storyName: story.name, progress: takeProgressValue(), latestIndex: (story.messages.filter({ $0.isShown }).count - 1)))
    }
    
    @IBAction func backToStories(_ sender: UIButton) {
        backToStoriesList()
    }
    
    func configureViews() {
        setupCollectionView()
        configureNextEpisode()
        addRecognizer()
    }
    
    func setupCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = contentInsets
    }
    
    func configureNextEpisode() {
        nextEpisodeLabel.text = "Next episode..."
        nextEpisodeLabel.textColor = .black
        nextEpisodeLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    func addRecognizer() {
        gestureRecognizer.addTarget(self, action: #selector(showNextMessage))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func takeProgressValue() -> Double {
        guard let story = story else { return 0 }
        
        return Double(Float(story.messages.filter({$0.isShown}).count)/Float(story.messages.count))
    }

    func scrollToBottom() {
        guard shownMessages.count > 0 else { return }
        
        let lastItemIndex = IndexPath(item: (shownMessages.filter({$0.isShown}).count) - 1, section: 0)
        collectionView?.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
        timerView?.removeFromSuperview()
    }
    
    func showTimer() {
        self.count = timerInterval
        //Configure views
        collectionView.contentSize.height = collectionView.contentSize.height + 270
        timerView = TimerView(frame: CGRect(x: 0, y: collectionView.contentSize.height - 220, width: view.bounds.width, height: 220))
        timerView?.skipButton.addTarget(self, action: #selector(invalidateTimer), for: .touchUpInside)
        collectionView.addSubview(timerView!)
        //Run timer
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    func showNextStory() {
        isFinished = true
        configureNextStoryViews()
        guard nextStory != nil else { return }
        
        fillStoryViewData()
    }
    
    func configureNextStoryViews() {
        collectionView.contentSize.height = collectionView.contentSize.height + 270
        nextEpisodeLabel.frame = CGRect(x: 15, y: collectionView.contentSize.height - 240, width: view.bounds.width, height: 20)
        storyView = StoryView(frame: CGRect(x: 0, y: collectionView.contentSize.height - 220, width: view.bounds.width, height: 220))
        collectionView.addSubview(nextEpisodeLabel)
        collectionView.addSubview(storyView!)
    
        assignGestureRecoginizerToStoryView()
    }
    
    func assignGestureRecoginizerToStoryView(){
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(presentNextStory))
        storyView?.addGestureRecognizer(tapGestureRecognizer)
        storyView?.isUserInteractionEnabled = true
    }
    
    func fillStoryViewData() {
        
        storyView?.storyNameLabel.text = nextStory?.name
        storyView?.descriptionLabel.text = nextStory?.shortDescription
        
        if let url = URL(string: (nextStory?.coverImageUrl)!) {
            Nuke.loadImage(with: url, into: (storyView?.coverImageView)!)
        }
    }

    func loadReadMessages(){
        if let progress = Database.instance.getStoryProgress(name: (story?.name)!) {
            for index in 0...progress.latestIndex {
                if let story = story?.messages[index] {
                    story.isShown = true
                }
            }
            shownMessages += (story?.messages.filter{$0.isShown && $0.messageType != .startBreak})!
        }
    }
    
    func assignColors() -> [String: MessageColorSettings]{
        let uniqueAuthors = story?.messages.filter({$0.messageType == .simple}).map{ $0.author! }.unique
        var authorColors = [String: MessageColorSettings]()
        for (index, author) in uniqueAuthors!.enumerated() {
            authorColors[author] = ColorsDictionary.colorsDictionary[index]
        }
        return authorColors
    }
    
    
    //MARK : Actions
    func backToStoriesList(){
        self.dismiss(animated: true, completion: nil)
    }

    func updateTimer() {
        if(count > 0){
            timerView?.countDownLabel.text = count.getTimerString()
            count -= 1
        } else {
            invalidateTimer()
        }
    }
    
    func showNextMessage() {
        guard timer == nil else { return }
        
        if let nextMessage = story?.messages.first(where: {!$0.isShown}) {
        
            nextMessage.isShown = true
            if nextMessage.breakMessage != nil {
                showTimer()
            } else {
                shownMessages.append(nextMessage)
                collectionView.reloadData()
                scrollToBottom()
            }
        } else if !isFinished {
            showNextStory()
        }
    }
    
    func presentNextStory() {
        self.dismiss(animated: false, completion: { [weak self] _ in
            guard let `self` = self, let nextStory = self.nextStory else { return }
            
            Navigator.present("navigator://story/\(nextStory.contentFileName)") })
    }
}

// MARK: - Extentions
extension StoryViewController: URLNavigable {
    convenience init?(navigation: Navigation) {
        guard let storyUrl = navigation.values["storyUrl"] as? String else { return nil }
        
        self.init(storyUrl: storyUrl)
    }
}


extension StoryViewController :  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let paddingSpace = (sectionInsets.left) * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let message = self.shownMessages[indexPath.row]

        if message.messageType == .simple {
            let fixedWidth = view.frame.size.width - 60
            let size = ViewHelper.heightForView(text: message.message!, font:  UIFont.systemFont(ofSize: 14.0), width: fixedWidth)
            return CGSize(width: widthPerItem, height: size.height + 30)
        } else { //.dividive message
            return CGSize(width: widthPerItem, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard  story != nil else { return 0 }
        
        return shownMessages.count
    }
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as? MessageCollectionViewCell
            else {
                fatalError("Something realy bad happend")
        }
        
        let message = self.shownMessages[indexPath.row]
        let fixedWidth = view.frame.size.width - 60
        
        if message.messageType == .simple {
        
            cell.messageLabel.text = message.message
            cell.authorNameLabel.text = message.author
            cell.divisionLabel.text = ""
            
            //Cell height/width calculation logic
            let size = ViewHelper.heightForView(text: message.message!, font:  UIFont.systemFont(ofSize: 14.0), width: fixedWidth)
            let authorSize = ViewHelper.heightForView(text: message.author!, font:  UIFont.boldSystemFont(ofSize: 12.0), width: fixedWidth)
            
            cell.frame.size = CGSize(width: cell.frame.width, height: CGFloat(size.height + 30))
            cell.contentView.frame.size = CGSize(width: max(authorSize.width + 30, size.width + 30), height: (size.height + 30))
            cell.messageLabel.frame.size = CGSize(width: min(size.width, fixedWidth), height: size.height)
        
            //Colors logic
            if (message.author != nil) {
                cell.authorNameLabel.textColor = authorColors[message.author!]?.senderNameColor
                cell.contentView.backgroundColor = authorColors[message.author!]?.backgroundColor
            }
        } else { //divider message
            cell.authorNameLabel.text = ""
            cell.messageLabel.text = ""
            cell.divisionLabel.text = message.dividerMessage
            
            cell.frame.size = CGSize(width: fixedWidth, height: 30)
            cell.contentView.backgroundColor = .clear
            cell.contentView.frame.size = CGSize(width: fixedWidth, height: 30)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            storyHeaderView.isHidden = false
        } else {
            storyHeaderView.isHidden = true
        }
    }

}
