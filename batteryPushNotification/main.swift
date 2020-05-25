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
    sendHttpPostRequest()
    Thread.sleep(forTimeInterval: 10)
}

func sendHttpPostRequest(){

        var bibletext = ""

        print("포스트 방식 데이터 가지러옴")

        // 1. 전송할 값 준비

        //2. JSON 객체로 변환할 딕셔너리 준비

        //let parameter = ["create_name" : "kkkkkkkk", "create_age" : "909090"]

        //let postString = "create_name=13&create_age=Jack"

        // 3. URL 객체 정의

        guard let url = URL(string: "https://smartmirror.sewingfactory.shop/api/v1/loginIdCheck") else {return}

        

        // 3. URLRequest 객체 정의 및 요청 내용 담기

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        // 4. HTTP 메시지에 포함될 헤더 설정

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

        

        

        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성

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

                    

                    for item in newValue{

                        

                        if let data = item as? [String:Any]{

                            

                            if let book = data["book"] , let chapter = data["chapter"] ,let verse = data["verse"] ,let content = data["content"]{

                                

                        print( String(describing: book) + String(describing: chapter) + String(describing: verse) + String(describing: content))

                                //print(book)

                               // print(chapter)

                               // print(verse)

                               // print(content)

                                 bibletext += String(describing: book) + String(describing: chapter) + String(describing: verse) + String(describing: content)

                            }

    

                        }

                    }

                    

                    // Check for the weather parameter as an array of dictionaries and than excess the first array's description

//                    if let verse = newValue["verse"], let chapter = newValue["chapter"],let book = newValue["book"],let content = newValue["content"] {

//                        print(verse)

//                        print(chapter)

//                        print(book)

//                        print(content)

//                    }

                    

                    

//                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)

//                    if let items = jsonResult["items"] as! NSArray { for item in items { print(item["published"]) print(item["title"]) print(item["content"]) } }

                    

                    

                    //Convert to Data

                   // let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)

                    

                    //Convert back to string. Usually only do this for debugging

                    //if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {

                    //    print(JSONString)

                    //}

                    

                    

                }catch{

                    print(error)

                }

            }

            // 6. POST 전송

            }.resume()

        

    }
