//
//  ViewSearch.h
//  Page Appstracts
//
//  Created by Hendrik Schoemaker on 19/02/2013.
//  Copyright (c) 2013 Hendrik Schoemaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#include "AbstractCell.h"
#include "ViewAbstract.h"

@interface ViewSearch : UIViewController <UIScrollViewDelegate, UISearchBarDelegate>
{
    NSArray *listData;
    sqlite3 *abstractsDB;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;

@end
