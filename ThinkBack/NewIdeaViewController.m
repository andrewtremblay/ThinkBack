//
//  NewIdeaViewController.m
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import "NewIdeaViewController.h"
#import "CoreDataHelper.h"

NSString *kBackButtonMessage    = @"Something was entered.";
NSString *kSetDateButtonMessage = @"Nothing was entered.";

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
    self.temporaryIdea = [CoreDataHelper createIdea];
    
    
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
    
//    NSString *formattedDateTime = [self.temporaryIdea formattedRemindAtTime];
    NSString *formattedDateTime = [NSString stringWithFormat:@"@ %@", [CoreDataHelper formattedRemindAtTimeForIdea:self.temporaryIdea]];
    [self.ideaRemindAtTextView setText:formattedDateTime];
}

-(void)finishAndSave
{
    if(self.temporaryIdea != nil){
        [self.temporaryIdea setText:self.ideaTextView.text];
//    [self.temporaryIdea setRemindAt:[NSDate date]];
        //save the data and back out of the window
        [CoreDataHelper saveIdea:self.temporaryIdea];
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
    if(self.ideaTextView.text.length > 0){
        [self promptErrorModal:kBackButtonMessage withConfirmText:@"Discard Idea"];
    }else{
        [CoreDataHelper deleteIdea:self.temporaryIdea];
        self.temporaryIdea = nil;
        [self finishAndSave];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    if(self.ideaTextView.text == nil || self.ideaTextView.text.length == 0){
        [self promptErrorModal:kSetDateButtonMessage withConfirmText:@"Set Date"];
    }else{
        [self finishAndSave];
    }
}

-(void)promptErrorModal:(NSString *)alertMsg withConfirmText:confirmText {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue?"
                                                    message:alertMsg
                                                   delegate:self
                                          cancelButtonTitle:@"Edit Idea"
                                          otherButtonTitles:confirmText, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else{
        if([alertView.message isEqualToString:kBackButtonMessage]){
            [CoreDataHelper deleteIdea:self.temporaryIdea];
            self.temporaryIdea = nil;
            [self finishAndSave];
        }if ([alertView.message isEqualToString:kSetDateButtonMessage]) {
            [self promptDateSelection];
        }
    }
}

-(void)promptDateSelection
{
    [self.ideaTextView resignFirstResponder];
    
}


@end
