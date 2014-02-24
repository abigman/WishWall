//
//  JKViewController.h
//  NetworkDome
//
//  Created by Johnny on 14-2-17.
//  Copyright (c) 2014年 JK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *context;
@property (weak, nonatomic) IBOutlet UITextField *queryString;

- (IBAction)connectToServer:(id)sender;

@end
