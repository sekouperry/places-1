#import "LeftPanelController.h"
#import "Storage.h"
#import "CenterPanelController.h"
#import <JASidePanelController.h>
#import <UIViewController+JASidePanel.h>

@interface LeftPanelController ()

@end


@implementation LeftPanelController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    // handle error case!
}

- (void)viewDidAppear:(BOOL)animated {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.5;
    longPress.delegate = self;
    [self.tableView addGestureRecognizer:longPress];
}

- (id)init {
    self = [super init];
    self.view.frame = CGRectMake(0, 0, 360, 480);
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:50/255.0 blue:60/255.0 alpha:1.0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 255, 480)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];

    return self;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"List" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]]];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sort]];

   _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[Storage sharedStorage] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];

    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)newList {
    List *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yy"];
    newList.name = [NSString stringWithFormat:@"%@ %@", @"List", [formatter stringFromDate:date]];
    NSError *error;
    [[[Storage sharedStorage] managedObjectContext] save:&error];
    [self.tableView reloadData];
}

- (void)handleLongPress:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
        [self.tableView  deselectRowAtIndexPath:indexpath animated:YES];
        self.editingCellIndex = indexpath;
        if (indexpath != nil) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.editingCellIndex];

            self.editingCellTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
            self.editingCellTextField.delegate = self;
            self.editingCellTextField.backgroundColor = [UIColor whiteColor];
            self.editingCellTextField.font = [UIFont boldSystemFontOfSize:20];
            self.editingCellTextField.text = cell.textLabel.text;
            [cell addSubview:self.editingCellTextField];
            [self.editingCellTextField becomeFirstResponder];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.editingCellIndex];
    cell.textLabel.text = textField.text;
    List *list = [self.fetchedResultsController objectAtIndexPath:self.editingCellIndex];
    list.name = textField.text;
    NSError *error;
    [[[Storage sharedStorage] managedObjectContext] save:&error];
    [textField resignFirstResponder];
    [self.editingCellTextField removeFromSuperview];
    return YES;
}

#pragma mark FetchedResultsController Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark TableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = list.name;
    cell.textLabel.textColor = [UIColor whiteColor];

    UIImage *background = [UIImage imageNamed:@"leftPanelCellBg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.image = background;
    cell.backgroundView = imageView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Lists";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[[Storage sharedStorage] managedObjectContext] deleteObject:list];
        NSError *error;
        [[[Storage sharedStorage] managedObjectContext] save:&error];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *selectedListUri = [[[self.fetchedResultsController objectAtIndexPath:indexPath] objectID] URIRepresentation];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setURL:selectedListUri forKey:kSelectedList];
    [defaults synchronize];
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.delegate setActiveList:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    sectionHeader.backgroundColor = [UIColor clearColor];

    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(sectionHeader.frame)/2 - 10, CGRectGetWidth(tableView.frame), 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.text = sectionTitle;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetWidth(label.frame)-35, 5, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"addList"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"addListPressed"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(newList) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:sectionHeader.frame];
    UIImage *image = [UIImage imageNamed:@"LeftCellHeader"];
    imageView.image = image;
    [sectionHeader addSubview:imageView];
    [sectionHeader addSubview:label];
    [sectionHeader addSubview:button];

    return sectionHeader;
}

@end
