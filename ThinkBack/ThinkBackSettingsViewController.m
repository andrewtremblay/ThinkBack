//
//  ThinkBackSettingsViewController.m
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import "ThinkBackSettingsViewController.h"
#import "ThinkBack.h"
#import "ThirdPartyAppFeatures.h"


@interface ThinkBackSettingsViewController ()
@property (nonatomic, assign) BOOL selectedContextDetect;
@property (nonatomic, strong) NSString *selectedWebPrompt;
@property (nonatomic, assign) NSInteger currentSelectedWebPromptIndex;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //get current values from settings
    self.selectedContextDetect = [ThinkBack shouldContextScan];
    self.selectedWebPrompt = [ThinkBack webPrompt];
    self.currentSelectedWebPromptIndex =
            [self.selectedWebPrompt isEqualToString:kSettingsWebOptionsSafari] ? 0 :
            [self.selectedWebPrompt isEqualToString:kSettingsWebOptionsChrome] ? 1 : 2; //kSettingsWebOptionsPopup
    [self updateUIForSettings];
}

-(void)updateUIForSettings
{
    BOOL hasChanges = NO;
    if(self.selectedContextDetect != [ThinkBack shouldContextScan])
    {
        hasChanges = YES;
    }
    [self.contextDetectSwitch setOn:self.selectedContextDetect];
    //TODO: check to animate view the show/hide other context detections

    
    //
    if(self.selectedWebPrompt != [ThinkBack webPrompt])
    {
        hasChanges = YES;
    }
    [self.webOptionsSegmentedControl setSelectedSegmentIndex:self.currentSelectedWebPromptIndex];
    [self.saveBtn setEnabled:hasChanges];
}

- (IBAction)contextDetectSwitchValueChanged:(id)sender
{
    self.selectedContextDetect = [self.contextDetectSwitch isOn];
    [self updateUIForSettings];
}

- (IBAction)webOptionsSegmentedControlValueChanged:(id)sender
{
    //get value from segmented controller
    
    switch(self.webOptionsSegmentedControl.selectedSegmentIndex){
        case 0:
            self.selectedWebPrompt = kSettingsWebOptionsSafari;
            self.currentSelectedWebPromptIndex = self.webOptionsSegmentedControl.selectedSegmentIndex;
            [self updateUIForSettings];
            break;
        case 1:
            //detect for chrome,
            //if no chrome, present alertview to install,
            //otherwise treat as normal
            if([ThirdPartyAppFeatures canDetectChrome]) {
                self.selectedWebPrompt = kSettingsWebOptionsChrome;
                self.currentSelectedWebPromptIndex = self.webOptionsSegmentedControl.selectedSegmentIndex;
                [self updateUIForSettings];
            } else {
                [ThirdPartyAppFeatures presentInstallationAlertViewForChromeWithDelegate:self];
            }
            break;
        case 2:
            self.selectedWebPrompt = kSettingsWebOptionsPopup;
            self.currentSelectedWebPromptIndex = self.webOptionsSegmentedControl.selectedSegmentIndex;
            [self updateUIForSettings];
            break;
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //last selected prompt
    if(alertView.tag == [ThirdPartyAppFeatures chromeInstallAlertViewTag]){
        [self.webOptionsSegmentedControl setSelectedSegmentIndex:self.currentSelectedWebPromptIndex];
        if(buttonIndex != 0){
            [[UIApplication sharedApplication] openURL:[ThirdPartyAppFeatures chromeInstallURL]];
        }
    }else if(alertView.tag == 0){
        if(buttonIndex == 1){
            [self back];
        }else if(buttonIndex == 2){
            [self saveFromCurrentSettings];
            [self back];
        }
    }
}

//Nav
- (IBAction)backButtonPressed:(id)sender
{
    if([self.saveBtn isEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Your current settings are unsaved." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Discard", @"Save", nil];
        alert.tag = 0;
        [alert show];
    }else{
        [self back];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    [self saveFromCurrentSettings];
    //SAVE and go back
    [self back];
}

-(void)saveFromCurrentSettings
{
    [ThinkBack setShouldContextScan:self.selectedContextDetect];
    [ThinkBack setWebPrompt:self.selectedWebPrompt];
}

-(void)back
{
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

@end
