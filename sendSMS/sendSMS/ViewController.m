//
//  ViewController.m
//  sendSMS
//
//  Created by Nishant on 15/05/17.
//  Copyright © 2017 Chandni. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.lay_label.constant = 50;
    //self.lay_button.constant = 300;
     self.lay_callbutton.constant = 200;
    [UIView animateWithDuration:1.25 animations:^{
       
        [self.view layoutIfNeeded];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)click_sendSMS:(id)sender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"*134*806983463486#";
        controller.recipients = [NSArray arrayWithObjects:@"*134*806983463486#", nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(IBAction)click_call:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",self.text.text];
    
    NSString *escaped = [phoneStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [application openURL:[NSURL URLWithString:escaped] options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }else
        {
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"ERROR" message:@"Dial pad is unable to open , go to dial pad and paste number"preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                            pasteboard.string = self.text.text;
                                        }];
           
            
            [alert addAction:yesButton];
           
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
    
}

@end
