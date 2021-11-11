//
// Created by Paul Severin on 05.06.20.
// Copyright (c) 2020 Fontys UAS. All rights reserved.
//

import Foundation

func sendToken(device_token: String, access_token : String, customerEmail : String) {
    if (device_token.isEmpty) {
        return
    }
    var components = URLComponents(string: ContentView.url + "/devices/" + customerEmail)!

    components.queryItems = [URLQueryItem(name: "access_token", value: access_token)]

    var urlRequest = URLRequest(url: components.url!)
    urlRequest.httpMethod = "PUT"

    let jsonEncoder = JSONEncoder()
    do {
        let data = try jsonEncoder.encode(Device(token: device_token, customerEmail: customerEmail));

        urlRequest.httpBody = data
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: urlRequest) { (optionalData, response, error) in
            do {
                print(response)
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    } catch {
    }
}