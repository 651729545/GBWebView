//
//  WKProcessPool+Ext.h
//  WebViewInterface
//
//  Created by gaobo on 2019/4/23.
//  Copyright © 2019 com. All rights reserved.
//
//  WkWebView数据池

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKProcessPool (Ext)
+ (WKProcessPool *)shared;
@end

@interface WKWebsiteDataStore (Ext)
+ (WKWebsiteDataStore *)shared;
@end

NS_ASSUME_NONNULL_END
