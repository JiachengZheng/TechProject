//
//  TPNoticeDetailVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeDetailVCL.h"
#import <WebKit/WebKit.h>
@interface TPNoticeDetailVCL ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progress;
@end

@implementation TPNoticeDetailVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"通告" enableBackButton:YES];
    [self.view addSubview:naviBar];
    [self addWebView];
    [self loadReqeust];
    // Do any additional setup after loading the view.
}

- (void)addWebView{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, TPScreenHeight - TPStatusBarAndNavigationBarHeight - TPTabbarSafeBottomMargin)];
    
    webView.UIDelegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.navigationDelegate = self;
    self.webView = webView;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:webView];
}

- (void)loadReqeust{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (UIProgressView *)progress{
    if (_progress == nil){
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, TPStatusBarAndNavigationBarHeight-2, TPScreenWidth, 2)];
        _progress.progressTintColor = [UIColor redColor];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        if (object == self.webView){
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3f
                                      delay:0.1f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}


@end
