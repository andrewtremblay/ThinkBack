//
//  ThinkBackAllIdeasTableViewController.h
//  ThinkBack
//
//  Created by Andrew Tremblay on 10/16/13.
//  Copyright (c) 2013 ThinkBack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllIdeasViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property NSArray *allIdeas;

@end
