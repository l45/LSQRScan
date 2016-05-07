#import "LSQRScanView.h"
#import <AVFoundation/AVFoundation.h>


@interface LSQRScanView ()

@property (nonatomic, assign) CGRect qrRect;

@end


@implementation LSQRScanView

+ (Class)layerClass {
    //  告诉这个View创建它时候，使用layer是AVCaptureVideoPreviewLayer
    return [AVCaptureVideoPreviewLayer class];
}

+ (instancetype)qrScanViewWithSession:(AVCaptureSession *)session qrRect:(CGRect)rect {
    
    LSQRScanView *qrScanView = [[LSQRScanView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//  取出Layer
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)qrScanView.layer;
//  关联session
    layer.session = session;
    
    qrScanView.qrRect = rect;
    
    [qrScanView prepareUI];
    
    return qrScanView;
}

- (void)prepareUI {
    
    // 添加扫描区域
    UIImageView *qrView = [[UIImageView alloc] initWithFrame:self.qrRect];
    qrView.image = [UIImage imageNamed:@"LSQRCode.bundle/pick_bg"];
    [self addSubview:qrView];
    
    CGRect scanLineRect = self.qrRect;
    scanLineRect.size.height = 2;
    scanLineRect.origin.y += 4;
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:scanLineRect];
    scanLine.image = [UIImage imageNamed:@"LSQRCode.bundle/line"];
    [self addSubview:scanLine];
    
    // 添加边缘
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetMaxX(self.bounds), CGRectGetMinY(self.qrRect))];
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.qrRect), CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMaxY(self.qrRect))];
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.qrRect), CGRectGetMinX(self.qrRect), CGRectGetHeight(self.qrRect))];
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.qrRect), CGRectGetMinY(self.qrRect), CGRectGetMaxX(self.bounds) - CGRectGetMaxX(self.qrRect), CGRectGetHeight(self.qrRect))];
    NSArray *array = @[viewTop, viewLeft, viewBottom, viewRight];
    [array makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:[UIColor colorWithWhite:0. alpha:0.8]];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
    [self lineAnimationWithLine:scanLine];
    
}

- (void)lineAnimationWithLine:(UIView *)line {
//  创建动画
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    lineAnimation.fromValue = @(0);
    lineAnimation.toValue = @(self.qrRect.size.height - 10);
    lineAnimation.duration = 2;
    lineAnimation.repeatCount = NSIntegerMax;
//  添加动画到line上
    [line.layer addAnimation:lineAnimation forKey:@"lineAnnimation"];
}

@end
