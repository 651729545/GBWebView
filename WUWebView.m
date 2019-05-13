//
//  WUWebView.m
//  WebViewInterface
//
//  Created by gaobo on 2019/4/24.
//  Copyright © 2019 com. All rights reserved.
//

#import "WUWebView.h"
#import <ReactiveCocoa.h>
#import "WKProcessPool+Ext.h"
#import <MJRefresh.h>
#import "AnimationRefreshHeader.h"


@interface WUWebView () <WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) NSURLRequest *originRequest;
@end

@implementation WUWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            
            [self addSubview:self.wkWebView];
            
            RAC(self.progressView, progress) = RACObserve(self.wkWebView, estimatedProgress);
            
            if (@available(iOS 11.0, *)) {
                @weakify(self);
                [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @strongify(self);
                    [self.wkWebView.configuration.websiteDataStore.httpCookieStore setCookie:obj completionHandler:^{
                        
                    }];
                    NSLog(@"%@ - %@", obj.name, obj.value);
                }];
            }
        }
        else {
            
            [self addSubview:self.uiWebView];
        }
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.wkWebView.frame = self.bounds;
    }else {
        self.uiWebView.frame = self.bounds;
    }
    self.progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 5);
}





- (NSString *)title {
    if (@available(iOS 11.0, *)) {
        return self.wkWebView.title;
    } else {
        return [self.uiWebView stringByEvaluatingJavaScriptFromString:documentTitle];
    }
}
- (NSURLRequest *)currentRequest {
    if (@available(iOS 11.0, *)) {
        return [NSURLRequest requestWithURL:self.wkWebView.URL];
    }else {
        return self.uiWebView.request;
    }
}
- (BOOL)canGoBack {
    if (@available(iOS 11.0, *)) {
        return self.wkWebView.canGoBack;
    }else {
        return self.uiWebView.canGoBack;
    }
}
- (BOOL)canGoForward {
    if (@available(iOS 11.0, *)) {
        return self.wkWebView.canGoForward;
    }else {
        return self.uiWebView.canGoForward;
    }
}
- (BOOL)loading {
    if (@available(iOS 11.0, *)) {
        return self.wkWebView.isLoading;
    }else {
        return self.uiWebView.isLoading;
    }
}
- (void)setCanRefresh:(BOOL)canRefresh {
    _canRefresh = canRefresh;
    
    @weakify(self);
    if (@available(iOS 11.0, *)) {
        if (canRefresh && self.wkWebView.scrollView.mj_header == nil) {
            self.wkWebView.scrollView.mj_header = [AnimationRefreshHeader headerWithRefreshingBlock:^{
                @strongify(self);
                
                [self reload];
            }];
        }
        else if (!canRefresh && self.wkWebView.scrollView.mj_header != nil) {
            self.wkWebView.scrollView.mj_header = nil;
        }
    }
    else {
        if (canRefresh && self.uiWebView.scrollView.mj_header == nil) {
            self.uiWebView.scrollView.mj_header = [AnimationRefreshHeader headerWithRefreshingBlock:^{
                @strongify(self);
                
                [self reload];
            }];
        }
        else if (!canRefresh && self.uiWebView.scrollView.mj_header != nil) {
            self.uiWebView.scrollView.mj_header = nil;
        }
    }
}
- (void)endRefresh {
    if (@available(iOS 11.0, *)) {
        if (self.wkWebView.scrollView.mj_header != nil &&
            self.wkWebView.scrollView.mj_header.isRefreshing) {
            
            [self.wkWebView.scrollView.mj_header endRefreshing];
        }
    }
    else {
        if (self.uiWebView.scrollView.mj_header != nil &&
            self.uiWebView.scrollView.mj_header.isRefreshing) {
            
            [self.uiWebView.scrollView.mj_header endRefreshing];
        }
    }
}




#pragma mark - public func
- (void)loadWithUrlString:(NSString *)urlstring {
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]]];
}
- (void)loadRequest:(NSURLRequest *)request {
    self.originRequest = request;
    if (@available(iOS 11.0, *)) {
        [self.wkWebView loadRequest:request];
    } else {
        [self.uiWebView loadRequest:request];
    }
}
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView loadHTMLString:string baseURL:baseURL];
    }else {
        [self.uiWebView loadHTMLString:string baseURL:baseURL];
    }
}
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
    }else {
        [self.uiWebView loadData:data MIMEType:MIMEType textEncodingName:characterEncodingName baseURL:baseURL];
    }
}
- (void)reload {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView reload];
    } else {
        [self.uiWebView reload];
    }
}
- (void)reloadFromOrigin {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView reloadFromOrigin];
    } else {
        [self.uiWebView loadRequest:self.originRequest];
    }
}
- (void)stopLoading {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView stopLoading];
    } else {
        [self.uiWebView stopLoading];
    }
}
- (void)goBack {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView goBack];
    } else {
        [self.uiWebView goBack];
    }
}
- (void)goForward {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView goForward];
    } else {
        [self.uiWebView goForward];
    }
}
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler {
    if (@available(iOS 11.0, *)) {
        [self.wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }else {
        NSString *obj = [self.uiWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        completionHandler ? completionHandler(obj, nil) : nil;
    }
}




#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alert.textFields[0].text);
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}





#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        UIWebViewNavigationType type = UIWebViewNavigationTypeOther;
        switch (navigationAction.navigationType) {
            case WKNavigationTypeLinkActivated:
                type = UIWebViewNavigationTypeLinkClicked;
                break;
            case WKNavigationTypeFormSubmitted:
                type = UIWebViewNavigationTypeFormSubmitted;
                break;
            case WKNavigationTypeBackForward:
                type = UIWebViewNavigationTypeBackForward;
                break;
            case WKNavigationTypeReload:
                type = UIWebViewNavigationTypeReload;
                break;
            case WKNavigationTypeFormResubmitted:
                type = UIWebViewNavigationTypeFormResubmitted;
                break;
            default:
                break;
        }
        BOOL result = [self.webdelegate webView:self shouldStartLoadWithRequest:navigationAction.request navigationType:type];
        if (result){
            decisionHandler(WKNavigationActionPolicyAllow);
        }else {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    else decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.progressView.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webdelegate webViewDidStartLoad:self];
    }
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self endRefresh];
    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webdelegate webView:self didFailLoadWithError:error];
    }
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self endRefresh];
    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webdelegate webViewDidFinishLoad:self];
    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self endRefresh];
    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webdelegate webView:self didFailLoadWithError:error];
    }
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}




#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webdelegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    [UIView animateWithDuration:.5 animations:^{
        self.progressView.progress = .85;
    }];
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webdelegate webViewDidStartLoad:self];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self endRefresh];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:.25 animations:^{
        self.progressView.progress = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.progressView.hidden = YES;
        }
    }];
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webdelegate webViewDidFinishLoad:self];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self endRefresh];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:.25 animations:^{
        self.progressView.progress = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.progressView.hidden = YES;
        }
    }];
    if (self.webdelegate && [self.webdelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webdelegate webView:self didFailLoadWithError:error];
    }
}



#pragma mark - lazy
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.processPool = [WKProcessPool shared];
        configuration.websiteDataStore = [WKWebsiteDataStore shared];
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
        _wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _wkWebView;
}
- (UIWebView *)uiWebView {
    if (!_uiWebView) {
        _uiWebView = [[UIWebView alloc] initWithFrame:self.bounds];
        _uiWebView.delegate = self;
        _uiWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        if (@available(iOS 11.0, *)) {
            _uiWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _uiWebView;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor redColor];
        _progressView.progress = 0;
        _progressView.hidden = YES;
    }
    return _progressView;
}

@end





