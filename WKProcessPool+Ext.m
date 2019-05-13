//
//  WKProcessPool+Ext.m
//  WebViewInterface
//
//  Created by gaobo on 2019/4/23.
//  Copyright © 2019 com. All rights reserved.
//

#import "WKProcessPool+Ext.h"

@implementation WKProcessPool (Ext)
+ (WKProcessPool *)shared {
    static WKProcessPool *singler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singler = [[WKProcessPool alloc] init];
    });
    return singler;
}
@end


@implementation WKWebsiteDataStore (Ext)

+ (WKWebsiteDataStore *)shared {
    static WKWebsiteDataStore *singler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singler = [WKWebsiteDataStore defaultDataStore];
    });
    return singler;
}

@end
