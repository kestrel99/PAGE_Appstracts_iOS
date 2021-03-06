//
//  ViewSearch.m
//  Page Appstracts
//
//  Created by Hendrik Schoemaker on 19/02/2013.
//  Copyright (c) 2013 Hendrik Schoemaker. All rights reserved.
//

#import "ViewSearch.h"

@interface ViewSearch ()

@end

@implementation ViewSearch

@synthesize tableView, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)handleSearchForTerm:(NSString *)searchTerm {
	
	//viewType = searchTerm;

	NSString* fileToSaveTo = @"PageAbstracts";
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path objectAtIndex:0];
    NSString *databasePath = [NSString stringWithFormat:@"%@/%@.sqlite",documentsDirectory,fileToSaveTo];
    
	const char *dbpath = [databasePath UTF8String];
	
	sqlite3_stmt *statement;
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	if (![searchTerm isEqualToString:@""] && sqlite3_open(dbpath, &abstractsDB) == SQLITE_OK) {
		
		NSString *querySQL = [NSString stringWithFormat: @"SELECT number, title, firstname, lastname, eTime, _id, content FROM Abstracts WHERE (title || ' ' || content  || ' ' || author  || ' ' || firstname || ' ' || type)  LIKE '%%%@%%' ORDER BY number", searchTerm];
		const char *query_stmt = [querySQL UTF8String];
		
        //const char* sqlStatement = "SELECT COUNT(*) FROM Abstracts";
        //        sqlite3_stmt *statement;
        //
        //      if( sqlite3_prepare_v2(abstractsDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        //       {
        //          //Loop through all the returned rows (should be just one)
        //          while( sqlite3_step(statement) == SQLITE_ROW )
        //          {
        //              NSInteger count = sqlite3_column_int(statement, 0);
        //              NSLog(@"Rowcount is %d",count);
        //          }
        //      }
        //      else
        //      {
        //          NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(abstractsDB) );
        //      }

                // Finalize and close database.
        // sqlite3_finalize(statement);
                //sqlite3_close(articlesDB);
            
		if (sqlite3_prepare_v2(abstractsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSString *code = @"";
                if (sqlite3_column_text(statement,0))
                    code = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
				
                NSString *abstractTitle = @"";
                if (sqlite3_column_text(statement,1))
                    abstractTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)];
                
				NSString *firstName = @"";
				if (sqlite3_column_text(statement,2))
					firstName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)];
                
                NSString *lastName = @"";
                if (sqlite3_column_text(statement,3))
                    lastName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,3)];
                //NSLog(lastName);
				
				NSString *eTime = @"";
                if (sqlite3_column_text(statement,4))
                    eTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,4)];
				
                NSNumber *abstractID = 0;
                if (sqlite3_column_text(statement,5))
                    abstractID = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,5)];
                
                NSString *content = @"";
                if (sqlite3_column_text(statement,6))
                    content = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,6)];
                
				NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
				
				//NSString *text = [NSString stringWithFormat:@"%@ %@", code, abstractTitle];
				
				NSArray *array2 = [[NSArray alloc] initWithObjects:code,abstractTitle,name,eTime, abstractID, content, nil];
				
				[array addObject:array2];
				
            }
			sqlite3_finalize(statement);
		}
		sqlite3_close(abstractsDB);
	}
	
	listData=array;
		
	[[self tableView] reloadData];
}

#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	NSString *searchTerm = [searchBar text];
	[self handleSearchForTerm:searchTerm];
	[searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
	searchBar.text = @"";
    [self handleSearchForTerm:@""];
	[searchBar resignFirstResponder];
}

-(void) searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
	NSString *searchTerm = [searchBar text];
	[self handleSearchForTerm:searchTerm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return[listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AbstractCell";
    AbstractCell *cell = [[AbstractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSUInteger row = [indexPath row];
	
    cell.code.text = [[listData objectAtIndex:row] objectAtIndex:0];
	cell.summary.text = [[listData objectAtIndex:row] objectAtIndex:1];
	cell.author.text = [[listData objectAtIndex:row] objectAtIndex:2];
	cell.date.text = [[listData objectAtIndex:row] objectAtIndex:3];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    NSString *text = [[listData objectAtIndex:row] objectAtIndex:1];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"helvetica" size:12]
                       constrainedToSize:CGSizeMake(self.view.frame.size.width - 80, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    return MAX(80, textSize.height+40);
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[[listData objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:[NSString stringWithFormat:@""]]) {
        
		self.title = nil;
        
		ViewAbstract *childController;
        if (childController == nil)
        {
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            childController = (ViewAbstract*)[sb instantiateViewControllerWithIdentifier:@"viewAbstract"];
        }
        
		childController.abstractID = [[listData objectAtIndex:indexPath.row] objectAtIndex:4];
		[self.navigationController pushViewController:childController animated:YES];
		
	}
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
