//
//  CustomImageView.swift
//  News Feed
//
//  Created by Akshit Akhoury on 28/07/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView : UIImageView
{
    var originalUrlString:String?
    
    func loadImageFromURLString(urlString:String) {
        originalUrlString = urlString
        var url = URL(string: urlString)
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        urlComp?.query = nil
        url = urlComp?.url
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if(error != nil)
            {
                print(error)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                let cacheImage = UIImage(data: data)
                if(self.originalUrlString == urlString)
                {
                    self.image = cacheImage
                }
                imageCache.setObject(cacheImage as AnyObject, forKey: urlString as AnyObject)
            }
        }.resume()
    }
}
