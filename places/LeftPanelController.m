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
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 255, 480)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(5, 5, 150, 40);
    [button setTitle:@"Create new list" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newList) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headerView;

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
    newList.name = @"New list";
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

@end
