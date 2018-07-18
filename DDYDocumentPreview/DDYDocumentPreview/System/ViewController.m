#import "ViewController.h"
#import "DDYDocumentPreviewController.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self btnWithY:DDYTopH + 10  title:@".doc"];
    [self btnWithY:DDYTopH + 50  title:@".docx"];
    [self btnWithY:DDYTopH + 90  title:@".epub"];
    [self btnWithY:DDYTopH + 130 title:@".pages"];
    [self btnWithY:DDYTopH + 170 title:@".pdf"];
    [self btnWithY:DDYTopH + 210 title:@".rtf"];
    [self btnWithY:DDYTopH + 250 title:@".txt"];
}

- (void)btnWithY:(CGFloat)y title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(10, y, DDYScreenW-20, 30)];
    [self.view addSubview:button];
}

- (void)handleClick:(UIButton *)sender {
    // 沙盒路径
    // NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // NSString *filePath = [documentPath stringByAppendingPathComponent:@"DDYTest.doc"];
    // NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    // bundle路径
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DDYTest" ofType:sender.titleLabel.text]];
    DDYDocumentPreviewController *previewVC = [[DDYDocumentPreviewController alloc] init];
    previewVC.localURL = fileURL;
    [self.navigationController pushViewController:previewVC animated:YES];
}

@end
