//
//  ThinkBackSettingsViewController.h
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThinkBackSettingsViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *contextDetectSwitch;
- (IBAction)contextDetectSwitchValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *webOptionsSegmentedControl;
- (IBAction)webOptionsSegmentedControlValueChanged:(id)sender;

//nav buttons
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
