#import "DDYDocumentPreviewController.h"
#import <QuickLook/QuickLook.h>

@interface DDYDocumentPreviewController ()<QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (nonatomic, strong) QLPreviewController *previewController;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation DDYDocumentPreviewController

- (QLPreviewController *)previewController {
    if (!_previewController) {
        _previewController = [[QLPreviewController alloc] init];
        _previewController.delegate = self;
        _previewController.dataSource = self;
        _previewController.view.frame = self.view.bounds;
        // 解开模态时会有导航
        // [self addChildViewController:_previewController];
    }
    return _previewController;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont boldSystemFontOfSize:25];
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"可能打不开此类文档";
        _tipLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _tipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(copyToOtherApp)];
    [self.view addSubview:self.previewController.view];
    [self.view addSubview:self.tipLabel];
}

- (NSInteger)handleURL {
    if (_localURL && [QLPreviewController canPreviewItem:_localURL]) {
        self.tipLabel.hidden = YES;
        return 1;
    } else {
        self.tipLabel.hidden = NO;
        return 0;
    }
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return [self handleURL];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return _localURL;
}

- (void)setLocalURL:(NSURL *)localURL {
    _localURL = localURL;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.previewController reloadData];
    });    
}

- (void)copyToOtherApp {
    // 强引用防止过早释放 crash : UIDocumentInteractionController has gone away prematurely!
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:_localURL];
    [_documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

@end
