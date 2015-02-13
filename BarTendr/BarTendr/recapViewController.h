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


// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
