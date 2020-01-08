//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-24.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import Foundation
import MapKit


struct FlickrAPI {
    static func getPhotosUrls(with coordinate: CLLocationCoordinate2D, pageNumber: Int, completion: @escaping([URL]?, Error?, String?) -> ()) {
        let methodParameters = [Constants.flickrKeys.Method: Constants.flickrValues.SearchMethod,
                                Constants.flickrKeys.APIKey: Constants.flickrValues.APIKey,
                                Constants.flickrKeys.BoundingBox: bboxString(for: coordinate), Constants.flickrKeys.SafeSearch: Constants.flickrValues.UseSafeSearch, Constants.flickrKeys.Extras: Constants.flickrValues.MediumURL,
                                Constants.flickrKeys.Format: Constants.flickrValues.ResponseFormat,
                                Constants.flickrKeys.NoJSONCallback: Constants.flickrValues.DisableJSONCallback,
                                Constants.flickrKeys.Page: pageNumber, Constants.flickrKeys.PerPage: Constants.flickrValues.perPage,
        ] as [String: Any]
        
        let request = URLRequest(url: getURL(from: methodParameters))
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                completion(nil,error, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode>=200 && statusCode<=299 else {
                completion(nil, nil, "status code is not acceptable")
                return

            }
            guard let data = data else {
                completion(nil, nil, "no data returned")
                return
            }
            
            guard let result = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]) else {
                completion(nil,nil,"Could not pass the data as JSON")
                return
                
                }
            guard let stat = result["stat"] as? String, stat == "ok" else {
                completion(nil,nil, "an error occured with flickr API")
                return
            }
            
            guard let photoDictionary = result ["photos"] as? [String: Any] else {
                completion(nil,nil, "cannot find the key in the results ")
                return
            }
            guard let photosArray = photoDictionary ["photo"] as? [[String: Any]] else {
            completion(nil,nil, "cannot find key in the photoDictionary ")
            return
            }
            
            let photosURLs = photosArray.compactMap {photoDictionary -> URL? in
                guard let url = photoDictionary["url_m"] as? String else {return nil}
                return URL(string: url)
            }
            
            completion(photosURLs,nil,nil)
        }
        task.resume()
    }
    
    
    static func bboxString (for coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let minimumLon = max(longitude - Constants.flickr.SearchBBoxHalfWidth, -180)
        let minimumLat = max(latitude - Constants.flickr.SearchBBoxHalfHeight, -90)
        let maximumLon = min(longitude + Constants.flickr.SearchBBoxHalfWidth, 180)
        let maximumLat = min(latitude + Constants.flickr.SearchBBoxHalfHeight, 90)
        return"\(minimumLon), \(minimumLat), \(maximumLon), \(maximumLat)"
        
    }
    static func getURL (from parameters: [String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path =  "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
        
    }
}
