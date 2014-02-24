//
//  JKViewController.m
//  NetworkDome
//
//  Created by Johnny on 14-2-17.
//  Copyright (c) 2014年 JK. All rights reserved.
//

/*该类测试*/

#import "JKViewController.h"

@interface JKViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSData *_data;
}

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _context.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//[NSString stringWithFormat:@"192.168.0.103:8080/iPhoneNetworkServer/Main/?key=%@",_queryString.text];


- (IBAction)connectToServer:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.0.103:8080/iPhoneNetworkServer/Main/?key=%@",_queryString.text];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"--远程服务器已响应--");
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _data = [NSData dataWithData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonString = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",[dic[0] objectForKey:@"content"]);
}


@end
