//
//  recapViewController.m
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "recapViewController.h"
#import "Globals.h"

@interface recapViewController ()

@end

@implementation recapViewController
@synthesize data3;
@synthesize labelTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelTable.text = numberTable;
    
    // TableView
    data3 = [[NSMutableArray alloc]initWithObjects: @"Grimbergen x1", @"Leffe Blonde x1", @"Kilkenny x1", @"Guiness x2", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section3 {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView3 numberOfRowsInSection:(NSInteger)section3 {
    return [data3 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView3 cellForRowAtIndexPath:(NSIndexPath *)indexPath3 {
    
    static NSString *CellIdentifier3 = @"Cell3";
    UITableViewCell *cell3 = [tableView3 dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath3];
    
    if(cell3 == nil){
        cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
    }
    
    cell3.textLabel.text = [data3 objectAtIndex:indexPath3.row];
    return cell3;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
