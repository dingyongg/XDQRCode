//
//  XDScaningViewController.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import "XDScaningViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface XDScaningViewController ()<UIAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureInput *input;
    AVCaptureMetadataOutput *output;
    BOOL isTorchOn;
}

@end

@implementation XDScaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCapture];
    [self initOverView];
    [self initUI];
    
}
- (void)initUI{
    
    if (self.navigationController) {
        if (!self.navigationController.navigationBarHidden) {
            self.navigationController.navigationBarHidden = YES;
        }
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 25, 20)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBUttonActioin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *torch = [[UIButton alloc]initWithFrame:CGRectMake(200, 25, 32, 32)];
    [torch setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
    [torch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [torch addTarget:self action:@selector(openTorch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *history = [[UIButton alloc]initWithFrame:CGRectMake(260, 25, 27, 27)];
    [history setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
    [history setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [history addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:history];
    [self.view addSubview:torch];
    [self.view addSubview:backButton];
    
}
- (void)initOverView{
    
    XDScanningView *scanningView = [[XDScanningView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scanningView];
}

- (void)initCapture{
    
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in devices) {
        if (camera.position == AVCaptureDevicePositionFront) {
            frontCamera = camera;
        }else{
            backCamera = camera;
        }
    }
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    [session startRunning];
    
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    
    CGRect cropRect = CGRectMake((screenWidth - transparentArea.width) / 2,
                                 (screenHeight - transparentArea.height) / 2,
                                 transparentArea.width,
                                 transparentArea.height);
    
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];

    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if (metadataObjects.count > 0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject *metadateObject = [metadataObjects objectAtIndex:0];
        stringValue = metadateObject.stringValue;
    }
    
    self.backValue(stringValue);
    [self backBUttonActioin:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ -- 内存警告", self.description);
    // Dispose of any resources that can be recreated.
}

- (void)backBUttonActioin:(UIButton *)button{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)history:(UIButton *)button{
    NSLog(@"history");
}

- (void)openTorch:(UIButton *)button{
    isTorchOn = !isTorchOn;
    [backCamera lockForConfiguration:nil];
    if (isTorchOn) {
        [backCamera setTorchMode:AVCaptureTorchModeOn];
        [button setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
    }else{
        [backCamera setTorchMode:AVCaptureTorchModeOff];
        [button setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
    }
    [backCamera unlockForConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController) { //如果继续隐藏导航栏 注掉此代码即可
        self.navigationController.navigationBarHidden = NO;
    }
}

@end


@implementation XDScanningView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 40/255.0, 40/255.0, 40/255.0, .5);
    
    
    
    CGContextFillRect(context, rect);
    CGRect clearDrawRect = CGRectMake(rect.size.width / 2 - transparentArea.width / 2,
                                      rect.size.height / 2 - transparentArea.height / 2,
                                      transparentArea.width,transparentArea.height);
    CGContextClearRect(context, clearDrawRect);
    [self addWhiteRect:context rect:clearDrawRect];
    [self addCornerLineWithContext:context rect:clearDrawRect];
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}
@end



