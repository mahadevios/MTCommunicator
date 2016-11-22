//
//  MomDetailViewController.m
//  Communicator
//
//  Created by mac on 20/10/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "MomDetailViewController.h"
#import "UIColor+CommunicatorColor.h"
//#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"

@interface MomDetailViewController ()

@end

@implementation MomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];//
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    
    self.navigationItem.title = @"MoM Preview";
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    Database* db=[Database shareddatabase];
    Mom* momObj= self.momObj;
    [db updateMom:momObj.Id];

    UIView* sectionView=[self.view viewWithTag:100];
    
    UILabel* redUnderlineView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    redUnderlineView.backgroundColor=[UIColor colorWithRed:204/255.0 green:0/255.0 blue:1/255.0 alpha:1];
    
    //[redUnderlineView setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
    // redUnderlineView.textColor=[UIColor communicatorColor];
    [sectionView addSubview:redUnderlineView];
    
    UILabel* subjectlabel=[self.view viewWithTag:101];
    subjectlabel.text=momObj.subject;
    
    UILabel* datelabel=[self.view viewWithTag:102];
    datelabel.text=[NSString stringWithFormat:@"Date: %@",momObj.momDate];
    
    UILabel* attendeeslabel=[self.view viewWithTag:103];
    attendeeslabel.text=[NSString stringWithFormat:@"Attendees: %@",momObj.attendee];
    
    UILabel* createdBylabel=[self.view viewWithTag:104];
    NSString* createdByString= [db getFirstnameLastnameFromUserId:momObj.userfeedback];
    createdBylabel.text= [NSString stringWithFormat:@"Created by: %@",createdByString];
    
    UILabel* dateTimeLabel=[self.view viewWithTag:106];
    NSArray* dateTimeArray= [momObj.dateTime componentsSeparatedByString:@" "];
    dateTimeLabel.numberOfLines=2;
    dateTimeLabel.text=[NSString stringWithFormat:@"%@ \n %@",[dateTimeArray objectAtIndex:0],[dateTimeArray objectAtIndex:1]];
    
    [sectionView addSubview:createdBylabel];

    UIWebView* keyPointsWebView=[self.view viewWithTag:105];

//    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-20  , 9999);
//    
//    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          [UIFont fontWithName:@"HelveticaNeue" size:11.0], NSFontAttributeName,
//                                          nil];
//    
//    momObj.keyPoints= [momObj.keyPoints stringByDecodingHTMLEntities];
//
//    NSString* htmlString=momObj.keyPoints;
//    // htmlString=[htmlString stringByDecodingHTMLEntities];
//    htmlString=[htmlString stringByConvertingHTMLToPlainText];
//    //     htmlString= [self stringByStrippingHTML:htmlString];
//    
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString attributes:attributesDictionary];
//    
//    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    
//    if (requiredHeight.size.width > keyPointsWebView.frame.size.width) {
//        requiredHeight = CGRectMake(0,0, keyPointsWebView.frame.size.width, requiredHeight.size.height);
//    }
//    CGRect newFrame = keyPointsWebView.frame;
//    newFrame.size.height = requiredHeight.size.height;
//    keyPointsWebView.frame = newFrame;
    
    momObj.keyPoints= [momObj.keyPoints stringByDecodingHTMLEntities];

    NSString *str = momObj.keyPoints;
    
    NSData *data = [str dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
    
   // _lbl.text = valueEmoj;
    [keyPointsWebView loadHTMLString:[NSString stringWithFormat:@"KeyPoints:<br><br>%@",valueEmoj] baseURL:nil];

    //[keyPointsWebView loadHTMLString:[NSString stringWithFormat:@"KeyPoints:%@",momObj.keyPoints] baseURL:nil];
}

- (IBAction)popViewController
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
