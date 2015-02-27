//
//  recapViewController.h
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecapCell.h"

@interface recapViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView3;

@property (strong, nonatomic) NSMutableArray *data3;

@property (weak, nonatomic) IBOutlet UILabel *labelTable;
@property (weak, nonatomic) IBOutlet UILabel *prixTotal;
@property (weak, nonatomic) IBOutlet UILabel *messagePrixTotal;


- (IBAction)modifyPressed:(id)sender;
-(void) buttonPressed2;
    

@end
