
#import <TOWebViewController/TOWebViewController.h>

#define kTransformSafariWebView @"#_WEBVIEW_#"

@interface GQWebViewController : TOWebViewController

@property(nonatomic,assign)int showHongBaoList;

-(instancetype)cookBook_WebWithURLString:(NSString *)urlString;

@end
