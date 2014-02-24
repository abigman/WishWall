//
//  JKTableViewController.h
//  NetworkDome
//
//  Created by Johnny on 14-2-17.
//  Copyright (c) 2014年 JK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *wait;

@property (nonatomic, strong) NSArray *allWash;

@property (nonatomic, strong) NSMutableArray *washCache;

@end
