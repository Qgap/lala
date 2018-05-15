//
//  UIConstants.swift
//  Weather
//
//  Created by gap on 2017/12/8.
//  Copyright © 2017年 gq. All rights reserved.
//

import UIKit

class UIConstants: NSObject {
    
    var hd = Resolution.init(width: 20, height: 20)
    
    var video = Video.init()
}

class Smart {
    
    static let SmartAPI = "http://jisuznwd.market.alicloudapi.com/iqa/query"
    static let AppKey = "24616869"
    static let AppSecret = "ac60ae5e69f3db397a6353231216b08f"
    static let AppCode = "5afe0d6397a348558ce8c64f4c93097a"

}

class City {
    static let CityAPI = ""
    static let AppKey = "24616869"
    static let AppSecret = "ac60ae5e69f3db397a6353231216b08f"
    static let AppCode = "5afe0d6397a348558ce8c64f4c93097a"
}

class Weather {
    static let WeatherAPI = ""
    static let AppKey = "24616869"
    static let AppSecret = "ac60ae5e69f3db397a6353231216b08f"
    static let AppCode = "5afe0d6397a348558ce8c64f4c93097a"
}

class Video {
    
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name = "hello"
}

struct Resolution {
    var width = 0
    var height = 0
}
