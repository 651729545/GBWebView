//
//  WebViewInitManager.m
//  WebViewModule
//
//  Created by gaobo on 2019/5/9.
//  Copyright © 2019 stock. All rights reserved.
//

#import "WebViewInitManager.h"
#import <ReactiveCocoa.h>
#import <objc/runtime.h>
#import <Aspects.h>
#import "JsStatic.h"
#import "WUWebView.h"


@interface WebViewInitManager ()
@property (nonatomic) Class clazz;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *methodList;
@end

@implementation WebViewInitManager

+ (WebViewInitManager *)sharedManager {
    static WebViewInitManager *singler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singler = [WebViewInitManager new];
    });
    return singler;
}

+ (void)initWithMethodClass:(Class)clazz bridgeIdentifier:(NSString *)identifier {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [WebViewInitManager sharedManager].clazz = clazz;
        [WebViewInitManager sharedManager].identifier = identifier ? identifier : @"app";
        
        [[WebViewInitManager sharedManager] webViewInject];
        [[WebViewInitManager sharedManager] webViewBridge];
        
    });
}

+ (void)callBackNative:(void (^)(NSString * _Nonnull, NSDictionary * _Nonnull))callBack {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [WebViewInitManager sharedManager].CallBack = callBack;
        
    });
}



// 获取本地方法，拼接成字符串
- (NSString *)methodList {
    if (!_methodList) {
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList([self.clazz class], &methodCount);
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < methodCount; i++) {
            NSString *method = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
            if ([method containsString:@"."]) continue;
            [array addObject:[NSString stringWithFormat:@"\"%@\"",[method stringByReplacingOccurrencesOfString:@":" withString:@""]]];
        }
        _methodList = [array componentsJoinedByString:@","];
    }
    return _methodList;
}
// jsbridge
- (void)bridgeWithAbsoluteString:(NSString *)target {
    
    if ([target hasPrefix:@"jscall"]) {

        @try {
            NSArray *components = [target componentsSeparatedByString:@":"];
            NSString *selectorName = [NSString stringWithFormat:@"%@:",[components objectAtIndex:1]];
            NSString *jsonStr = [(NSString*)[components objectAtIndex:2] stringByRemovingPercentEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
            NSDictionary *args = @{};
            if ([jsonDic count]) {
                args = [NSJSONSerialization JSONObjectWithData:[(NSString *)[jsonDic objectForKey:@"0"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
            }
            if (self.CallBack) {
                self.CallBack(selectorName, args);
            }
        }
        @catch (NSException *exception) {}
        @finally {}
    }
}


// WebView注入js
- (void)webViewInject {
    
    NSString *bridgeStr = [NSString stringWithFormat:exchange, self.identifier, self.methodList];
    
    if (@available(iOS 11.0, *)) {
        
        [WUWebView aspect_hookSelector:@selector(webView:didFinishNavigation:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, WKWebView *webView, WKNavigation *navigation) {
            
            [webView evaluateJavaScript:[NSString stringWithFormat:check, self.identifier] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                
                if (![obj boolValue]) {
                    [webView evaluateJavaScript:bridgeStr completionHandler:^(id _Nullable obj1, NSError * _Nullable error) {
                        
                    }];
                }
            }];
        } error:nil];
    }
    else {
        
        [WUWebView aspect_hookSelector:@selector(webViewDidFinishLoad:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, UIWebView *webView) {
            
            NSString *result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:check, self.identifier]];
            if (![result isEqualToString:@"true"]) {
                
                [webView stringByEvaluatingJavaScriptFromString:bridgeStr];
            }
        } error:nil];
    }
}
// WebView拦截跳转
- (void)webViewBridge {
    
    @weakify(self);
    if (@available(iOS 11.0, *)) {
        
        [WUWebView aspect_hookSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, WKWebView *webView, WKNavigationAction *navigationAction, void (^decisionHandler)(WKNavigationActionPolicy)) {
            @strongify(self)
            
            [self bridgeWithAbsoluteString:navigationAction.request.URL.absoluteString];
        } error:nil];
    }
    else {
        
        [WUWebView aspect_hookSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType) {
            @strongify(self)
            
            [self bridgeWithAbsoluteString:request.URL.absoluteString];
        } error:nil];
    }
}



@end
