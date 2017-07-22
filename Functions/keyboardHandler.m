classdef keyboardHandler < handle
    
    properties
       dev
       devInd
    end
    
    properties (Constant)
        quitkey     = 'ESCAPE';
        confirm     = 'space';
        buy         = 'LeftArrow';
        noTrade     = 'DownArrow';
        sell        = 'RightArrow';
    end
    
    methods
        function obj = keyboardHandler(keyboardName)
            obj.setupKeyboard(keyboardName);
        end
        
        function setupKeyboard(obj,keyboardName)
            if strcmp(keyboardName,'Mac')
               keyboardName = 'Apple Internal Keyboard / Trackpad';
            end
            if strcmp(keyboardName,'USB')
                keyboardName = 'USB Receiver';
            end
            obj.dev=PsychHID('Devices');
            obj.devInd = find(strcmpi('Keyboard', {obj.dev.usageName}) & strcmpi(keyboardName, {obj.dev.product}));
            KbQueueCreate(obj.devInd);  
            KbQueueStart(obj.devInd);
            KbName('UnifyKeyNames');
        end
       
        function res = getResponse(obj)
            res = 2;
            while true
                try
                KbEventFlush();
                [keyIsDown, secs, keyCode] = KbQueueCheck(obj.devInd);
                
                if secs(KbName(obj.confirm))
                        fprintf('confirmed\n');
                        break;
                end
                
                if secs(KbName(obj.buy))
                        res = 1;
                        fprintf('buy\n');
                end
                
                if secs(KbName(obj.noTrade))
                        res = 2;
                        fprintf('noTrade\n');
                end
                
                if secs(KbName(obj.sell))
                        res = 3;
                        fprintf('sell\n');
                end
                
                catch exception
                    fprintf(1,'Error: %s\n',getReport(exception));
                end
            end
        end
        
    end
    
end
