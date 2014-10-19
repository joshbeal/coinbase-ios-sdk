//
//  CBAuthorizationViewController.m
//  Pods
//
//  Created by Josh Beal on 10/18/14.
//
//

#import "CBAuthorizationViewController.h"
#import "Coinbase.h"

@interface CBAuthorizationViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CBAuthorizationViewController

- (instancetype)initWithURL:(NSURL *)authURL {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect b = self.view.bounds;
    
    self.webView.frame = CGRectMake(0, 0, CGRectGetWidth(b), CGRectGetHeight(b));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![theTitle isEqualToString:@"Coinbase"]) {
        [Coinbase registerAuthCode:theTitle];
    }
    NSLog(@"%@", theTitle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
