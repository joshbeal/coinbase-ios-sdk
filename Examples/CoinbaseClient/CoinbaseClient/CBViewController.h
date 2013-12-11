//
//  CBViewController.h
//  CoinbaseClient
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 CoinbaseClient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property UITableView *tableView;
@end
