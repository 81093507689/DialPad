//
//  dialpadViewController.m
//  sendSMS
//
//  Created by Nishant on 17/07/17.
//  Copyright © 2017 Chandni. All rights reserved.
//

#import "dialpadViewController.h"

@interface dialpadViewController ()

@end

@implementation dialpadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *ary_temp = [[NSArray alloc]initWithObjects:self.btn0,self.btn1,self.btn2,self.btn3,self.btn4,self.btn5,self.btn6,self.btn7,self.btn8,self.btn9,self.btn_star,self.btn_plus, nil];
    [self btn_circule:ary_temp];
    [self fn_player_setup];
    
       // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fn_player_setup
{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSLog(@"Resource path for test.applescript: %@", [bundle pathForResource:@"tap" ofType:@"aif"]);
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"tap"
                                         ofType:@"aif"]];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
    }
}
-(void)btn_circule:(NSArray *)getArray
{
    for (int i = 0; i < getArray.count; i ++) {
        UIButton *btn = [getArray objectAtIndex:i];
        btn.layer.cornerRadius = 50/2;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.layer.borderWidth = 0.2;
        
    }
   
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.btn_del addGestureRecognizer:longPress];
    
    
    
}


- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"-------------  down");
        isStop = true;
       theTimer = [NSTimer scheduledTimerWithTimeInterval:0.09
                                         target:self
                                       selector:@selector(timerMethod)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    // as you release the button this would fire
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"-------------  up");
        isStop = false;
    }
}
-(void)timerMethod
{
  if(isStop == true)
  {
      if(_txt_field.text.length > 0)
      {
      NSString *newString = [_txt_field.text substringToIndex:[_txt_field.text length]-1];
      _txt_field.text = newString;
     // NSLog(@"-------------");
      }

  }else
  {
      [theTimer invalidate];
      theTimer = nil;
  }
}

-(IBAction)click_number:(id)sender
{
    //NSInteger *getTag = [sender tag];
   
   if([sender tag] == 10)
   {
       _txt_field.text = [NSString stringWithFormat:@"%@*",_txt_field.text];
   }else if ([sender tag] == 11)
   {
     _txt_field.text = [NSString stringWithFormat:@"%@+",_txt_field.text];
   }else
   {
      _txt_field.text = [NSString stringWithFormat:@"%@%ld",_txt_field.text,(long)[sender tag]];
   }
    [_audioPlayer play];
}
-(IBAction)click_del:(id)sender
{
    if(_txt_field.text.length > 0)
    {
       NSString *newString = [_txt_field.text substringToIndex:[_txt_field.text length]-1];
        _txt_field.text = newString;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)click_call:(id)sender
{
    if(_txt_field.text.length > 0)
    {
    UIApplication *application = [UIApplication sharedApplication];
    NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",self.txt_field.text];
    
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
                                            pasteboard.string = self.txt_field.text;
                                        }];
            
            
            [alert addAction:yesButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    }
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
    
}
@end
