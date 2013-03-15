#import "LeftPanelController.h"
#import "List.h"
#import "Storage.h"

@interface LeftPanelController ()

@end

@implementation LeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    if (![self.fetchResultsController performFetch:&error]) {
        NSLog(@"Error fetching core data inside leftPanelController");
        exit(-1);
    }
}

- (void)viewDidUnload {
    self.fetchResultsController = nil;
}

- (NSFetchedResultsController *)fetchResultsController {
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]];
    [fetchRequest setSortDescriptors:@[sort]];
    [fetchRequest setEntity:entity];

    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[Storage sharedStorage] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchResultsController.delegate = self;
    return _fetchResultsController;
}

- (id)init {
    self = [super init];
    self.view.frame = CGRectMake(0, 0, 360, 480);
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    return self;
}

- (void)newList {
    List *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]];
    newList.name = @"New list";
    NSError *error;
    [[[Storage sharedStorage] managedObjectContext] save:&error];
    NSLog(@"%@", newList);
}


#pragma mark TableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Create a new list";
        return cell;
    }

    List *list = [[self.fetchResultsController fetchedObjects] objectAtIndex:indexPath.row];
    cell.textLabel.text = list.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    return @"Lists";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [[self.fetchResultsController fetchedObjects] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark NSFetchedResults Delegate 

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
 
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeMove:
           [tableView deleteRowsAtIndexPaths:[NSArray
arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           [tableView insertRowsAtIndexPaths:[NSArray
arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
           break;
    }
}
 
 
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 
    switch(type) {
 
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


@end
