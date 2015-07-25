//: Playground - noun: a place where people can play

import UIKit

let firstLoad = NSDate()
println(firstLoad)
// add an hour
let oneHourLater = firstLoad.dateByAddingTimeInterval(3600)

println(oneHourLater)

var firstTimeInterval: NSTimeInterval = firstLoad.timeIntervalSince1970

var secondTimeInterval: NSTimeInterval = oneHourLater.timeIntervalSince1970


var difference: Double = Double(secondTimeInterval - firstTimeInterval)

let interval = oneHourLater.timeIntervalSinceDate(firstLoad)

println("Time interval: \(interval) seconds")
// All deals are stored in an array of dictionaries, with the dealId as the key, and expiration date string as the value

//once application loads, it checks all deal records stored in defaults to see if any are 3 hours past their expiration time, if so, deletes them

// once a deal is pulled, check a deal timestamp is stored in defaults, 
    //if one is stored get the date
        //if it is expired 
            // up to 3 hours after the deal: do not add to deal list
            // anything over 3 hours after the deal, delete the record, create a new one, and add to list (this is a double check, in case the user returns to the app without a fresh restart)
        // if it is not expired
            // add to list, timer will update with remaining number of microseconds
    // if one is not stored, save it to defaults with time stamp of when it will expire, add to list, and set timer to number of microseconds till expired


