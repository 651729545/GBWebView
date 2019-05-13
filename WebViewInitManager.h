//
//  WebViewInitManager.h
//  WebViewModule
//
//  Created by gaobo on 2019/5/9.
//  Copyright © 2019 stock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewInitManager : NSObject
+ (WebViewInitManager *)sharedManager;
@property (nonatomic, copy) void (^CallBack)(NSString *selectorName, NSDictionary *params);
/**
 *  初始化WebView配置，只能执行一次
 *  param clazz 实现本地方法的类，需要从此类获取方法列表注入iframe
 *  param identifier jsbeidge的标识，传入nil则为默认，默认为 @"app"
 */
+ (void)initWithMethodClass:(Class)clazz bridgeIdentifier:(NSString *)identifier;

/**
 *  js调用本地方法的回调
 *  param selectorName 方法名
 *  param params 参数
 */
+ (void)callBackNative:(void (^)(NSString *selectorName, NSDictionary *params))callBack;
@end

NS_ASSUME_NONNULL_END
