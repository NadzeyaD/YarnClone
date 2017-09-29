//
//  PictureDownloader.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

protocol PictureDownloadable {
    var downloadState : DownloadState {get set}
    var image : UIImage? {get set}
    var imageUrl : String {get}
}
