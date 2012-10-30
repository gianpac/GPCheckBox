//
//  ViewController.m
//  GPCheckBoxDemo
//
//  Created by Giancarlo Pacheco on 2012-10-29.
//  Copyright (c) 2012 Giancarlo Pacheco. All rights reserved.
//

#import "ViewController.h"
#import "GPCheckBox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    GPCheckBox *checkbox = [[GPCheckBox alloc] init];
    [checkbox addTarget:self action:@selector(checkBoxSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkbox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkBoxSelected:(GPCheckBox *)checkbox {
    NSLog(@"STATE : %@", checkbox.isSelected ? @"Selected" : @"Normal");
}

@end
