#import <UIKit/UIKit.h>

@class AVCaptureSession;
@interface LSQRScanView : UIView

+ (instancetype)qrScanViewWithSession:(AVCaptureSession *)session qrRect:(CGRect)rect;

@end
