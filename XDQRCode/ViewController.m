//
//  ViewController.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import "ViewController.h"
#import "XDScaningViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的扫描";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scanning:(id)sender {
    
    XDScaningViewController *scanningVC = [[XDScaningViewController alloc]init];
    scanningVC.backValue = ^(NSString *scannedStr){
        
        self.scaningResultsLabel.text = scannedStr;
    };
    [self.navigationController pushViewController:scanningVC animated:YES];
}

@end
