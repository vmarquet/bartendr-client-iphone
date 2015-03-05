//
//  SendCommandController.h
//  BarTendr
//
//  Created by Patouz on 27/02/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCommandController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *gros_text;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UILabel *paiement;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *numComLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

// This method receives the response from the server
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

// This method receives the data the server can send to us
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
