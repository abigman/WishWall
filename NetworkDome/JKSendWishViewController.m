//
//  JKSendWishViewController.m
//  NetworkDome
//
//  Created by Johnny on 14-2-19.
//  Copyright (c) 2014年 JK. All rights reserved.
//

#import "JKSendWishViewController.h"
#define kKeyboardHeight 216
#define kwordsFrameHeight 37

@interface JKSendWishViewController ()<UITextViewDelegate>

@end

@implementation JKSendWishViewController

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
    
    CGRect rect = _sendView.frame;
    rect.size.height = self.view.frame.size.height - kKeyboardHeight - kwordsFrameHeight;
    _sendView.frame = rect;
    
    [_sendView becomeFirstResponder];
    
    UILabel *placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, -7, 320, 45)];
    placeHolder.text = @"在这儿输入你的许愿内容...";
    placeHolder.textColor = [UIColor grayColor];
    placeHolder.font = _sendView.font;
    placeHolder.tag = 1;
    
    [_sendView addSubview:placeHolder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)send:(id)sender
{
    
    if ([_sendView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布内容不能为空.." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.0.103:8080/iPhoneNetworkServer/Main/index.php/Index/sendWish?wish=%@&SUName=%@",_sendView.text,@"iPhone客户端"];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (data == nil) {
        NSLog(@"%@",error);
        return;
    }
    
    NSDictionary *status = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSInteger statusValue = [[status valueForKey:@"status" ]intValue];
    
    if (statusValue != 100)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败，请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];

}


- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeHolder = (UILabel *) [textView viewWithTag:1];;
    
    if (textView.text.length != 0)
    {
        placeHolder.text = @"";
    }
    else
    {
        placeHolder.text = @"在这儿输入你的许愿内容...";
    }
}


@end
