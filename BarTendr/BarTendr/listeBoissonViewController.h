//
//  listeBoissonViewController.h
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listeBoissonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *LabelLB;

@property (strong, nonatomic) IBOutlet UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray *data2;

@end
