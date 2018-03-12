//
//  CoinAPIHelper.swift
//  hiOS
//
//  Created by Justin I. on 3/1/18.
//  Copyright © 2018 Justin I. All rights reserved.
//

import Foundation

/// A digital currency operating independently from a central bank.
struct Cryptocurrency {
    /// Unique identifier used to query the API for further details
    var id: String
    /// Canonical name
    var name: String
    /// Abbreviated version of the name
    var symbol: String
    /// Order in terms of overall market cap
    var rank: Int
    /// Current price in U.S. Dollars
    var priceUSD: Double
    /// Price change in the last hour since `lastUpdated`
    var percentChangeHour: Double
    /// Price change in the last 24 hours since `lastUpdated`
    var percentChangeDay: Double
    /// Price change in the last 7 days since `lastUpdated`
    var percentChangeWeek: Double
    /// Unix time since the data was updated
    var lastUpdated: Int

    /// Creates a new Cryptocurrency
    init(id: String, name: String, symbol: String, rank: Int, priceUSD: Double, percentChangeHour: Double, percentChangeDay: Double, percentChangeWeek: Double, lastUpdated: Int) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.rank = rank
        self.priceUSD = priceUSD
        self.percentChangeHour = percentChangeHour
        self.percentChangeDay = percentChangeDay
        self.percentChangeWeek = percentChangeWeek
        self.lastUpdated = lastUpdated
    }
}

/// Extends Cryptocurrency to adopt the Decodable protocol
extension Cryptocurrency: Decodable {
    /// Declare keys in association between Swift variables and the API's JSON naming
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUSD = "price_usd"
        case percentChangeHour = "percent_change_1h"
        case percentChangeDay = "percent_change_24h"
        case percentChangeWeek = "percent_change_7d"
        case lastUpdated = "last_updated"
    }

    /// Initializer for Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        let id: String = try container.decode(String.self, forKey: .id) // extracting the data
        let name: String = try container.decode(String.self, forKey: .name)
        let symbol: String = try container.decode(String.self, forKey: .symbol)
        let rank: Int = try Int(container.decode(String.self, forKey: .rank))!
        let priceUSD: Double = try Double(container.decode(String.self, forKey: .priceUSD))!
        let percentChangeHour: Double = try Double(container.decode(String.self, forKey: .percentChangeHour))!
        let percentChangeDay: Double = try Double(container.decode(String.self, forKey: .percentChangeDay))!
        let percentChangeWeek: Double = try Double(container.decode(String.self, forKey: .percentChangeWeek))!
        let lastUpdated: Int = try Int(container.decode(String.self, forKey: .lastUpdated))!

        self.init(id: id, name: name, symbol: symbol, rank: rank, priceUSD: priceUSD, percentChangeHour: percentChangeHour, percentChangeDay: percentChangeDay, percentChangeWeek: percentChangeWeek, lastUpdated: lastUpdated) // Initializing a Cryptocurrency
    }
}


/// Singleton object to store parsed JSON data
class CryptoRepo {
    static let shared = CryptoRepo()
    
    private var orderedCryptoList: [Cryptocurrency] = []
    private var cryptoList: [String: Cryptocurrency] = [:]
    
    /**
     Adds the given an element of type Cryptocurrency
     
     - Parameter element: `Cryptocurrency` element to add to list
    */
    func add(element: Cryptocurrency) {
        trackOrder(element: element)
        let key : String = element.id
        cryptoList[key] = element
    }
    
    /**
     Returns an `Array` of `Cryptocurrency` elements
     
     - Returns: An `Array` containing the `Cryptocurrency` elements in the list
    */
    func getCryptoList() -> [Cryptocurrency] {
        return orderedCryptoList
    }
    
    /**
     Gets an `Int` that is the length of cryptoList
     
     - Returns: An `Int` that is the length of cryptoList
     */
    func getCount() -> Int {
        return cryptoList.count
    }
    
    /**
     Preserves the order of insertion
     
     - Parameter name: `Cryptocurrency` to preserve order of
    */
    private func trackOrder(element: Cryptocurrency) {
        orderedCryptoList.append(element)
    }
    
    /*
     
    */
    func getElemById(id : String) -> Cryptocurrency {
        // TODO: Consider checking before unwrapping Optionals
        return cryptoList[id]!
    }
}

/// A way to communicate with the CoinMarketCap API
class CoinAPIHelper: NSObject {
    /// Base URL of the CoinMarketCap API
    private let url = URL(string: "https://api.coinmarketcap.com/v1")!

    /**
     Endpoints for the CoinMarketCap API
     
     - Ticker: Contains information about individual cryptocurrencies.
     - Global: Contains information about the aggregate sum of all cryptocurrencies.
    */
    private enum Endpoints: String {
        case ticker = "/ticker/"
        case global = "/global/"
    }

    // MARK: Public functions
    /**
     Deprecated: Updates the stored information using data from the CoinMarketCap API
     */
    @available(*, deprecated, message: "Deprecated because async functionality not documented, nor handled correctly. Please use update(completionHandler:)")
    public func update() {
        // TODO: Check for network connectivity
        // Create URLSession and start a download task
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let task = session.downloadTask(with: url.appendingPathComponent(Endpoints.ticker.rawValue))
        task.resume()
    }
    
    /**
     Updates the stored information using data from the CoinMarketCap API and calls a handler upon completion.
     
     - Parameter completionHandler: The completion handler to call when the load request is complete.
     */
    public func update(completionHandler: @escaping () -> Void) {
        // TODO: Check for network connectivity
        // Create URLSession and start a download task
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let task = session.downloadTask(with: url.appendingPathComponent(Endpoints.ticker.rawValue)) {
            location, response, error in
            if error != nil {
                print("Error downloading file: \(error.debugDescription)")
                self.loadFromLocalStorage(at: nil)
            }
            guard let localLocation: URL = location else {
                print("Error grabbing local url from download.")
                self.loadFromLocalStorage(at: nil)
                return
            }
            // Check for HTTP status code 2xx
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print ("Server error in downloading from API in CoinAPIHelper")
                    self.loadFromLocalStorage(at: nil)
                    return
            }
            // Attempt to load JSON from the download at location
            self.loadFromLocalStorage(at: localLocation)
            // Call the user defined completion handler
            completionHandler()
        }
        task.resume()
    }

    // MARK: Private functions
    /**
     Attempts to load and copy JSON from local storage `at` url to a static location. If `at` is nil,
     attempt to load JSON from the static location only.
     
     - Parameter at: URL location of a location to load and copy from, or nil to load from a static location
    */
    private func loadFromLocalStorage(at: URL?) {
        do {
            // Grab location of documents folder
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            // Save to a static file cryptoJSON
            let saveToURL = documentsURL.appendingPathComponent("cryptoJSON")
            if at != nil {
                // Replace existing file with a newer version
                if FileManager.default.fileExists(atPath: saveToURL.path) {
                    try FileManager.default.removeItem(at: saveToURL)
                }
                try FileManager.default.moveItem(at: at!, to: saveToURL)
            }
            // Load JSON data
            let cryptoData = try Data(contentsOf: saveToURL)
            let cryptoArray = try JSONDecoder().decode([Cryptocurrency].self, from: cryptoData)
            
            // Populate CryptoRepo
            let cryptoRepo = CryptoRepo.shared
            for e in cryptoArray {
                cryptoRepo.add(element: e)
            }
        } catch (let writeError) {
            print("Error reading/writing from file in CoinAPIHelper: \(writeError)")
        }
    }
}

// MARK: URLSessionDelegate
extension CoinAPIHelper: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    /**
     Tells the delegate that a download task has finished downloading.
     
     - Parameter session: The session containing the download task that finished.
     - Parameter downloadTask: The download task that finished.
     - Parameter location: A file URL for the temporary file. Because the file is temporary, you must either open the file for reading or move it to a permanent location in your app’s sandbox container directory before returning from this delegate method.
     If you choose to open the file for reading, you should do the actual reading in another thread to avoid blocking the delegate queue.
     */
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Check for HTTP status code 2xx
        guard let httpResponse = downloadTask.response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                print ("Server error in downloading from API in CoinAPIHelper.urlSession()")
                self.loadFromLocalStorage(at: nil)
                return
        }
        // Attempt to load JSON from the download at location
        loadFromLocalStorage(at: location)
    }

    /**
     Tells the delegate that the task finished transferring data.
     
     - Parameter session: The session containing the task whose request finished transferring data.
     - Parameter task: The task whose request finished transferring data.
     - Parameter error: If an error occurred, an error object indicating how the transfer failed, otherwise NULL.
    */
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Could not download JSON in CoinAPIHelper: \(error.debugDescription)")
            self.loadFromLocalStorage(at: nil)
        }
    }
}
