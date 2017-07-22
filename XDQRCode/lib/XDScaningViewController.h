//
//  XDScaningViewController.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface XDScaningViewController : UIViewController

@property (nonatomic, copy) void (^backValue)(NSString *scannedStr);

@end


@class XDScanningView;
@protocol XDScanningViewDelegate <NSObject>

- (void)view:(UIView*)view didCatchGesture:(UIGestureRecognizer *)gesture;

@end

@interface ViewController ()

@property (copy, nonatomic) NSString *outP;
@end

@interface XDScanningView : UIView
@property (weak, nonatomic) id<XDScanningViewDelegate> delegate;
+ (NSInteger)width;
+ (NSInteger)height;
@end