classdef displayer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        wPtr
        width
        height
        xCen
        yCen
        screenID
        row
        col
        decideTime
        displayerOn
    end
    
    properties (Constant)
        WHITE = [255 255 255];
        YELLOW = [255 255 0];
        GREEN = [0 255 0];
        RED = [255 0 0];
        yLine = [20 34 42 56 75];
    end
    
    methods
        function obj = displayer(screid,displayerOn,decideTime)
            obj.screenID = screid;
            obj.decideTime = decideTime;
            obj.displayerOn = displayerOn;
        end
        
        function openScreen(obj)
            if ~obj.displayerOn return; end
            
            [obj.wPtr, screenRect]=Screen('OpenWindow',obj.screenID, 0,[],32,2);
            [obj.width, obj.height] = Screen('WindowSize', obj.wPtr);
            obj.xCen = obj.width/2;
            obj.yCen = obj.height/2;
            for i = 1:10
                obj.row(i) = -(i-6)*obj.height/10;
            end
            
            for i = 1:5
                obj.col(i) = (i-3)*obj.width/6;
            end
        end
        
        function closeScreen(obj)
            if ~obj.displayerOn return; end
            Screen('CloseAll');
        end

        function showDecision(obj,data,temp,see,timer,confirmed)
            if ~obj.displayerOn return; end
            
            % Stock Price:  112(+6)
            obj.write('Stock Price:',20,1,'white',30);
            obj.write(num2str(data.stockPrice),30,1,'white',30);
            if data.change<0
                output = strcat('(',num2str(data.change),')');
                obj.write(output,35,1,'green',30);
            end
            
            if data.change ==0
                obj.write('(+0)',35,1,'white',30);
            end
            
            if data.change>0
                output = strcat('(+',num2str(data.change),')');
                obj.write(output,35,1,'red',30);
            end
            
            %Stock          Cash    Total
            %9      1008    1150    2158
            
            obj.write('Stock',20,2,'white',30);
            obj.write('Cash',40,2,'white',30);
            obj.write('Total',70,2,'white',30);
            obj.write(num2str(data.stock),20,3,'white',30);
            obj.write(num2str(data.stockValue),30,3,'white',30);
            obj.write(num2str(data.cash),40,3,'white',30);
            obj.write(num2str(data.totalAsset),70,3,'white',30);

            % Rival Decision: [++.--]  Rival's Total: 2300   
            
            obj.write('Rival Decision:',20,4,'white',30);
            if see
                obj.write(data.oppDecision,35,4,'white',30);
            else
                obj.write('*****',35,4,'white',30);
            end
            
            obj.write('Rival Total:',60,4,'white',30);
            obj.write(num2str(data.rivalTotal),70,4,'white',30);
            
            % buy     no trade    sell    [timer]
            
            if timer <= obj.decideTime
                obj.write('buy',20,5,'white',30);
                obj.write('no trade',36,5,'white',30);
                obj.write('sell',52,5,'white',30);

                if confirmed == 0
                    if strcmp(temp ,'buy') obj.write('buy',20,5,'yellow',30); end
                    if strcmp(temp ,'no trade') obj.write('no trade',36,5,'yellow',30); end
                    if strcmp(temp ,'sell') obj.write('sell',52,5,'yellow',30); end
                end

                if confirmed == 1
                    if strcmp(temp ,'buy') obj.write('buy',20,5,'red',30); end
                    if strcmp(temp ,'no trade') obj.write('no trade',36,5,'red',30); end
                    if strcmp(temp ,'sell') obj.write('sell',52,5,'red',30); end
                end
            end
            
            obj.drawTimer(timer,65,5);
            Screen('Flip',obj.wPtr);
        end
        
        function write(obj,text,x,y,c,size)
            if strcmp(c,'white') color = obj.WHITE; end
            if strcmp(c,'red') color = obj.RED; end
            if strcmp(c,'green') color = obj.GREEN; end
            if strcmp(c,'yellow') color = obj.YELLOW; end

            Screen(obj.wPtr,'TextSize', size);
            Screen('DrawText',obj.wPtr,char(text), ceil(x*obj.width/100), ceil(obj.yLine(y)*obj.height/100), color);
            
        end
        
        function drawTimer(obj,t,xPosi,yPosi)
            w = 15;
            h = 50;
            margin = 20;
            x = ceil(xPosi*obj.width/100);
            y = ceil(obj.yLine(yPosi)*obj.height/100);
            for i = 1:t
                if i <= obj.decideTime
                    Screen('FillRect', obj.wPtr, obj.YELLOW, [x,y,x+w,y+h]);
                else
                    Screen('FillRect', obj.wPtr, obj.WHITE, [x,y,x+w,y+h]);
                end
                x = x+margin;
            end

        end
        
    end
    
end

