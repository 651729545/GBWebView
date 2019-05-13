//
//  WebViewController.m
//  WorldCup
//
//  Created by gaobo on 2018/4/16.
//  Copyright © 2018年 xlan. All rights reserved.
//

#import "WebViewController.h"
#import "WUWebView.h"


@interface WebViewController () <WUWebViewDelegate>

@property (nonatomic, strong) WUWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;

@end

@implementation WebViewController

- (void)dealloc
{
    NSLog(@"__%@__%@__", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (instancetype)initWithUrl:(NSString *)urlString title:(NSString *)title {
    self = [super init];
    if (self) {
        self.url = urlString;
        self.titleStr = title;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canFixTitle = YES;
        _canRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupValues];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)setupSubviews {
    
    [self.view addSubview:self.webView];
    [self handleLeftBarItem];
}

- (void)setupValues {
    
    if (self.url == nil || [self.url length] == 0 || ![self.url hasPrefix:@"http"]) {
        
        self.url = [self.params objectForKey:@"url"];
    }
    else if ([self.url hasPrefix:@"http"]) {
        
        [self.webView loadWithUrlString:self.url];
    }
    
    if (self.titleStr == nil || [self.titleStr length] == 0) {
        
        self.titleStr = [self.params objectForKey:@"title"];
    }
    
    self.title = self.titleStr;
    RAC(self.webView, canRefresh) = RACObserve(self, canRefresh);
}




#pragma mark - setter
- (void)setUrl:(NSString *)url {
    _url = url;
    
    if (_webView) {
        [self.webView loadWithUrlString:self.url];
    }
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    self.title = titleStr;
}





#pragma mark - private
- (void)handleLeftBarItem {
    
    if (self.webView.canGoBack) {
        [self.navigationItem setLeftBarButtonItems:@[self.backItem,self.cancelItem]];
    }
    else {
        [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
    }
}





#pragma mark -- response
- (void)goback {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else {
        [self stock_goback];
    }
}
- (void)cancel {
    [self stock_goback];
}





#pragma mark -- WCWebViewDelegate
- (void)webViewDidStartLoad:(WUWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(WUWebView *)webView {
    
    [self handleLeftBarItem];
    if (self.canFixTitle) {
        self.title = self.webView.title;
    }
}
- (void)webView:(WUWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self handleLeftBarItem];
    
}
- (BOOL)webView:(WUWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}






#pragma mark - lazy
- (WUWebView *)webView {
    if (!_webView) {
        _webView = [[WUWebView alloc] initWithFrame:self.view.bounds];
        _webView.webdelegate = self;
    }
    return _webView;
}
- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    }
    return _backItem;
}
- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    return _cancelItem;
}

@end

