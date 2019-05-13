//
//  JsStatic.h
//  WebViewInterface
//
//  Created by gaobo on 2019/4/23.
//  Copyright © 2019 com. All rights reserved.
//

#ifndef JsStatic_h
#define JsStatic_h


#pragma mark - 注入js，根据本地方法列表生成iframe
static NSString * const exchange = @"\
    ;(function() {      \
        var messagingIframe,  \
        bridge = '%@',     \
        CUSTOM_PROTOCOL_SCHEME = 'jscall';      \
        if (window[bridge]) { return }      \
        function _createQueueReadyIframe(doc) {     \
            messagingIframe = doc.createElement('iframe');      \
            messagingIframe.style.display = 'none';     \
            doc.documentElement.appendChild(messagingIframe);       \
        }       \
        window[bridge] = {};        \
        var methods = [%@];     \
        for (var i=0;i<methods.length;i++){     \
            var method = methods[i];    \
            var code = \"(window[bridge])[method] = function \" + method + \"() {messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + ':' + arguments.callee.name + ':' + encodeURIComponent(JSON.stringify(arguments));}\";      \
            eval(code);     \
        }       \
        _createQueueReadyIframe(document);      \
    })();";

#pragma mark - 检查网页是否支持jsbridge
static NSString * const check = @"typeof window.%@ == 'object'";

#pragma mark - 获取网页title
static NSString * const documentTitle = @"document.title";

#pragma mark - 获取图片链接的js方法
static NSString * const JSSearchImageFromHtml =
                            @"function JSSearchImage(x,y) {"
                                "return document.elementFromPoint(x, y).src;"
                            "}";

#pragma mark - 获取HTML所有的图片
static NSString * const JSSearchAllImageFromHtml =
                    @"function JSSearchAllImage(){"
                        "var img = [];"
                        "for(var i=0;i<$(\"img\").length;i++){"
                            "if(parseInt($(\"img\").eq(i).css(\"width\"))> 60){ "//获取所有符合放大要求的图片，将图片路径(src)获取
                                " img[i] = $(\"img\").eq(i).attr(\"src\");"
                            " }"
                        "}"
                        "var img_info = {};"
                        "img_info.list = img;" //保存所有图片的url
                        "return img;"
                    "}";



#endif /* JsStatic_h */
