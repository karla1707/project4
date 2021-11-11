//
//  GenericFetchList.swift
//
//  Created by Paul Severin on 02.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation


public class GenericFetchList<Entity : Identifiable & Codable> : ObservableObject {
    @Published var list = [Entity]()

    private var loading = false;

    var requestSettings: RequestSettings

    private let route : String

    public convenience init() {
        self.init(requestSettings: RequestSettings())
    }

    public convenience init(requestSettings: RequestSettings) {
        // generate the route from the type name and append "s" eg: "products" for Product
        self.init(requestSettings: requestSettings, route : String(describing: Entity.self).lowercased() + "s")
    }

    convenience init(route : String) {
        self.init(requestSettings: RequestSettings(), route: route)
    }

    public init(requestSettings: RequestSettings, route: String) {
        self.requestSettings = requestSettings
        self.route = route
        reload()
    }

    func loadMore(_ entity : Entity) {
        // if already loading atm dont load agin
        if (loading) {
            return
        }

        // check if item is near the end of the list
        let ind = list.endIndex - 10
        if (ind < 0 || list.suffix(from: ind).contains(where: {($0).id == entity.id})) {
            loading = true
            // change reqwuestSettings to load the next batch
            requestSettings.offset += requestSettings.limit ?? 20
            // load data and append it to the end of the list
            load(continuation : {(data) in self.list.append(contentsOf: data)})
            print(list.count)
        }
    }

    func reload() {
        // run query with current requestSettings and replace self.list with the result
        load(continuation : {(data) in self.list = data})
    }

    func load(continuation : @escaping ([Entity]) -> ()) {
        let requestSettingsJson = try! JSONEncoder().encode(requestSettings)
        let requestSettingsString = String(data: requestSettingsJson, encoding: String.Encoding.utf8)

        var components = URLComponents(string: ContentView.url + "/" + route)!
        components.queryItems = [URLQueryItem(name: "filter", value: requestSettingsString)]

        URLSession.shared.dataTask(with: components.url!) {(optionalData, response, error) in
            do {
                if let data = optionalData {
                    let decodedData = try JSONDecoder().decode([Entity].self, from: data)
                    DispatchQueue.main.async {
                        continuation(decodedData)
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error: \(error)")
            }
            self.loading = false
        }.resume()
    }
}

public struct RequestSettings : Codable {
    var order : [String]?
    var offset : Int = 0
    var limit : Int?
    var `where` : Dictionary<String,WhereOptions>?

    init() {
    }
}

public struct WhereOptions : Codable {
    var ilike : String?
    var inq: [String]?
    var between: [Int]?
}
