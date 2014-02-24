//
//  JKTableViewController.m
//  NetworkDome
//
//  Created by Johnny on 14-2-17.
//  Copyright (c) 2014年 JK. All rights reserved.
//

#import "JKTableViewController.h"
#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface JKTableViewController ()

@end

@implementation JKTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //左右两侧添加按钮
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = update;
    
    UIBarButtonItem *sendWish = [[UIBarButtonItem alloc]initWithTitle:@"＋" style:UIBarButtonItemStyleBordered target:self action:@selector(sendWish)];
    self.navigationItem.leftBarButtonItem = sendWish;
    
    //实现下拉刷新
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    //如果文件存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathForCache]]) {
        _washCache = [NSMutableArray arrayWithContentsOfFile:[self pathForCache]];
    }else{
        [self refresh];//否则服务器加载
        NSLog(@"服务器加载");
    }
}

- (NSString *) pathForCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths[0];
    return [document stringByAppendingPathComponent:@"cache.plist"];
}


#pragma mark Send
- (void) sendWish
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SendView" bundle:nil];
    
    [self presentViewController:[sb instantiateInitialViewController] animated:YES completion:^{
    }];
}


- (void) refresh
{
    UIApplication *app = [UIApplication sharedApplication];
    
    static NSString *urlString = @"http://192.168.0.103:8080/iPhoneNetworkServer/Main/";
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    app.networkActivityIndicatorVisible = YES;
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在努力加载中..."];
    
    [_wait startAnimating];
    
    [requestManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        app.networkActivityIndicatorVisible = NO;
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [self.refreshControl endRefreshing];
        [_wait stopAnimating];
        
        _allWash = responseObject;
        [self.tableView reloadData];
        
        //另外开启线程，后台缓存数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _washCache = [NSMutableArray arrayWithArray:_allWash];
            [_washCache writeToFile:[self pathForCache] atomically:YES];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        app.networkActivityIndicatorVisible = NO;
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [self.refreshControl endRefreshing];
        [_wait stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果服务器加载成功，使用最新数据，否则使用缓存数据
    if (!_allWash) {
        return _washCache.count;
    }
    return _allWash.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    UILabel *lblSubmiter = (UILabel *)[cell viewWithTag:1];
    UITextView *content = (UITextView *)[cell viewWithTag:2];
    
    if (!_allWash) {
        lblSubmiter.text = [NSString stringWithFormat:@"发布者: %@",[_washCache[indexPath.row] objectForKey:@"name"]];
        content.text = [_washCache[indexPath.row] objectForKey:@"content"];
    }else{
        lblSubmiter.text = [NSString stringWithFormat:@"发布者: %@",[_allWash[indexPath.row] objectForKey:@"name"]];
        content.text = [_allWash[indexPath.row] objectForKey:@"content"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
