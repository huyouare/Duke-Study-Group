//
// Jesse Hu
// Copyright (c) 2014 Related Code (Parse Chat)
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "GroupView.h"
#import "ChatView.h"

#import "SubjectTableViewController.h"
#import "CourseTableViewController.h"

@interface GroupView() <CourseTableViewControllerDelegate>
{
	NSMutableArray *chatrooms;
    NSMutableArray *courses;
}
@end

@implementation GroupView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.tabBarItem.title = nil;
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_group"]];
		[self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_group"]];
		self.tabBarItem.title = @"Group";
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Group";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self
																			 action:@selector(actionNew)];
	self.tableView.separatorInset = UIEdgeInsetsZero;

	chatrooms = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([PFUser currentUser] == nil) LoginUser(self);
    
	[self refreshTable];
}

#pragma mark - User actions

- (void)actionNew
{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a name for your group" message:nil delegate:self
//										  cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//	[alert show];
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubjectTableViewController *subjectVC = [myStoryboard instantiateViewControllerWithIdentifier:@"SubjectTableViewController"];
    subjectVC.delegate = self;
    
    [self.navigationController pushViewController:subjectVC animated:YES];
}

/*
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		UITextField *textField = [alertView textFieldAtIndex:0];
		if ([textField.text isEqualToString:@""] == NO)
		{
			PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
			object[PF_CHATROOMS_NAME] = textField.text;
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
			{
				if (error == nil)
				{
					[self refreshTable];
				}
				else [ProgressHUD showError:@"Network error."];
			}];
		}
	}
}
 */

- (void)refreshTable
{
	[ProgressHUD show:nil];
//	PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
//	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//	{
//		if (error == nil)
//		{
//			[chatrooms removeAllObjects];
//			for (PFObject *object in objects)
//			{
//				[chatrooms addObject:object];
//			}
//			[ProgressHUD dismiss];
//			[self.tableView reloadData];
//		}
//		else [ProgressHUD showError:@"Network error."];
//	}];
    
    if ([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
        [query whereKey:PF_USER_OBJECTID equalTo:[[PFUser currentUser] objectId]];
        [query includeKey:PF_USER_CHATROOMS];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error == nil) {
                if (object == nil) {
                    [ProgressHUD showError:@"Network error."];
                }
                else {
                    NSLog(@"%@", object);
                    chatrooms = [object valueForKey:PF_USER_CHATROOMS];
                    NSLog(@"%@", chatrooms);
                    [ProgressHUD dismiss];
                    [self.tableView reloadData];
                }
            }
            else {
                [ProgressHUD showError:@"Network error."];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [chatrooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

	PFObject *chatroom = chatrooms[indexPath.row];
	cell.textLabel.text = chatroom[PF_CHATROOMS_NAME];

	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	PFObject *chatroom = chatrooms[indexPath.row];
	NSString *roomId = chatroom.objectId;

	CreateMessageItem([PFUser currentUser], roomId, chatroom[PF_CHATROOMS_NAME]);

	ChatView *chatView = [[ChatView alloc] initWith:roomId];
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - CourseTableViewController Delegate methods

- (void)courseSelected:(NSDictionary *)course
{
    NSLog(@"Course selected.");
    NSLog(@"%@", course);
    if (course != nil) {
        [ProgressHUD show:nil];
        NSString *chatName = [NSString stringWithFormat:@"%@ %@", [course objectForKey:@"subject_code"], [course objectForKey:@"course_number"]];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
        [query whereKey:PF_CHATROOMS_NAME equalTo:chatName];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object == nil) {
                // If chatroom not found, create chatroom & add to user
                
                object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
                object[PF_CHATROOMS_NAME] = chatName;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (error == nil)
                     {
//                         [self refreshTable];
                     }
                     else [ProgressHUD showError:@"Network error."];
                 }];
            }
            // else add chatroom to user
                
            PFUser *currentUser = [PFUser currentUser];
            NSMutableArray *currentChatrooms = [[PFUser currentUser] mutableArrayValueForKey:PF_USER_CHATROOMS];
            
            if (![currentChatrooms containsObject:object]) {
                [currentChatrooms addObject:object];
                currentUser[PF_USER_CHATROOMS] = [NSArray arrayWithArray:currentChatrooms];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error == nil) {
                        [self refreshTable];
                    }
                    else [ProgressHUD showError:@"Network error."];
                }];
            }

        }];

    }
}

@end
