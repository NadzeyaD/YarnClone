//
//  ContentLoader.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download yarn queue"
        return queue
    }()
    
}

class ImageDownloader: Operation {
    
    var record: PictureDownloadable
    
    init(record: PictureDownloadable) {
        self.record = record
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        let imageData = self.loadImageData(url: record.imageUrl)
  
        
        if self.isCancelled {
            return
        }
        
        if imageData != nil {
            self.record.image = imageData!
            self.record.downloadState = .downloaded
        }
        else
        {
            self.record.downloadState = .failed
            self.record.image = UIImage()
        }
    }
    
    func loadImageData(url: String) -> UIImage? {
        if let data = try? Data(contentsOf: URL(string: url)!) {
            return UIImage(data: data)
        }
        return nil
    }
}
