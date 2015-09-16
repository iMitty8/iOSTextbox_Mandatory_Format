//
//  ViewController.m
//  TextboxMandatoryFormat
//
//The MIT License (MIT)
//
//Copyright (c) 2015 Mithun R
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.


#import "ViewController.h"

@interface ViewController ()
{
    NSString *openFormat;
    NSString *closeFormat;
    NSString *intermideateFormat;
    NSString *charFormat1;
    //NSString *charFormat2;
    
    NSMutableString *phoneFormatString;
    NSString *inputTest;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    openFormat = @"(";
    closeFormat = @")";
    intermideateFormat = @"-";
    charFormat1 = @"#";
    //charFormat2 = nil;
    
    //(###)-(#######)
    NSArray *formatList = [[NSArray alloc]initWithObjects: openFormat,charFormat1,charFormat1,charFormat1,closeFormat,intermideateFormat,openFormat,charFormat1,charFormat1,charFormat1,charFormat1,charFormat1,charFormat1,charFormat1,closeFormat, nil ];
    
    phoneFormatString = [[NSMutableString alloc]init];
    for (NSString *formatString in formatList) {
        [phoneFormatString appendString:formatString];
    }
    inputTest = [phoneFormatString copy];
    [_tbPhoneNo setText:phoneFormatString];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma UITextView Delegate

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:charFormat1];
    NSRange range = [textField.text rangeOfCharacterFromSet:charSet];
    
    if (range.location != NSNotFound)
    {
        UITextPosition *cusorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
        [textField setSelectedTextRange:[textField textRangeFromPosition:cusorPosition toPosition:cusorPosition]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location < phoneFormatString.length) {
        
        NSRange replacementRange = range;
        replacementRange.length = 1;
        NSRange nextStringRange;
        nextStringRange.length = 1;
        
        if([string isEqualToString:@""]) //Backspace
        {
            NSString *deleteString = [textField.text substringWithRange:replacementRange];
            if ([deleteString isEqualToString:openFormat] || [deleteString isEqualToString:closeFormat] || [deleteString isEqualToString:intermideateFormat]) {
                //
            }
            else
            {
                [textField setText:[textField.text stringByReplacingCharactersInRange:replacementRange withString:charFormat1]];
            }
            nextStringRange.location = range.location;
            NSString *nextString;
            
            for (nextString = [textField.text substringWithRange:nextStringRange]; ([nextString isEqualToString:intermideateFormat] || [nextString isEqualToString:openFormat] ) && nextStringRange.location != 0 ; )
            {
                nextStringRange.location = nextStringRange.location - 1;
                nextString = [textField.text substringWithRange:nextStringRange];
            }
            
            if (nextStringRange.location != 0) {
                
                UITextPosition *cusorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:nextStringRange.location];
                [textField setSelectedTextRange:[textField textRangeFromPosition:cusorPosition toPosition:cusorPosition]];
            }
        }
        else if ([string isEqualToString:@" "]) //BlankSpace
        {
            //Do nothing//
        }
        else //Other
        {
            [textField setText:[textField.text stringByReplacingCharactersInRange:replacementRange withString:string]];
            nextStringRange.location = range.location + 1;
            
            NSString *nextString = [textField.text substringWithRange:nextStringRange];
            if ([nextString isEqualToString:openFormat] || [nextString isEqualToString:intermideateFormat] || [nextString isEqualToString:closeFormat]) { //Will redirect to first available blank
                
                NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:charFormat1];
                NSRange range = [textField.text rangeOfCharacterFromSet:charSet];
                
                if (range.location != NSNotFound)
                {
                    UITextPosition *cusorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
                    [textField setSelectedTextRange:[textField textRangeFromPosition:cusorPosition toPosition:cusorPosition]];
                }
            }
            else
            {
                UITextPosition *cusorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:nextStringRange.location];
                [textField setSelectedTextRange:[textField textRangeFromPosition:cusorPosition toPosition:cusorPosition]];
            }
        }
        
    }
    return NO;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField setText:phoneFormatString];
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:charFormat1];
    NSRange range = [textField.text rangeOfCharacterFromSet:charSet];
    
    if (range.location != NSNotFound)
    {
        UITextPosition *cusorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
        [textField setSelectedTextRange:[textField textRangeFromPosition:cusorPosition toPosition:cusorPosition]];
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

@end
