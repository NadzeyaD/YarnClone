//
//  ServiceManager.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//


import Alamofire
import AlamofireObjectMapper

class ServiceManager {
    
    static let instance = ServiceManager()

    func getStories(completion: @escaping(_ dog: [StoryHeader]?, _ error: Error?) ->() ){
        let URL = "http://spookytalks.com/files/stories.json"
        
        Alamofire.request(URL).responseArray { (response: DataResponse<[StoryHeader]>) in
            switch(response.result) {
            case .success(_):
                completion(response.result.value?.sorted(by: {$0.date! < $1.date!}), nil)
                break
            case .failure(_):
                completion(nil, response.error)
                break
            }
        }
    }
    
    func getFullStory(fileName: String, completion: @escaping(_ story: Story?, _ error: Error?) ->() ){

        let url = "http://spookytalks.com/files/" + fileName
        Alamofire.request(url).responseObject { (response: DataResponse<Story>) in
            switch(response.result) {
            case .success(_):
                completion(response.result.value, nil)
                break
            case .failure(_):
                completion(nil, response.error)
                break
            }
        }
    }

}
