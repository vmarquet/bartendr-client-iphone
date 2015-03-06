//
//  QRViewController.m
//  BarTendr
//
//  Created by Patouz on 21/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "QRViewController.h"
#import "boissonViewController.h"
#import "Globals.h"

@import AVFoundation;

@interface QRViewController ()
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    commande = [[Commande alloc] init];
    commande.liste_article = [[NSMutableArray alloc] initWithObjects:nil];
    
    _isReading = YES;
    
    _captureSession = nil;

    [self startReading];
    
}

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
        }
    }
    else{
        [self stopReading];
    }
    
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
   int penis;
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
           // NSLog(@"%@", [metadataObj stringValue]);
            numberTable = [metadataObj stringValue];

            NSData *jsonData = [numberTable dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
            NSLog(@"JSON TABLE \n%@", dict);
            if ([dict isKindOfClass:[NSArray class]]){
                //Parcours du Json
                   penis = [[dict objectForKey:@"table"]integerValue];
                
            }
            NSLog(@"    %d    ", penis);
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

-(void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    
    [self performSegueWithIdentifier:@"numberTable" sender:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"numberTable"]){
         [segue destinationViewController];
     }
 }
 

@end