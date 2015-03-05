//
//  SubjectTableViewController.m
//  app
//
//  Created by Jesse Hu on 10/18/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "SubjectTableViewController.h"
#import "CourseTableViewController.h"

@interface SubjectTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *subjects;
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSDictionary *subjectDictionary;

@end

@implementation SubjectTableViewController

- (void)viewDidLoad {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"courses_final" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    self.subjects = [json valueForKey:@"subjects"];
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"subjectToCourseSegue"]) {
        CourseTableViewController *courseVC = segue.destinationViewController;
        courseVC.courses = [self.courses copy];
        courseVC.subjectDictionary = self.subjectDictionary;
        courseVC.delegate = self.delegate;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *subjectDictionary = [self.subjects objectAtIndex:[indexPath row]];
    NSString *subjectCode = [subjectDictionary objectForKey:@"code"];
    NSString *subjectDesc = [subjectDictionary objectForKey:@"desc"];
    
    cell.textLabel.text = subjectCode;
    cell.detailTextLabel.text = subjectDesc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subjectDictionary = [self.subjects objectAtIndex:[indexPath row]];
    NSArray *courses = [subjectDictionary objectForKey:@"courses"];
    self.courses = courses;
    self.subjectDictionary = subjectDictionary;
    
    [self performSegueWithIdentifier:@"subjectToCourseSegue" sender:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
