//
//  DocumentDirectoryContentViewController.m
//  Communicator
//
//  Created by mac on 07/11/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DocumentDirectoryContentViewController.h"

@interface DocumentDirectoryContentViewController ()

@end

@implementation DocumentDirectoryContentViewController
@synthesize attachmentArray,reportArray,documentArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsDirectory objectAtIndex:0];
   NSString* reportPath= [path stringByAppendingPathComponent:@"Reports"];
   NSString* documentsPath= [path stringByAppendingPathComponent:@"Documents"];
   NSString* attachmentsPath= [path stringByAppendingPathComponent:@"Attachments"];

   attachmentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:attachmentsPath error:NULL];
    reportArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:reportPath error:NULL];
    documentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:NULL];

   
    for (int i=0;i<attachmentArray.count;i++)
    {
        NSLog(@"File %@", [attachmentArray objectAtIndex:i]);
    }
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    NSLog(@"viewforHeader");
    
    UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 60)];
    UILabel* sectionTitleBackgroundLabelLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    sectionTitleBackgroundLabelLabel.backgroundColor=[UIColor grayColor];
    
    UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 20, tableView.frame.size.width, 17)];
    //sectionTitleLabel.backgroundColor=[UIColor whiteColor];
    
    [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
    UIFont *currentFont = sectionTitleLabel.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    sectionTitleLabel.font = newFont;
    [sectionHeaderView addSubview:sectionTitleBackgroundLabelLabel];
    
    [sectionHeaderView addSubview:sectionTitleLabel];
    if (section==0)
    {
        sectionTitleLabel.text=@"Attachment Files";
        
    }
    else
        if (section==1)
        {
            sectionTitleLabel.text=@"Report Files";

        }
    else
    {
        sectionTitleLabel.text=@"Document Files";

    }
    
        
        return sectionHeaderView;
   
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
            return 50;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return attachmentArray.count;

    }
    else
    if(section==1)
    {
        return reportArray.count;

    }
    else
     {
            return documentArray.count;
            
        }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
  UILabel* fileNameLabel=  [cell viewWithTag:101];

    if (indexPath.section==0)
    {
        fileNameLabel.text=[attachmentArray objectAtIndex:indexPath.row];
        //fileNameLabel.text= [fileNameLabel.text substringFromIndex:13];

    }
    if (indexPath.section==1)
    {
        fileNameLabel.text=[reportArray objectAtIndex:indexPath.row];
        //fileNameLabel.text= [fileNameLabel.text substringFromIndex:13];

    }
    if (indexPath.section==2)
    {
        fileNameLabel.text=[documentArray objectAtIndex:indexPath.row];
        //fileNameLabel.text= [fileNameLabel.text substringFromIndex:13];

    }
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0)
//    {
//        <#statements#>
//    }
    if (indexPath.section==0)
    {
        [AppPreferences sharedAppPreferences].fileLocation=@"Downloads";
    }
    else
        if (indexPath.section==1)
        {
            [AppPreferences sharedAppPreferences].fileLocation=@"Reports";
        }
    else
        if (indexPath.section==2)
    {
        [AppPreferences sharedAppPreferences].fileLocation=@"Documents";
    }
    [[AppPreferences sharedAppPreferences].imageFileNamesArray removeAllObjects];
    [[AppPreferences sharedAppPreferences].imageFilesArray removeAllObjects];
    UITableViewCell* cell= [tableView cellForRowAtIndexPath:indexPath];
    UILabel* fileNameLabel=[cell viewWithTag:101];
    [[AppPreferences sharedAppPreferences].imageFileNamesArray addObject:fileNameLabel.text];
    
//    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",[AppPreferences sharedAppPreferences].fileLocation,fileNameLabel.text]];
//
//   // NSURL* url=[NSURL URLWithString:destpath];
//    
//    NSData* data=[NSData dataWithContentsOfFile:destpath];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
