//
//  AccountSettingViewController.m
//  RollToEver
//
//  Created by fifnel on 2012/02/08.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "AccountSettingViewController.h"

#import "Evernote.h"
#import "UserSettings.h"
#import "SettingsTableViewController.h"

@implementation AccountSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userId.delegate = self;
    password.delegate = self;
}

- (void)viewDidUnload
{
    [userId release];
    userId = nil;
    [password release];
    password = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [userId setText:[UserSettings sharedInstance].evernoteUserId];
    [password setText:[UserSettings sharedInstance].evernotePassword];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UserSettings sharedInstance].evernoteUserId = userId.text;
    [UserSettings sharedInstance].evernotePassword = password.text;
    
    NSArray *array = self.navigationController.viewControllers;
    int arrayCount = [array count];
    SettingsTableViewController *parent = [array objectAtIndex:arrayCount - 1];
    parent.evernoteAccount = userId.text;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [userId release];
    [password release];
    [super dealloc];
}

- (IBAction)testConnection:(id)sender {
    [[Evernote sharedInstance] connect];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end