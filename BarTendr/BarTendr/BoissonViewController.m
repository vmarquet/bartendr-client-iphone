//
//  boissonViewController.m
//  BarTendr
//
//  Created by ESIEA on 21/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "boissonViewController.h"

@interface boissonViewController ()

@end

@implementation boissonViewController
@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialisation de la TableView
    data = [[NSMutableArray alloc]initWithObjects:@"Bières", @"Vins Rouges", @"Vins Blancs", @"Vins Rosés", @"Cocktails", @"Alcools forts", @"Soda", @"Eau", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
    
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
