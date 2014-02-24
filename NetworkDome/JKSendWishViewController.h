//
//  JKSendWishViewController.h
//  NetworkDome
//
//  Created by Johnny on 14-2-19.
//  Copyright (c) 2014年 JK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKSendWishViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextView *sendView;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
