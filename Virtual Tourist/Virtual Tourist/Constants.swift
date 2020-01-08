//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-24.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import Foundation
struct Constants {
    struct flickr {
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        
     
    }
    struct flickrKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
         static let PerPage = "per_page"
    }
    
    struct flickrValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "46e0e5cb19a2478b751948c6f2805c3d"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let perPage = 9
        
    }
 
}
