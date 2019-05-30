//
//  ViewController.m
//  SiriKitTest
//
//  Created by panzihao on 2019/5/30.
//  Copyright © 2019 panzihao. All rights reserved.
//

#import "ViewController.h"
#import "HSSpeechController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)tapSpeechBtn:(id)sender {
    HSSpeechController * controller = [[HSSpeechController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
