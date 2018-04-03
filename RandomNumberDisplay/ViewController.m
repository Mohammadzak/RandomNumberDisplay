//
//  ViewController.m
//  RandomNumberDisplay
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 sampleTest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *randomnumArr;
    NSString *strdate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    randomnumArr  = [[NSMutableArray alloc] init];

    NSURL* url = [[NSURL alloc] initWithString:@"http://ios-test.us-east-1.elasticbeanstalk.com/"];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    
    
    self.socket = [self.manager socketForNamespace:@"/random"];
    NSLog(@"socket log is as : %@",self.socket);


    [self.socket on:@"capture" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
         NSLog(@"socket data is %@",data);
        NSLog(@"On message listening hearing from server  %@", data);
        NSLog(@"On mesage ack is %@", ack);
        [self eventhandler:data];
    }];
    

    
    [self.socket connect];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)eventhandler:(NSArray *)data
{
    NSLog(@"event data %@",data);
    NSLog(@"last object %@",[randomnumArr lastObject]);
    NSLog(@"data at object at index %@",[data objectAtIndex:0]);
    if ([randomnumArr lastObject] == [data objectAtIndex:0]) {
        NSLog( @"local notification will be set for mobile");
      //  [self setLocalNotification];
    }
    else
    {
        
    }
    
    if ([[NSString stringWithFormat:@"%@",[randomnumArr lastObject]] isEqualToString:[NSString stringWithFormat:@"%@",[data objectAtIndex:0]]]) {
        NSLog(@"local notification should set");
        [self setLocalNotification];
    }
    
    self.lblRandomNumber.text = [NSString stringWithFormat:@"%@",[data objectAtIndex:0]];
    [randomnumArr addObject:[data objectAtIndex:0]];
    NSUserDefaults *localdata = [NSUserDefaults standardUserDefaults];
    [localdata setObject:randomnumArr forKey:@"data"];
    [localdata synchronize];
  //  NSLog(@"random array %@",randomnumArr);
  //  NSLog(@"data stored in local data base %@",[localdata objectForKey:@"data"]);
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    strdate = newDateString;
    [self.tableList reloadData];
  //  NSLog(@"newDateString %@", newDateString);
    
    
   
    self.lblCurrentTimeDisplay.text = [NSString stringWithFormat:@"updated Time is : %@",newDateString];
}

-(void)setLocalNotification
{
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
   // localNotification.fireDate = pickerDate;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];;
    localNotification.alertBody = @"%@ number is consecutively appear";
    localNotification.alertBody = [NSString stringWithFormat:@"%@ number is consecutively appear",[randomnumArr lastObject]];
    localNotification.alertAction = @"Show me the item";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
 
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return randomnumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    detailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.detailslabel.text = [NSString stringWithFormat:@"random number generated is %@",[randomnumArr objectAtIndex:indexPath.row]];
    //[randomnumArr objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (IBAction)touchupbtnsplinechartclk:(id)sender {
    self.tableList.hidden = true;
}

- (IBAction)touchupbtnnotificationListclk:(id)sender {
    self.tableList.hidden = false;
}
@end
