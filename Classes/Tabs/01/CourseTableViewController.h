//
//  CourseTableViewController.h
//  app
//
//  Created by Jesse Hu on 10/18/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseTableViewControllerDelegate <NSObject>

- (void)courseSelected:(NSDictionary *)course;

@end

@interface CourseTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSDictionary *subjectDictionary;
@property (strong, nonatomic) id <CourseTableViewControllerDelegate> delegate;

@end
