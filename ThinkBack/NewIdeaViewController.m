//
//  NewIdeaViewController.m
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import "NewIdeaViewController.h"
#import "CoreDataHelper.h"

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
    [self.temporaryIdea setText:self.ideaTextView.text];
    //save the data and back out of the window
    [CoreDataHelper saveIdea:self.temporaryIdea];
    [self backButtonPressed:nil];
}

//Nav
- (IBAction)backButtonPressed:(id)sender {
    if([self presentingViewController] != nil){
        [[self presentingViewController] dismissViewControllerAnimated:YES
                                                            completion:^(void){}];
    }else{
        [[self navigationController] popToRootViewControllerAnimated:TRUE];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self finishAndSave];
}

@end
