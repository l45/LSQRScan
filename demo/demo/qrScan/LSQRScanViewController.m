#import "LSQRScanViewController.h"
#import "LSQRScanView.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenHeight ScreenBounds.size.height
#define ScreenWidth ScreenBounds.size.width


#warning TODO 在这里修改范围
#define LSRectDefault CGRectMake(ScreenWidth * 0.1, ScreenHeight * 0.5 - ScreenWidth * 0.4, ScreenWidth * 0.8, ScreenWidth * 0.8)
#define LSQRRect LSRectDefault


@interface LSQRScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

/// 回调block
@property (nonatomic, copy) void (^callbackBlock)(NSString *qrCode, NSError *error);

@end

@implementation LSQRScanViewController

/// 返回控制器的类方法，callback会被强引用
+ (instancetype) QRScanVCWithHandle:(void (^)(NSString *qrCode, NSError *error))callback {
    LSQRScanViewController *vc = [[LSQRScanViewController alloc] init];
    vc.callbackBlock = callback;
    return vc;
}

- (void)loadView {
    //  创建session
    self.session = [[AVCaptureSession alloc] init];
    //  把会话给预览视图
    self.view = [LSQRScanView qrScanViewWithSession:self.session qrRect:LSQRRect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 捕获设备,默认后置摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        self.callbackBlock(nil, error);
        return;
    }
    // 元数据输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 建立通道
    if ([self.session canAddInput:input] && [self.session canAddOutput:output]) {
        [self.session addInput:input];
        [self.session addOutput:output];
    } else {
        self.callbackBlock(nil, [NSError errorWithDomain:@"com.ios.sc.ls" code:-8080 userInfo:@{@"describe":@"通道创建失败"}]);
        return;
    }
    // 设置元数据输出对象相关属性
//    output.metadataObjectTypes = @[@"org.iso.QRCode"]; // 这句代码也可以
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // 设置扫描范围
    // 注意这里的矩阵变换，不知道apple为什么要这样做
    // demo中有图片可以说明这点
    CGFloat x = LSQRRect.origin.y / ScreenHeight;
    CGFloat y = (ScreenWidth - LSQRRect.origin.x - LSQRRect.size.width) / ScreenWidth;
    CGFloat width = LSQRRect.size.height / ScreenHeight;
    CGFloat height = LSQRRect.size.width / ScreenWidth;
    [output setRectOfInterest:CGRectMake(x, y, width, height)];
    // 实现代理方法
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 开始扫描
    [self.session startRunning];
}
/**
 代理方法
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject *objc =[metadataObjects firstObject];
    // 回调
    self.callbackBlock(objc.stringValue, nil);
    
    [self.session stopRunning];
}

@end
