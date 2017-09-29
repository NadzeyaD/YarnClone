//
//  Database.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/4/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import Foundation
import SQLite


class Database{
    
    //MARK : Constants
    static let instance = Database()
    private let db: Connection?
    
    
    //MARK : Table names
    private let storyProgress = Table("story_progress")
    
    //MARK : Table columns
    private let storyName = Expression<String>("story_name")
    private let progress = Expression<Double>("progress")
    private let latestIndex = Expression<Int>("latest_index")
    
    //MARK : Init
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/yarn.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTablesIfNeed()
    }

    //MARK : Functions

    func updateStoryProgress(storyProgressRecord: StoryProgress) {

            do {

                let story = storyProgress.filter(storyProgress[storyName] == storyProgressRecord.storyName)
                let count = try db?.scalar(story.count)
                if count != nil && count! > 0 {
                if try db!.run(story.update(progress <- storyProgressRecord.progress,
                                            latestIndex <- storyProgressRecord.latestIndex)) == 0
                {  }
                } else {
                    let insert = storyProgress.insert(storyName <- storyProgressRecord.storyName,
                                                      progress <- storyProgressRecord.progress,
                                                      latestIndex <- storyProgressRecord.latestIndex)
                    try db!.run(insert)
                }
            }
            catch {
                print("Update failed")

            }
    }
    
    func getStoriesProgress() -> [StoryProgress]{
        var storyProgressRecords = [StoryProgress]()
        do {
            for storyRecord in
                try db!.prepare(storyProgress
                    .select(storyProgress[storyName], storyProgress[progress], storyProgress[latestIndex]))
            {
                storyProgressRecords.append(StoryProgress(
                    storyName: storyRecord[storyName],
                    progress: storyRecord[progress],
                    latestIndex: storyRecord[latestIndex]))
            }
        } catch {
            print("Select failed")
        }
        return storyProgressRecords
    }
    
    func getStoryProgress(name: String) -> StoryProgress? {
        var storyProgressRecord : StoryProgress?
        do {
            for storyRecord in
                try db!.prepare(storyProgress
                    .select(storyProgress[storyName], storyProgress[progress], storyProgress[latestIndex])
                .where(storyProgress[storyName] == name))
            {
                storyProgressRecord = StoryProgress(
                    storyName: storyRecord[storyName],
                    progress: storyRecord[progress],
                    latestIndex: storyRecord[latestIndex])
                break
            }
        } catch {
            print("Select failed")
        }
        return storyProgressRecord
    }
    
    func createTablesIfNeed(){
        do {
            try db!.run(storyProgress.create(ifNotExists: true) { table in
                table.column(storyName, unique: true)
                table.column(progress)
                table.column(latestIndex)

            })
        } catch {
            print("Unable to create table")
        }
    }
    
    
    func dropTable() {
        do {try db!.run(storyProgress.drop(ifExists: true))
        }
        catch {
            print("unable to drop table")
        }    }
}
