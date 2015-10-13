//
//  XDScaningViewController.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface XDScaningViewController : UIViewController

@property (nonatomic, copy) void (^backValue)(NSString *scannedStr);

@end


@interface XDScanningView : UIView

@end