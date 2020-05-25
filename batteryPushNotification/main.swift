//
//  main.swift
//  batteryPushNotification
//
//  Created by 구본익 on 2020/05/25.
//  Copyright © 2020 구본익. All rights reserved.
//

import Foundation
import IOKit.ps
func HTTPsendRequest(request: URLRequest,
                     callback: @escaping (Error?, String?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
        if (err != nil) {
            callback(err,nil)
        } else {
            callback(nil, String(data: data!, encoding: String.Encoding.utf8))
        }
    }
    task.resume()
}

func HTTPPostJSON(url: String,  data: Data,
                  callback: @escaping (Error?, String?) -> Void) {

    var request = URLRequest(url: URL(string: url)!)

    request.httpMethod = "POST"
    request.addValue("application/json",forHTTPHeaderField: "Content-Type")
    request.addValue("application/json",forHTTPHeaderField: "Accept")
    request.httpBody = data
    HTTPsendRequest(request: request, callback: callback)
}
// For each power source...
let url = URL(string: "https://smartmirror.sewingfactory.shop/api/v1/")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
while true {
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    // Pull out a list of power sources
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
    for ps in sources {
        // Fetch the information for a given power source out of our snapshot
        let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]

        // Pull out the name and capacity
        if let name = info[kIOPSNameKey] as? String,
            let capacity = info[kIOPSCurrentCapacityKey] as? Int,
            let max = info[kIOPSMaxCapacityKey] as? Int {
            print("\(name): \(capacity) of \(max)")
        }
    }
//    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//        guard let data = data else { return }
//        print(String(data: data, encoding: .utf8)!)
//    }
//
//    task.resume()
    var dict = Dictionary<String, Any>()

    dict["userLogindId"] = "koogood"
    dict["userLoginPassword"] = "q1w2e3r4"
//    UserBlueToothAddr
    dict["UserBlueToothAddr"] = "asdcf"
    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
    let jsonString = String(data: data, encoding: .utf8)
    print(jsonString)
    HTTPPostJSON(url: "https://smartmirror.sewingfactory.shop/api/v1/loginIdCheck" as String, data: data) { (err, result) in
        if(err != nil){
            print(err!.localizedDescription)
            return
        }
        
        
        print(result ?? "")
    }
    
    Thread.sleep(forTimeInterval: 10)
}
