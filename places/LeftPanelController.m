#import "LeftPanelController.h"
#import "List.h"
#import "Storage.h"

@interface LeftPanelController ()

@end

@implementation LeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    // handle error case!
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

- (id)init {
    self = [super init];
    self.view.frame = CGRectMake(0, 0, 360, 480);
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 255, 480)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    headerView.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(5, 5, 100, 40);
    [button setTitle:@"Create new list" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newList) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headerView;

    return self;
}

- (void)newList {
    List *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]];
    newList.name = @"New list";
    NSError *error;
    [[[Storage sharedStorage] managedObjectContext] save:&error];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self newList];
    }
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

@end
