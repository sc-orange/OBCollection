//
//  OBHttpCollectController.m
//  OBCollection_Example
//
//  Created by orange on 2021/1/10.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBHttpCollectController.h"

@interface OBHttpCollectController ()
@property (nonatomic, strong)NSArray *urlArray;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

@end

@implementation OBHttpCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getUrl:(UIButton *)sender {
    int index = arc4random() % self.urlArray.count;
    self.urlTextField.text = self.urlArray[index];
}
- (IBAction)sendRequestWithBlock:(UIButton *)sender {
    __weak typeof(self)weakself = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *str = [NSString stringWithFormat:@"%@", responseString];
                weakself.responseTextView.text = str;
            } else {
                NSString *str = [NSString stringWithFormat:@"%@", error];
                weakself.responseTextView.text = str;
            }
        });
    }];
    [task resume];
}

- (NSArray *)urlArray {
    if (!_urlArray) {
        _urlArray = @[@"https://api.apiopen.top/getJoke?page=1&count=2&type=video",
                       @"https://api.apiopen.top/getSingleJoke?sid=28654780",
                       @"https://api.apiopen.top/EmailSearch?number=1012002", //error
                      ];
    }
    return _urlArray;
}
@end
