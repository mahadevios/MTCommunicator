//
//  TestViewController.m
//  Communicator
//
//  Created by mac on 15/11/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "TestViewController.h"
#import "FeedbackChatingCounter.h"
#import "NSString+HTML.h"

@interface TestViewController ()

@end

@implementation TestViewController
@synthesize tableview;
- (void)viewDidLoad
{
    [super viewDidLoad];
    heightArray=[[NSMutableArray alloc] init];
    webViewArray=[[NSMutableArray alloc]init];
    cellArray=[[NSMutableArray alloc]init];

    for (int i=0; i<[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count; i++)
    {
        [heightArray addObject:[NSString stringWithFormat:@"%d",40]];
    }
//    for (int i=0; i<[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count; i++)
//    {
//        UIWebView* we=[UIWebView new];
//        [webViewArray addObject:we];
//    }
    for (int i=0; i<[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count; i++)
    {
        UITableViewCell* cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 12)];
        UIWebView* webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        webView.tag=51;
        [cell addSubview:webView];
        [cellArray addObject:cell];
    }
    // Do any additional setup after loading the view.
}
#pragma mark:tableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return [AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count;
        
   
    
    }

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (tableView==self.popupTableView)
//    {
//
//    UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.popupTableView.frame.size.width,50)];
//    sectionView.backgroundColor=[UIColor grayColor];
//
//    UISwitch* historySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//
//    //    setAttendeeList
//    UILabel* historyLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.popupTableView.frame.size.width/2, 10, self.popupTableView.frame.size.width/2, 20)];
//historyLabel.text=@"Without history";
//    [sectionView addSubview:historySwitch];
//    [sectionView addSubview:historyLabel];
//
//    //UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 5, 50, 40)];
//    return  sectionView;
//    }
//    else
//    {
//        return nil;
//    }
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
       // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [cellArray objectAtIndex:indexPath.row];

        FeedbackChatingCounter* feedObject= [[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
        
        
        Database* db=[Database shareddatabase];
        NSString* userRole=[db getUserIdFromUserNameWithRoll1:feedObject.userTo];
        if (cell!=nil)
        {
            cell.contentView.backgroundColor=[UIColor grayColor];
            if ([userRole isEqualToString:@"1"])
            {
                cell.contentView.backgroundColor=[UIColor colorWithRed:202.0/255 green:229.0/255 blue:159.0/255 alpha:1];
                
            }
        }
        
        if (feedObject.statusId==2)
        {
            //[self setNavigationItems:@""];
        }
    
//    UIWebView* webView=[cell viewWithTag:indexPath.row];
//    if ([webView isKindOfClass:[UIWebView class]])
//    {
//        [webView loadHTMLString:feedObject.detailMessage baseURL:nil];
//    }
    UIWebView* feedTextWebView=[cell viewWithTag:51];
    
   //UIWebView* feedTextWebView= [webViewArray objectAtIndex:indexPath.row];
   // feedTextWebView.frame=feedTextWebView1.frame;
    feedTextWebView.delegate=self;
    feedTextWebView.scrollView.delegate=self;
    feedTextWebView.backgroundColor=[UIColor clearColor];
    [feedTextWebView setOpaque:NO];
    feedTextWebView.scrollView.scrollEnabled = NO;

    feedTextWebView.scrollView.bounces = NO;
    
    feedObject.detailMessage=[feedObject.detailMessage stringByDecodingHTMLEntities];
    [feedTextWebView loadHTMLString:feedObject.detailMessage baseURL:nil];
    feedTextWebView.tag=indexPath.row;
              return cell;
        
   
    }
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if ([scrollView.superview isKindOfClass:[UIWebView class]])
//    {
//        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
//            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
//    }
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* height=  [heightArray objectAtIndex:indexPath.row];
    return [height intValue]+60;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
  int height1=  webView.scrollView.contentSize.height;
    int height = [result intValue];
    
    NSLog(@"%@",html);
    NSLog(@"%d",height1);
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;

    [heightArray replaceObjectAtIndex:webView.tag withObject:[NSString stringWithFormat:@"%d",height1]];
    [tableview beginUpdates];
    [tableview endUpdates];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
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
