//
//  boissonViewController.h
//  BarTendr
//
//  Created by ESIEA on 21/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface boissonViewController : UIViewController<NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *boissonLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *data;

@end
