//
//  WUWebView.h
//  WebViewInterface
//
//  Created by gaobo on 2019/4/24.
//  Copyright © 2019 com. All rights reserved.
//
//  WebView，ios11之前使用UIWebView，ios11之后使用WKWebView

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JsStatic.h"

NS_ASSUME_NONNULL_BEGIN

@class WUWebView;
@protocol WUWebViewDelegate <NSObject>  // 同UIWebView代理方法

@optional
- (BOOL)webView:(WUWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(WUWebView *)webView;
- (void)webViewDidFinishLoad:(WUWebView *)webView;
- (void)webView:(WUWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface WUWebView : UIView
@property (nonatomic, weak) id<WUWebViewDelegate>_Nullable webdelegate;

// 网页标题
@property (nonatomic, strong, readonly) NSString *title;
// 原始request
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;
// 是否可回退
@property (nonatomic, readonly) BOOL canGoBack;
// 是否可前进
@property (nonatomic, readonly) BOOL canGoForward;
// 是否加载中
@property (nonatomic, readonly) BOOL loading;
// 是否可下拉刷新
@property (nonatomic) BOOL canRefresh;

// 初始化
- (instancetype)initWithFrame:(CGRect)frame;

// 加载链接
- (void)loadWithUrlString:(NSString *)urlstring;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL;
// 重载
- (void)reload;
// 重新加载原始网页
- (void)reloadFromOrigin;
// 停止加载
- (void)stopLoading;
// 后退
- (void)goBack;
// 前进
- (void)goForward;
// js注入方法
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id obj, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
