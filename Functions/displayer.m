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
    end
    
    properties (Constant)
        WHITE = [255 255 255];
        YELLOW = [255 255 0];
        GREEN = [0 255 0];
        RED = [255 0 0];
    end
    
    methods
        function obj = displayer(screid,decideTime)
            obj.screenID = screid;
            obj.decideTime = decideTime;
        end
        
        function openScreen(obj)
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
            Screen('CloseAll');
        end

        function showDecision(obj,data,temp,see,timer,confirmed)
            % Stock Price:  112(+6)
            obj.write('Stock Price:',1,3,'white',30);
            obj.write(num2str(data.stockPrice),2,3,'white',30);
            if data.change<0
                output = strcat('(',num2str(data.change),')');
                obj.write(output,3,3,'green',30);
            end
            
            if data.change ==0
                obj.write('(+0)',3,3,'white',30);
            end
            
            if data.change>0
                output = strcat('(+',num2str(data.change),')');
                obj.write(output,3,3,'red',30);
            end
            
            %Stock          Cash    Total
            %9      1008    1150    2158
            
            obj.write('Stock',1,4,'white',30);
            obj.write('Cash',3,4,'white',30);
            obj.write('Total',4,4,'white',30);
            obj.write(num2str(data.stock),1,5,'white',30);
            obj.write(num2str(data.stockValue),2,5,'white',30);
            obj.write(num2str(data.cash),3,5,'white',30);
            obj.write(num2str(data.totalAsset),4,5,'white',30);

            % Rival's Total: 2300   [++.--]
            obj.write('Rival Total:',1,6,'white',30);
            obj.write(num2str(data.rivalTotal),2,6,'white',30);
            obj.write('Rival Decision:',3,6,'white',30);
            if see
                obj.write(data.oppDecision,4,6,'white',30);
            else
                obj.write('*****',4,6,'white',30);
            end
            
            % buy     no trade    sell    [timer]
            
            if timer <= obj.decideTime
                obj.write('buy',1,8,'white',30);
                obj.write('no trade',2,8,'white',30);
                obj.write('sell',3,8,'white',30);

                if confirmed == 0
                    if temp == "buy" obj.write('buy',1,8,'yellow',30); end
                    if temp == "no trade" obj.write('no trade',2,8,'yellow',30); end
                    if temp == "sell" obj.write('sell',3,8,'yellow',30); end
                end

                if confirmed == 1
                    if temp == "buy" obj.write('buy',1,8,'red',30); end
                    if temp == "no trade" obj.write('no trade',2,8,'red',30); end
                    if temp == "sell" obj.write('sell',3,8,'red',30); end
                end
            end
            
            obj.drawTimer(timer,4,8);
            Screen('Flip',obj.wPtr);
        end
        
        function write(obj,text,x,y,c,size)
            if strcmp(c,'white') color = obj.WHITE; end
            if strcmp(c,'red') color = obj.RED; end
            if strcmp(c,'green') color = obj.GREEN; end
            if strcmp(c,'yellow') color = obj.YELLOW; end

            Screen(obj.wPtr,'TextSize', size);
            Screen('DrawText',obj.wPtr,char(text), obj.xCen+obj.col(x), obj.yCen-obj.row(y), color);
            
        end
        
        function drawTimer(obj,t,xPosi,yPosi)
            w = 15;
            h = 50;
            margin = 20;
            x = obj.xCen+obj.col(xPosi);
            y = obj.yCen-obj.row(yPosi);
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

