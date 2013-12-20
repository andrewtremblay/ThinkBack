//
//  NewIdeaViewController.m
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import "NewIdeaViewController.h"
#import "ThinkBack.h"
#import "NSDate+ThinkBack.h"
#import "NSString+TrimLeadingWhitespace.h"

NSInteger kBackOutTag = 0;
NSInteger kSetDateTag = 1;

@interface NewIdeaViewController ()

@end

@implementation NewIdeaViewController


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
	// Do any additional setup after loading the view.
    self.temporaryIdea = [ThinkBack createIdea];

    
    [self.remindAtWrapperView setAlpha:0.0f];
    [self.ideaRemindAtBtn setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self updateUiForData];
    [self.ideaTextView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUiForData
{
    [self.ideaTextView setText:self.temporaryIdea.text];
    NSString *remindAtCheck = [ThinkBack formattedRemindAtTimeForIdea:self.temporaryIdea];
    if([remindAtCheck length] > 0){
        NSString *formattedDateTime = [NSString stringWithFormat:@"@ %@", remindAtCheck];
        [self.ideaRemindAtBtn setTitle:formattedDateTime forState:UIControlStateNormal];
        [self.ideaRemindAtBtn setEnabled:YES];
        [self.ideaRemindAtBtn setHidden:NO];
    }else {
        //we are unset, don't show anything
        [self.ideaRemindAtBtn setTitle:@" " forState:UIControlStateNormal];
        [self.ideaRemindAtBtn setHidden:YES];
        [self.ideaRemindAtBtn setEnabled:NO];
    }
}

-(void)finishAndSave
{
    if(self.temporaryIdea != nil){
        [self.temporaryIdea setText:self.ideaTextView.text];
//    [self.temporaryIdea setRemindAt:[NSDate date]];
        //save the data and back out of the window
        [ThinkBack saveIdea:self.temporaryIdea];
    }

    //navigate away
    if([self presentingViewController] != nil){
        [[self presentingViewController] dismissViewControllerAnimated:YES
                                                            completion:^(void){}];
    }else{
        [[self navigationController] popToRootViewControllerAnimated:TRUE];
    }
}

//Nav
- (IBAction)backButtonPressed:(id)sender {
    self.ideaTextView.text = [self.ideaTextView.text stringByTrimmingLeadingWhitespace];
    if(self.ideaTextView.text.length > 0){
        [self promptErrorModal: @"Something was entered." withConfirmText:@"Discard Idea" andAlertTag:kBackOutTag];
    }else{
        [ThinkBack deleteIdea:self.temporaryIdea];
        self.temporaryIdea = nil;
        [self finishAndSave];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    self.ideaTextView.text = [self.ideaTextView.text stringByTrimmingLeadingWhitespace];
    if(self.ideaTextView.text == nil || self.ideaTextView.text.length == 0){
        [self promptErrorModal:@"Nothing was entered." withConfirmText:@"Set Date" andAlertTag:kSetDateTag];
    }else{
        [self promptDateSelection];
    }
}

-(void)promptErrorModal:(NSString *)alertMsg withConfirmText:confirmText andAlertTag:(NSInteger) tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue?"
                                                    message:alertMsg
                                                   delegate:self
                                          cancelButtonTitle:@"Edit Idea"
                                          otherButtonTitles:confirmText, nil];
    [alert setTag:tag];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else{
        if(alertView.tag == kBackOutTag){
            [ThinkBack deleteIdea:self.temporaryIdea];
            self.temporaryIdea = nil;
            [self finishAndSave];
        }if (alertView.tag == kSetDateTag) {
            [self promptDateSelection];
        }
    }
}

-(void)promptDateSelection
{
    [self.ideaTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.remindAtWrapperView setAlpha:1.0f];
                         [self.ideaRemindAtBtn setBackgroundColor:self.remindAtWrapperView.backgroundColor];
                     }
                     completion:^(BOOL finished){
                         //set view interaction enabled
                         [self.ideaRemindAtBtn setEnabled:NO];
                     }];
}


- (IBAction)setRemindDateOptionPressed:(id)sender {
    if(sender == self.remindAtOptionExactTime){
        //prompt date picker
        
        
    }else if(sender == self.remindAtOptionFuzzyTime){
        //find a random time in the future, set that as the reminder option
        [self.temporaryIdea setRemindAt:[NSDate randomTimeFromSettings]];
        [ThinkBack setRemindType:(ThinkBackRemindTypeTimeFuzzy) forIdea:self.temporaryIdea];
        
    }else if(sender == self.remindAtOptionFuzzyTime){
        [self.temporaryIdea setRemindAt:[NSDate never]];
        [ThinkBack setRemindType:(ThinkBackRemindTypeTimeNever) forIdea:self.temporaryIdea];
        
    }
    
}

- (IBAction)ideaRemindAtBtnPressed:(id)sender {
    [self promptDateSelection];
}
@end
