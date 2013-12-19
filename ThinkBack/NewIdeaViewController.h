//
//  NewIdeaViewController.h
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThinkBackIdeaDataObject.h"

@interface NewIdeaViewController : UIViewController
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
    @property (weak, nonatomic) IBOutlet UITextView *ideaTextView;
    @property (weak, nonatomic) IBOutlet UILabel *ideaRemindAtTextView;

    @property (nonatomic, strong) ThinkBackIdeaDataObject *temporaryIdea;
@end
