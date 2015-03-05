//
//  SendCommandController.m
//  BarTendr
//
//  Created by Patouz on 27/02/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import "SendCommandController.h"
#import "Globals.h"
#import "Commande.h"


@interface SendCommandController ()
@property UIAlertView *alert2;
@end

@implementation SendCommandController
@synthesize numComLabel;
@synthesize totalLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * tempString;
    tempString = @"Montant à payer : ";
    tempString = [tempString stringByAppendingString:totalString];
    totalLabel.text = tempString;
    
    _alert2 = [[UIAlertView alloc] initWithTitle:@"Envoi de la commande en cours.\nVeuillez patienter..."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert2 show];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *article1;
    NSMutableArray * liste = [[NSMutableArray alloc]init];
    
    for (Article * article in commande.liste_article) {
        article1 = [[NSMutableDictionary alloc]init];
        [article1 setValue:[NSNumber numberWithInteger: article.id_boisson] forKey:@"article_id"];
        NSLog(@" MON ID %u", article.id_boisson);
        [article1 setValue:@"" forKey:@"comments"];
        [liste addObject:article1];
        
    }
    NSLog(@"ma liste :%@", liste);
    [dict setValue: @1 forKey:@"table"];
    [dict setValue:liste forKey:@"items_attributes"];
    [dict2 setValue:dict forKey:@"order"];
    
    NSError *error = nil;
    NSData *json;
    NSURL *url = [NSURL URLWithString:@"http://176.182.204.12/orders.json"];
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dict2 options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            
            NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSMutableURLRequest *requestData = [[NSMutableURLRequest alloc] init];
            
            NSString *number = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)postData.length];
            
            [requestData setURL:url];
            
            [requestData setHTTPMethod:@"POST"];
            [requestData setValue:number forHTTPHeaderField:@"Content-Length"];
            [requestData setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [requestData setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [requestData setHTTPBody:postData];
            
            NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:requestData delegate:self];
            if(conn) {
                NSLog(@"Connection Successful");
            } else {
                NSLog(@"Connection could not be made");
            }
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Erreur ===>  %@  <====== Fin Erreur", error);
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response{
    NSLog(@"Reponse Serveur ===> %@", response);
    [_alert2 dismissWithClickedButtonIndex:0 animated:YES];

    UIAlertView * responseAlert;
    
    if ([response statusCode] == 201) {
        responseAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Commande envoyée avec succès." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    else{
        responseAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Envoi de la commande échouée." delegate:self cancelButtonTitle:@"Réessayer" otherButtonTitles: nil];
    }
    
    [responseAlert show];

}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"DATA RECEIVED : ");
    NSString *myResponseReadable = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myResponseReadable);
    
    
    
}
// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Fini de transmettre les données");
    [_alert2 dismissWithClickedButtonIndex:0 animated:YES];

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
