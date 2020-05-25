//
//  main.swift
//  batteryPushNotification
//
//  Created by 구본익 on 2020/05/25.
//  Copyright © 2020 구본익. All rights reserved.
//

import Foundation
import IOKit.ps

while true {
    print("이름을 입력해주세요")
    let name = readLine()
    print(name)
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
    sendHttpPostRequest()
    Thread.sleep(forTimeInterval: 10)
}

func sendHttpPostRequest(){
    // 유저디폴트 저장과 읽기
//    UserDefaults.standard.set("name", forKey: "name")
//    UserDefaults.standard.string(forKey: "name") ?? ""
    guard let url = URL(string: "https://smartmirror.sewingfactory.shop/api/v1/loginIdCheck") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = """
        {
            "userLoginId" : "testkoo",
            "userLoginPassword" : "q1w2e3r4!!",
            "userBlueToothAddr" : "asdasd"

        }
    """.data(using:String.Encoding.utf8, allowLossyConversion: false)
    request.httpBody = body
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let res = response{
            print(res)
        }
        if let data = data {
            do{
                
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("여기야?")
                print(json)
                guard let newValue = json as? Array<Any> else {
                    print("invalid format")
                    return
                }
            }catch{
                print(error)
            }
        }
    }.resume()
}
