//
//  WebViewController.h
//  WorldCup
//
//  Created by gaobo on 2018/4/16.
//  Copyright © 2018年 xlan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : BaseViewController
- (instancetype _Nullable )initWithUrl:(NSString * _Nonnull )urlString title:(NSString * _Nullable )title;
@property (nonatomic, copy) NSString * _Nullable url;
@property (nonatomic, copy) NSString * _Nullable titleStr;
@property (nonatomic) BOOL canFixTitle; // default is YES
@property (nonatomic) BOOL canRefresh;
@end
