//
//  ThinkBackIdeaDataObject.h
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ThinkBackIdeaDataObject : NSManagedObject
    @property (nonatomic, strong) NSString *text;
    @property (nonatomic, strong) NSDate *remindAt;
@end
