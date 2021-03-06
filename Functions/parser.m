classdef parser
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = parser()
        end
        
        function str = resToStr(obj, res)
            str = '';
            str = strcat(str,res.decision);
            for i = 1:size(res.events)
                str = strcat(str,',',res.events{i,1},',',res.events{i,2});
            end
        end
        
        function res = strToRes(obj,str)
            c = strsplit(str,',');
            res.decision = c{1};
            res.events = cell(0,2);
            eventsNum = (size(c)-1)/2;
            
            for i = 1:eventsNum(2)
                res.events{end+1,1} = str2double(c{i*2});
                res.events{end,2} = str2double(c{i*2+1});
            end
        end
    end
    
end

