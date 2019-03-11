static NSArray *prefixes = @[@"Argghh! ", @"Yarr harr, ", @"yare yare.. ", @"yare yare daze.. ", @"l33t ", @"1337 ", @"177013 ", @"OwO What's this? ", @"OwO ", @"H-hewwo?? ", @"Huohhhh. ", @"Haiiii! ", @"UwU ", @"OWO ", @"HIIII! ", @"<3 ", @"Kawaii ne, ", @"NANI?! ", @"MUDA MUDA MUDA, ", @"ORA ORA ORA ", @"DIO! ", @"JOJO! ", @"JOTARO! "];
static NSArray *suffixes = @[@" :3", @" UwU", @" ʕʘ‿ʘʔ", @" >_>", @" ^_^", @"..", @" Huoh.", @" ^-^", @" ;_;", @" ;-;", @" xD", @" x3", @" :D", @" :P", @" ;3", @" XDDD", @", fwendo ", @" ㅇㅅㅇ", @" (人◕ω◕)", @" （＾ｖ＾）"];

%hook NCNotificationContentView

-(void)setSecondaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    NSString *prefix = prefixes[arc4random() % [prefixes count]];
    NSString *suffix = suffixes[arc4random() % [suffixes count]];
    orig = [orig stringByReplacingOccurrencesOfString:@"r" withString:@"w"];
    orig = [orig stringByReplacingOccurrencesOfString:@"l" withString:@"w"];
    orig = [orig stringByReplacingOccurrencesOfString:@"no" withString:@"nu"];
    orig = [orig stringByReplacingOccurrencesOfString:@"have" withString:@"haz"];
    orig = [orig stringByReplacingOccurrencesOfString:@"has" withString:@"haz"];
    orig = [orig stringByReplacingOccurrencesOfString:@"you" withString:@"uu"];
    orig = [orig stringByReplacingOccurrencesOfString:@"R" withString:@"W"];
    orig = [orig stringByReplacingOccurrencesOfString:@"L" withString:@"W"];
    orig = [orig stringByReplacingOccurrencesOfString:@"fuck" withString:@"fwucky ducky"];
    orig = [orig stringByReplacingOccurrencesOfString:@"Fuck" withString:@"Fwucky Ducky"];


    NSString *text = [prefix stringByAppendingString:orig];
    text = [text stringByAppendingString:suffix];
    
    %orig(text);
}

%end
