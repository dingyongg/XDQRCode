//
//  Config.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/27.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#ifndef XDQRCode_Config_h
#define XDQRCode_Config_h

typedef NS_ENUM(NSInteger, XDScaningViewCoverMode) {
    XDScaningViewCoverModeClear  = 0,
    XDScaningViewCoverModeNormal   = 1,
    XDScaningViewCoverModeBlur = 2,
};

#define transparentArea CGSizeMake(200, 200)
#define coverMode XDScaningViewCoverModeNormal




#endif
