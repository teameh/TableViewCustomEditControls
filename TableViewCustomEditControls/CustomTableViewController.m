//
//  CustomTableViewController.m
//  TableViewCustomEditControls
//
//  Created by Tieme van Veen on 1/4/13.
//  Copyright (c) 2013 Tieme van Veen. All rights reserved.
//

#import "CustomTableViewController.h"
#import "CustomCell.h"

@implementation CustomTableViewController

@synthesize cellData;

#pragma mark - Lifecyle
//- (id)initWithStyle:(UITableViewStyle)style is not used here beause we're loading from storyboard
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        cellData = [NSMutableArray arrayWithObjects:@"Cell 0", @"Cell 1", @"Cell 2", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    // Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//add "add" cell while in editing mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:animated];
    
    //path for row at the end of the section
    NSIndexPath *path = [NSIndexPath indexPathForRow:[[self cellData] count] inSection:0];
    NSMutableArray *rows = [NSMutableArray arrayWithObject:path];
    
    //insert or delete?
    if(editing){
        [[self tableView] insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [[self tableView] deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - Table view standard data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //one more cell if we're editing
    if([tableView isEditing] == YES){
        return [[self cellData] count] + 1;
    }else{
        return [[self cellData] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get a new custom cell
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if([tableView isEditing] && indexPath.row == [[self cellData] count]){
        //"add" cell
        [[cell controlButton] setImage:[UIImage imageNamed:@"add"]];
        [[cell textLabel] setText:@"Add a new cell!"];
    }else{
        //normal cell
        [[cell controlButton] setImage:[UIImage imageNamed:@"remove"]];
        [[cell textLabel] setText:[[self cellData] objectAtIndex:[indexPath row]]];
    }
    return cell;
}

#pragma mark - TableView Delete or Insert
//Which control should we display, "add" or "delete"
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //if editing...
    if([tableView isEditing] == YES){
        if(indexPath.row == [[self cellData] count]){
            //show "add" control
            return UITableViewCellEditingStyleInsert;
        }else{
            //show delete control
            return UITableViewCellEditingStyleDelete;
        }
    }else{
        return UITableViewCellAccessoryNone;
    }
}

//Delete or Add button is pressed
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //delete the row from the data source
        [[self cellData] removeObjectAtIndex:indexPath.row];
        
        //and from the table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
        
        //add to datasource
        [[self cellData] addObject:[@"Cell " stringByAppendingFormat:@"%d", indexPath.row]];
        
        //add to table with a animation form the right
        NSIndexPath *path = [NSIndexPath indexPathForRow:[[self cellData] count] - 1  inSection:0];
        NSMutableArray *rows = [NSMutableArray arrayWithObject:path];
        [[self tableView] insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - TableView Rearranging
// Is it possible to move this row or is it stuck at its position?
- (BOOL)tableView:(UITableView *)theTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't move the last row
    if (indexPath.row != [[self cellData] count]){
        return YES;
    }else{
        return NO;
    }
}

// Can we move this row from position 'sourceIndexPath' to position 'proposedDestinationIndexPath' ?
- (NSIndexPath *)tableView:(UITableView *)theTableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    //If position is "add cell position"
    if(proposedDestinationIndexPath.row >= [[self cellData] count]){
        //Place as second last item
        return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:proposedDestinationIndexPath.section];
    }else{
        return proposedDestinationIndexPath;
    }
}

//row is moved
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //Cell put back on the same place?
    if(fromIndexPath.section == toIndexPath.section && fromIndexPath.row == toIndexPath.row){
        return;
    }else{
        //get the moving item an thus retain it!
        id movingItem = [[self cellData] objectAtIndex:[fromIndexPath row]];
        
        //insert from and delete from dataSource
        [[self cellData] removeObjectAtIndex:fromIndexPath.row];
        [[self cellData] insertObject:movingItem atIndex:toIndexPath.row];        
    }
}

@end
