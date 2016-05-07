#import <UIKit/UIKit.h>

@interface LSQRScanViewController : UIViewController

/// 返回控制器的类方法，callback会被强引用
+ (instancetype) QRScanVCWithHandle:(void (^)(NSString *qrCode, NSError *error))callback;

@end
