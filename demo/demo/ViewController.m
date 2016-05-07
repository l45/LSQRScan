//
//  ViewController.m
//  hkhjkhk
//
//  Created by ls on 16/5/7.
//  Copyright © 2016年 iosItem. All rights reserved.
//

#import "ViewController.h"
#import "LSQRScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(action);
    
}

- (void)action {
//    NSLog(@"%s", __func__);
    
    LSQRScanViewController *vc = [LSQRScanViewController QRScanVCWithHandle:^(NSString *qrCode, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        if (error) {
            return ;
        }
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                [obj performSelector:@selector(setText:) withObject:qrCode];
                *stop = YES;
            }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
