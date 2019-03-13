#import <Cephei/HBPreferences.h>

static NSDictionary *prefixes = @{
    @"furry": @[@"OwO What's this? ", @"OwO ", @"H-hewwo?? ", @"Huohhhh. ", @"Haiiii! ", @"UwU ", @"OWO ", @"HIIII! ", @"<3 "],
    @"pirate": @[@"Arr, matey! ", @"Arrr! ", @"Ahoy. ", @"Yo ho ho! "],
    @"anime": @[@":33 < ", @"yare yare.. ", @"yare yare daze.. ", @"177013 ", @"Kawaii ne, ", @"NANI?! ", @"MUDA MUDA MUDA, ", @"ORA ORA ORA ", @"DIO! ", @"JOJO! ", @"JOTARO! "]
};

static NSDictionary *suffixes = @{
    @"furry": @[@" :3", @" UwU", @" ʕʘ‿ʘʔ", @" >_>", @" ^_^", @"..", @" Huoh.", @" ^-^", @" ;_;", @" ;-;", @" xD", @" x3", @" :D", @" :P", @" ;3", @" XDDD", @", fwendo ", @" ㅇㅅㅇ", @" (人◕ω◕)", @" （＾ｖ＾）"]
};

static NSDictionary *replacement = @{
    @"furry": @{
        @"r": @"w",
        @"l": @"w",
        @"R": @"W",
        @"no": @"nu",
        @"has": @"haz",
        @"have": @"haz",
        @"you": @"uu",
    },
    @"leet": @{
        @"cks": @"x",
        @"ck": @"x",
        @"er": @"or",
        @"and": @"&",
        @"anned": @"&",
        @"porn": @"pr0n",
        @"lol": @"lulz",
        @"the ": @"teh ",
        @"a": @"4",
        @"o": @"0",
        @"e": @"3",
        @"b": @"8",
        @"s": @"5",
        @"z": @"2",
        @"l": @"1",
        @"t": @"7",
    },
    @"pirate": @{
        @"this": @"'tis",
        @"g ": @"' ",
        @"you": @"ye",
        @"You": @"Ye",
    },
    @"anime": @{
        @"awful": @"pawful",
        @"per": @"purr",
        @"por": @"purr",
        @"fer": @"fur",
        @"pau": @"paw",
        @"po": @"paw",
        @"best": @"KAWAII",
        @"ee": @"33",
        @"EE": @"33",
        @"what": @"nani",
        @"WHAT": @"NANI",
        @"What": @"Nani",
        @"wHat": @"nAni",
        @"whAt": @"naNi",
        @"whaT": @"nanI",
        @"WHAt": @"NANi",
        @"WhAT": @"NaNI",
        @"WHaT": @"NAnI",
        @"wHAT": @"nANI",
        @"WhAt": @"NaNi",
        @"wHaT": @"nAnI"
    }
};

static NSString *mode = nil;

NSString *owoify (NSString *text, bool replacementOnly) {
    NSString *temp = [text copy];
    
    if (replacement[mode]) {
        for (NSString *key in replacement[mode]) {
            temp = [temp stringByReplacingOccurrencesOfString:key withString:replacement[mode][key]];
        }
    }

    if (!replacementOnly) {
        if (prefixes[mode]) {
            temp = [prefixes[mode][arc4random() % [prefixes[mode] count]] stringByAppendingString:temp];
        }

        if (suffixes[mode]) {
            temp = [temp stringByAppendingString:suffixes[mode][arc4random() % [suffixes[mode] count]]];
        }
    }

    return temp;
}

%group OwONotifications

%hook NCNotificationContentView

-(void)setPrimaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, true));
}

-(void)setSecondaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, false));
}

%end

%end

%group OwOEverywhere

%hook UILabel

-(void)setText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, true));
}

%end

%end

%group OwOIconLabels

%hook SBIconLabelImageParameters

-(NSString *)text {
    return owoify(%orig, true);
}

%end

%end

%group OwOSettings

%hook PSSpecifier

-(NSString *)name {
    return owoify(%orig, true);
}

%end

%end

%ctor {
    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString:processName];

    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.owo"];

    if ([([file objectForKey:@"Enabled"] ?: @(YES)) boolValue]) {
        mode = [file objectForKey:@"Style"] ?: @"furry";

        if ([([file objectForKey:@"EnabledEverywhere"] ?: @(NO)) boolValue]) {
            %init(OwOEverywhere);
        }

        if ([([file objectForKey:@"EnabledSettings"] ?: @(NO)) boolValue]) {
            %init(OwOSettings);
        }

        if (isSpringboard) {
            if ([([file objectForKey:@"EnabledNotifications"] ?: @(YES)) boolValue]) {
                %init(OwONotifications);
            }

            if ([([file objectForKey:@"EnabledIconLabels"] ?: @(NO)) boolValue]) {
                %init(OwOIconLabels);
            }
        }
    }
}
