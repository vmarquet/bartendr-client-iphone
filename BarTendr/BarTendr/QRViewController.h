//
//  QRViewController.h
//  BarTendr
//
//  Created by Patouz on 21/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource>

/*
 @property (weak, nonatomic) IBOutlet UILabel *message_QR;
 @property (weak, nonatomic) IBOutlet UILabel *message_json;
 */

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
- (IBAction)startStopReading:(id)sender;

@end
