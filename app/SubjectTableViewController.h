//
//  SubjectTableViewController.h
//  app
//
//  Created by Jesse Hu on 10/18/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTableViewController.h"

@interface SubjectTableViewController : UITableViewController

@property (strong, nonatomic) id <CourseTableViewControllerDelegate> delegate;

@end
