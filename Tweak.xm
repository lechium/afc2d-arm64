/* AFC2 - the original definition of "jailbreak"
 * Copyright (C) 2014  Jay Freeman (saurik)
 * Copyright (C) 2018 - 2021  Cannathea
 */

/* GNU General Public License, Version 3 {{{ */
/*
 * Cydia is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * Cydia is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cydia.  If not, see <http://www.gnu.org/licenses/>.
 **/
/* }}} */

#import "easy_spawn.h"
#import <Foundation/Foundation.h>

#define PATH @"/fs/jb/usr/libexec/afc2dSupport"

%group PineBoardHook %hook PBAppDelegate
- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    
    _Bool orig = %orig;
    %log; 
    easy_spawn((const char *[]){"/fs/jb/usr/bin/killdaemon", NULL});
    return orig;
}
%end %end

%ctor {
    if (([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/share/jailbreak/signcert.p12"]) ||
        [[NSFileManager defaultManager] fileExistsAtPath:PATH]) {
        %init(PineBoardHook);
    }
}
