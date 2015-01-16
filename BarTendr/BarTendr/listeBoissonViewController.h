//
//  listeBoissonViewController.h
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listeBoissonViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *labelTitre;

@property (weak, nonatomic) IBOutlet UILabel *LabelLB;

@property (strong, nonatomic) IBOutlet UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray *data2;

@property (weak, nonatomic) NSString *boissonType;

@property (weak, nonatomic) IBOutlet UILabel *labelTable;


@end
