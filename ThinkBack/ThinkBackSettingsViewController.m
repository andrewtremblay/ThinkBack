//
//  ThinkBackSettingsViewController.m
//  ThinkBack
//
//  Created by AndrewTremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import "ThinkBackSettingsViewController.h"

@interface ThinkBackSettingsViewController ()

@end

@implementation ThinkBackSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Nav
- (IBAction)backButtonPressed:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

@end
