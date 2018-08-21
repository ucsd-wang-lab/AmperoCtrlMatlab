 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Software for wearable bio sensing
%%% T. Nakagawa
%%% 2016.?.?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function swv_test_11
    close all;
    clear;

    global ComName;
    global BleDongle;
    global deviceID;
    global bool_close;
    global bool_stop;
    global htext;
    
    global SWV_INIT_WAIT;
    global SWV_FREQ;
    global SWV_INIT_VOLTAGE;
    global SWV_FINAL_VOLTAGE;
    global SWV_AMPLITUDE;
    global SWV_STEP_VOLTAGE;
    global SWV_OFFSET_VOLTAGE;
    global SWV_INIT_VOLTAGE_OFFSET;
    global SWV_FINAL_VOLTAGE_OFFSET;
    
    global AMPERO_POINTS;
    global AMPERO_PERIOD;
    global AMPERO_OFFSET_VOLTAGE;
    global AMPERO_POTENTIAL;
    global AMPERO_POTENTIAL_OFFSET;
    global amperoStopFlag;
    
    global amperoCompleteFlag;
    global continuousAmperoFlag;
    
    global AMPERO_RA_NUM;
    global AMPERO_RA_A;
    global AMPERO_RA_B;
    
    global HW_ADC_VREF;
    global HW_ADC_RESOLUTION;
    global HW_RIV;
    global HW_LSB_mV;
    
    %figure position
    global left_m;
    global bot_m;
    global col_r;
    global ver_r;
    global mid_m;
            
    disp_debug = 1;

%% logfile output setting
    dialogen = 1;
    dialogfilename = strcat('.\output\dialogfile_', date, '.log');
    if (dialogen == 1)
        diary(dialogfilename);
    end

%% parameters
    %path to param file
    paramfile = '.\input\param_file_v04.dat';
    filereadbutton_Callback();
    
%% figure
    % figure parameter
    figwidth = 1280;
    figheight = 720;
    left_m = 0.1; % ?¶‘¤—]”’
    bot_m = 0.1; % ‰º‘¤—]”’ 
    mid_m = 0.1; % ?ã‰ºŠÔ—]”’ 
    ver_r = 0.38; % ?c•ûŒüŠ„?‡
    col_r = 0.6; % ‰¡•ûŒüŠ„?‡
    % button parameter
    buttonwidth = 150;
    buttonheight = 50;
    buttonposoffsetx = 50;
    buttonposoffsety = 100;
    % logo parameter
    logoposmx = 5;
    logoposmy = 5;

    %figure
    f1 = figure('Visible','off','Position',[0,0,figwidth,figheight]);

    % Position Axes
    ax1 = axes('Position', [left_m, bot_m+ver_r+mid_m, col_r, ver_r]); 
    ax2 = axes('Position', [left_m, bot_m, col_r, ver_r]); 

    set(ax1,'FontName','Arial','FontSize',16);
    set(ax1,'LineWidth', 1);
    xlabel(ax1,'E (V)','FontName','Arial');
    %ylabel(ax1,'I (\muA)','FontName','Arial');
    ylabel(ax1,'I (LSB)','FontName','Arial');

    set(ax2,'FontName','Arial','FontSize',16);
    set(ax2,'LineWidth', 1);
    xlabel(ax2,'E (V)','FontName','Arial');
%     ylabel(ax2,'I1,I2 (\muA)','FontName','Arial');
    ylabel(ax2,'I1,I2 (LSB)','FontName','Arial');

    %textbox
    htext = uicontrol('Style','text','String','Status','FontName','Arial','FontSize',14, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*0-buttonposoffsety), ...
                    buttonwidth*2,buttonheight], ...
        'Callback',{@textbutton_Callback});
    
%     %startƒ{ƒ^ƒ“
%     hstart = uicontrol('Style','pushbutton','String','Start','FontName','Arial','FontSize',11, ...
%         'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*1-buttonposoffsety), ...
%                     buttonwidth,buttonheight], ...
%         'Callback',{@startbutton_Callback});
%     %stopƒ{ƒ^ƒ“
%     hstop = uicontrol('Style','pushbutton','String','Stop','FontName','Arial','FontSize',11, ...
%         'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*2-buttonposoffsety), ...
%                     buttonwidth,buttonheight], ...
%         'Callback',{@stopbutton_Callback});

    %file openƒ{ƒ^ƒ“
    hfileopen = uicontrol('Style','pushbutton','String','Param file open','FontName','Arial','FontSize',11,...
        'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*4-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@fileopenbutton_Callback});
    %file readƒ{ƒ^ƒ“
    hfileread = uicontrol('Style','pushbutton','String','Param update','FontName','Arial','FontSize',11,...
        'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*5-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@filereadbutton_Callback});
    
    %SWV param setƒ{ƒ^ƒ“
%     hSwvParamSet = uicontrol('Style','pushbutton','String','SWV Param Set','FontName','Arial','FontSize',11, ...
%         'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*6-buttonposoffsety), ...
%                     buttonwidth,buttonheight], ...
%         'Callback',{@SwvParamSetButton_Callback});
    
    %Ampero continuous
    hSwvParamSet = uicontrol('Style','pushbutton','String','Continuous Ampero','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*7-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@ContinuousAmperoStartButton_Callback});
    %Ampero param setƒ{ƒ^ƒ“
    hAmperoParamSet = uicontrol('Style','pushbutton','String','Ampero Param Set','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*8-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@AmperoParamSetButton_Callback});

    %closeƒ{ƒ^ƒ“
    hclose = uicontrol('Style','pushbutton','String','Close','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth-buttonposoffsetx),(figheight-buttonheight*9-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@closebutton_Callback});

%     %scanƒ{ƒ^ƒ“
%     hScan = uicontrol('Style','pushbutton','String','Scan','FontName','Arial','FontSize',11, ...
%         'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*1-buttonposoffsety), ...
%                     buttonwidth,buttonheight], ...
%         'Callback',{@ScanButton_Callback});
%     %cancel scanƒ{ƒ^ƒ“
%     hCancelScan = uicontrol('Style','pushbutton','String','Cancel Scan','FontName','Arial','FontSize',14, ...
%         'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*2-buttonposoffsety), ...
%                     buttonwidth,buttonheight], ...
%         'Callback',{@CancelScanButton_Callback});
    %establishƒ{ƒ^ƒ“
    hEstablish = uicontrol('Style','pushbutton','String','Establish','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*1-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@EstablishButton_Callback});
    %cancel establishƒ{ƒ^ƒ“
    hCancelEstablish = uicontrol('Style','pushbutton','String','Cancel Establish','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*2-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@CancelEstablishButton_Callback});
    %terminate linkƒ{ƒ^ƒ“
    hTerminateLink = uicontrol('Style','pushbutton','String','Terminate Link','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*3-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@TerminateLinkButton_Callback});
    %Led Onƒ{ƒ^ƒ“
    hLedOn = uicontrol('Style','pushbutton','String','LED On','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*4-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@LedOnButton_Callback});
    %Led Offƒ{ƒ^ƒ“
    hLedOff = uicontrol('Style','pushbutton','String','LED Off','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*5-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@LedOffButton_Callback});
    
    %SWV measƒ{ƒ^ƒ“
    hSwvMeas = uicontrol('Style','pushbutton','String','SWV Measure','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*6-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@SwvMeasButton_Callback});
    
    %CV measƒ{ƒ^ƒ“
    hCvStart = uicontrol('Style','pushbutton','String','CV Measure','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*7-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@CvMeasButton_Callback});
    
    %Amperoƒ{ƒ^ƒ“
    hAmpero = uicontrol('Style','pushbutton','String','Chronoamperometry','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*8-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@AmperoButton_Callback});

    %Ampero Stopƒ{ƒ^ƒ“
    hAmperoStop = uicontrol('Style','pushbutton','String','STOP','FontName','Arial','FontSize',11, ...
        'Position',[(figwidth-buttonwidth*2-buttonposoffsetx),(figheight-buttonheight*9-buttonposoffsety), ...
                    buttonwidth,buttonheight], ...
        'Callback',{@AmperoStopButton_Callback});
    
    %Hitachiƒ?ƒS
%     hlogodata = imread('.\input\corp_id_hd.jpg');
%     hlogosize = size(hlogodata);
%     hlogo = uicontrol('Style','pushbutton','String','',...
%         'Position',[(figwidth-hlogosize(2)-logoposmx),logoposmy,hlogosize(2),hlogosize(1)]);
%     set(hlogo,'cdata',hlogodata);
    %UCSDƒ?ƒS
    ulogodata = imread('.\input\ucsd-logo2.jpg');
    ulogosize = size(ulogodata);
    ulogo = uicontrol('Style','pushbutton','String','',...
        'Position',[(figwidth-ulogosize(2)-logoposmx),logoposmy,ulogosize(2),ulogosize(1)]);
    set(ulogo,'cdata',ulogodata);

    %GUI setting
    set([f1,htext,hfileopen,hfileread,hclose,ulogo, ...
        hEstablish,hCancelEstablish,hTerminateLink, ...
        hLedOn,hLedOff,hSwvParamSet,hSwvMeas,hCvStart,hAmperoParamSet,hAmpero,hAmperoStop], ...
        'Units','normalized');
    set(f1,'Name',['KLG Sensor: ' deviceID]);
    movegui(f1,'center');
    set(f1,'Visible','on');
    set(f1,'CloseRequestFcn',@closebutton_Callback);
    
%% main
    bool_close = 0;
    bool_stop = 0;
    continuousAmperoFlag = false;
    %com port open
    BleDongleOpen();
    %dongle initialization
    BleDongleInit();

	%htext.String = 'No data from device';
    
    %loop
    while(bool_close == 0)
        while(bool_stop == 1)
            pause(0.2);
            if(bool_close == 1); break; end
        end
        if (continuousAmperoFlag == true && amperoCompleteFlag == true)
            %pause(30);
            AmperoButton_Callback();
        end
        % receive packet
        if (BleDongle.BytesAvailable == 0)
            pause(0.3);
        else
            pause(0.3);
%             %BleDongle.BytesAvailable
%             [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket();
%             if ( RecvError ~= 0 )
%                 disp( 'error packet' );
%                 break;
%             end
        end

        if(bool_close == 1)
            TerminateLinkButton_Callback();
            pause(0.1);
            fclose(BleDongle);
            delete(BleDongle);
            clear BleDongle;
            clear;
            close all;
            diary off;
            break;
        end
    end

%% open serial
    function BleDongleOpen()
        delete(instrfind('Port',ComName));
%         if ( strcmp(ComName,'COM3') )
%             delete(instrfind('Port','COM3'));
%         end
%         if ( strcmp(ComName,'COM7') )
%             delete(instrfind('Port','COM7'));
%         end

        BaudRate = 115200;
        BleDongle = serial(ComName, 'BaudRate', BaudRate, 'DataBits',8 );
        set(BleDongle,'Timeout',4);
        % BleDongle = serial(ComName);
        if (disp_debug == 1)
            get(BleDongle,{'Type','Name','Port','BaudRate'})
        end

        htext.String = 'Com port open error';

        fopen(BleDongle);

        if ( BleDongle.Status == 'open' )
            htext.String = 'Com port opened';
        end
        
        % clear serial buffer
        while (BleDongle.BytesAvailable > 0)
            fread(BleDongle,1);
        end
    end

%% init bluetooth dongle
    function BleDongleInit()
        %[2]--------Send GAP_Device_Init -------------%
        GAP_initialise=['01';'00';'FE';'26';'08';'05';'00';'00';'00';'00';'00';'00';'00'
        '00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'00'
        '00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'00';'01'
        '00';'00';'00']; 

        TxDataDec = hex2dec(GAP_initialise);
        fwrite(BleDongle, char(TxDataDec)');

        %[3] Receive GAP_HCI_ExtentionCommandsStatus (9 Bytes)
        % 04 FF 06 7F 06 00 00 FE 00

        [RecvData, ~] = fread(BleDongle,9);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % [4] : <Rx> - GAP_DeviceInitDone (47 Bytes)
        % 04 FF 2C 00 06 00 7F 77 09 13 F5 D4 1B 00 04 EA
        % 9A 65 8E 5D 2B A2 79 11 38 F6 4C 00 07 43 03 07
        % F5 F3 40 80 07 3B A3 CC 11 EF 96 D5 CE DA DF

        [RecvData, ~] = fread(BleDongle,47);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % [5] : <Tx> - GAP_GetParam
        % 01 31 FE 01 15
        GAP_GetParam=['01';'31';'FE';'01';'15'];
        TxDataDec = hex2dec(GAP_GetParam);
        fwrite(BleDongle, char(TxDataDec)');

        % [6] : <Tx> - GAP_GetParam
        % 01 31 FE 01 16
        GAP_GetParam=['01';'31';'FE';'01';'16'];
        TxDataDec = hex2dec(GAP_GetParam);
        fwrite(BleDongle, char(TxDataDec)');

        % [7] : <Tx> - GAP_GetParam
        % 01 31 FE 01 1A
        GAP_GetParam=['01';'31';'FE';'01';'1A'];
        TxDataDec = hex2dec(GAP_GetParam);
        fwrite(BleDongle, char(TxDataDec)');

        % [8] : <Tx> - GAP_GetParam
        % 01 31 FE 01 19
        GAP_GetParam=['01';'31';'FE';'01';'19'];
        TxDataDec = hex2dec(GAP_GetParam);
        fwrite(BleDongle, char(TxDataDec)');

        % [9] : <Rx> - GAP_HCI_ExtentionCommandStatus
        % 04 FF 08 7F 06 00 31 FE 02 50 00

        [RecvData, ~] = fread(BleDongle,11);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % [10] : <Rx> - GAP_HCI_ExtentionCommandStatus
        % 04 FF 08 7F 06 00 31 FE 02 50 00

        [RecvData, ~] = fread(BleDongle,11);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % [11] : <Rx> - GAP_HCI_ExtentionCommandStatus
        % 04 FF 08 7F 06 00 31 FE 02 00 00

        [RecvData, ~] = fread(BleDongle,11);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % [12] : <Rx> - GAP_HCI_ExtentionCommandStatus
        % 04 FF 08 7F 06 00 31 FE 02 D0 07

        [RecvData, ~] = fread(BleDongle,11);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end
    end

% %% scan
%     function ScanButton_Callback(~,~)
% 
%         % [1] : <Tx> - 06:03:33.936
%         % -Type           : 0x01 (Command)
%         % -OpCode         : 0xFE04 (GAP_DeviceDiscoveryRequest)
%         % -Data Length    : 0x03 (3) byte(s)
%         %  Mode           : 0x03 (3) (All)
%         %  ActiveScan     : 0x01 (1) (Enable)
%         %  WhiteList      : 0x00 (0) (All)
%         % Dump(Tx):
%         % 0000:01 04 FE 03 03 01 00                            .......                
% 
%         GAP_DeviceDiscoveryRequest=['01';'04';'FE';'03';'03';'01';'00'];
% 
%         if (disp_debug == 1)
%             disp(GAP_DeviceDiscoveryRequest);
%         end
%         
%         TxDataDec = hex2dec(GAP_DeviceDiscoveryRequest);
%         fwrite(BleDongle, char(TxDataDec)');
%         
%         % read
%         [RecvData, ~] = fread(BleDongle,9);
%         if (disp_debug)
%         RecvDataHex = dec2hex(RecvData);
%         disp(RecvDataHex);
%         end
% 
%         % read dummy
%         pause(0.1);
%         [~, ~, ~] = BleRecvPacket();
%         
%     end
% 
% %% cancel scan
%     function CancelScanButton_Callback(~,~)
% 
%         % [1] : <Tx> - 06:13:56.360
%         % -Type           : 0x01 (Command)
%         % -OpCode         : 0xFE05 (GAP_DeviceDiscoveryCancel)
%         % -Data Length    : 0x00 (0) byte(s)
%         % Dump(Tx):
%         % 0000:01 05 FE 00                                     ....
% 
%         GAP_DeviceDiscoveryCancel=['01';'05';'FE';'00'];
% 
%         if (disp_debug == 1)
%             GAP_DeviceDiscoveryCancel'
%         end
%         
%         TxDataDec = hex2dec(GAP_DeviceDiscoveryCancel);
%         fwrite(BleDongle, char(TxDataDec)');
% 
%         % read dummy
%         pause(0.1);
%         [RecvDataHdrTmp, RecvDataBodyTmp, RecvError] = BleRecvPacket();
%         
%         % clear serial buffer
%         while (BleDongle.BytesAvailable > 0)
%             fread(BleDongle,1);
%         end
%         
%     end

%% establish
    function EstablishButton_Callback(~,~)
        BleDeviceEstablish();
    end

%% cancel establish
    function CancelEstablishButton_Callback(~,~)
        % [1] : <Tx> - 06:25:48.183
        % -Type           : 0x01 (Command)
        % -OpCode         : 0xFE0A (GAP_TerminateLinkRequest)
        % -Data Length    : 0x03 (3) byte(s)
        %  ConnHandle     : 0xFFFE (65534)
        %  DiscReason     : 0x13 (19) (Remote User Terminated Connection)
        % Dump(Tx):
        % 0000:01 0A FE 03 FE FF 13                            .......

        GAP_TerminateLinkRequest=['01';'0A';'FE';'03';'FE';'FF';'13'];

        if (disp_debug == 1)
            disp(GAP_TerminateLinkRequest);
        end
        
        TxDataDec = hex2dec(GAP_TerminateLinkRequest);
        fwrite(BleDongle, char(TxDataDec)');

        % read dummy
        pause(0.1);
        [~, ~, ~] = BleRecvPacket();
        
        % clear serial buffer
        while (BleDongle.BytesAvailable > 0)
            fread(BleDongle,1);
        end
    end

%% terminate link
    function TerminateLinkButton_Callback(~,~)

        % [1] : <Tx> - 06:56:12.651
        % -Type           : 0x01 (Command)
        % -OpCode         : 0xFE0A (GAP_TerminateLinkRequest)
        % -Data Length    : 0x03 (3) byte(s)
        %  ConnHandle     : 0x0000 (0)
        %  DiscReason     : 0x13 (19) (Remote User Terminated Connection)
        % Dump(Tx):
        % 0000:01 0A FE 03 00 00 13                            .......

        GAP_TerminateLinkRequest=['01';'0A';'FE';'03';'00';'00';'13'];

        if (disp_debug == 1)
            disp(GAP_TerminateLinkRequest);
        end
        
        TxDataDec = hex2dec(GAP_TerminateLinkRequest);
        fwrite(BleDongle, char(TxDataDec)');

        % read dummy
        pause(0.1);
        [~, ~, ~] = BleRecvPacket();
        
        % clear serial buffer
        while (BleDongle.BytesAvailable > 0)
            fread(BleDongle,1);
        end
        
    end

%% led on
    function LedOnButton_Callback(~,~)
        BleDeviceLedControl(1);
    end

%% led off
    function LedOffButton_Callback(~,~)
        BleDeviceLedControl(0);
    end

%% SWV param set
    function SwvParamSetButton_Callback(~,~)
        htext.String = 'Setting SWV parameters...';
        %address
        SWV_PARAM_ADDR_INIT_WAIT        = '0001';
        SWV_PARAM_ADDR_FREQ             = '0002';
%         SWV_PARAM_ADDR_PERIOD           = '0003';
%         SWV_PARAM_ADDR_HIGH_DURATION	= '0004';
%         SWV_PARAM_ADDR_INIT_VOLTAGE     = '0005';
%         SWV_PARAM_ADDR_FINAL_VOLTAGE	= '0006';
        SWV_PARAM_ADDR_AMPLITUDE        = '0007';
        SWV_PARAM_ADDR_STEP_VOLTAGE     = '0008';
        SWV_PARAM_ADDR_OFFSET_VOLTAGE	= '0009';
        SWV_PARAM_ADDR_INIT_VOLTAGE_OFFSET  = '000A';
        SWV_PARAM_ADDR_FINAL_VOLTAGE_OFFSET = '000B';
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_INIT_WAIT);
        SwvParamData = SWV_INIT_WAIT;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_FREQ);
        SwvParamData = SWV_FREQ;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
%         SwvParamAddr = hex2dec(SWV_PARAM_ADDR_INIT_VOLTAGE);
%         SwvParamData = SWV_INIT_VOLTAGE;
%         BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
%         pause(0.1);
%         
%         SwvParamAddr = hex2dec(SWV_PARAM_ADDR_FINAL_VOLTAGE);
%         SwvParamData = SWV_FINAL_VOLTAGE;
%         BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
%         pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_INIT_VOLTAGE_OFFSET);
        SwvParamData = SWV_INIT_VOLTAGE_OFFSET;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_FINAL_VOLTAGE_OFFSET);
        SwvParamData = SWV_FINAL_VOLTAGE_OFFSET;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);

        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_AMPLITUDE);
        SwvParamData = SWV_AMPLITUDE;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
                
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_STEP_VOLTAGE);
        SwvParamData = SWV_STEP_VOLTAGE;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_OFFSET_VOLTAGE);
        SwvParamData = SWV_OFFSET_VOLTAGE;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        htext.String = 'Setting done!!!';
    end

%% AMPERO param set
    function AmperoParamSetButton_Callback(~,~)
        htext.String = 'Setting Ampero parameters...';
        %addresses
        SWV_PARAM_ADDR_AMPERO_POINTS	= '000C';
        SWV_PARAM_ADDR_AMPERO_PERIOD    = '000D';
        SWV_PARAM_ADDR_AMPERO_OFFSET_VOLTAGE	= '000E';
        SWV_PARAM_ADDR_AMPERO_POTENTIAL_OFFSET  = '000F';
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_AMPERO_POINTS);
        SwvParamData = AMPERO_POINTS;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_AMPERO_PERIOD);
        SwvParamData = AMPERO_PERIOD;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);

        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_AMPERO_OFFSET_VOLTAGE);
        SwvParamData = AMPERO_OFFSET_VOLTAGE;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);
        
        SwvParamAddr = hex2dec(SWV_PARAM_ADDR_AMPERO_POTENTIAL_OFFSET);
        SwvParamData = AMPERO_POTENTIAL_OFFSET;
        BleDeviceSwvParamSet(SwvParamAddr, SwvParamData);
        pause(0.1);

        htext.String = 'Setting done!!!';
    end

%% SWV start
%     function SwvStartButton_Callback(~,~)
%         %BleDeviceLedControl(3);
%         BleDeviceLedControl(7);
%     end

%% SWV daq
%     function SwvDaqButton_Callback(~,~)
%         BleDeviceLedControl(4);
%     end

%% SWV meas
    function SwvMeasButton_Callback(~,~)

        %ax2‚ð•\Ž¦
        cla(ax2);
        cla(ax1);

        set(ax2,'visible','on');
        %show 2 figures
        set(ax1,'Position', [left_m, bot_m+ver_r+mid_m, col_r, ver_r]); 
        set(ax2,'Position', [left_m, bot_m, col_r, ver_r]);
        
        %file read
        htext.String = 'Update parameters';
        filereadbutton_Callback();
        pause(0.1);
        
        %param set
        SwvParamSetButton_Callback();
        pause(0.1);
        
        %init SWV
        htext.String = 'SWV Init';
        BleDeviceLedControl(2);
        pause(0.1);
        
        %start SWV
        %BleDeviceLedControl(3);
%         htext.String = 'SWV Start(05)';
%         BleDeviceLedControl(7);

%         htext.String = 'SWV Start(06)';
%         BleDeviceLedControl(9);

        htext.String = 'SWV Start(07)';
        BleDeviceLedControl(11);

        pause(0.1);

        %polling
        while (1)
            RecvLongChar = BleReadLongCharValue();
            htext.String = char(RecvLongChar');
            if ( strcmp(char(RecvLongChar(1:end-1)'),'SWV Done!!!') )
                disp(RecvLongChar')
                break;
            end
            pause(1);        
        end
        
        %"SWV Done!!!" Daq
        jtmp = 1;
        DataRecvFin = 0;
        while (1)
            htext.String = 'Getting data ...';
            %ADC data set
            BleDeviceLedControl(4);
            pause(0.01);
            %ƒf?[ƒ^Žó?M
            RecvLongChar = BleReadLongCharValue();
            RecvDataNum = length(RecvLongChar)/2;

            %header
            itmp = 1;
            AdcDataNum = RecvLongChar(2*itmp)*256+RecvLongChar(2*itmp-1);
            itmp = 2;
            AdcDataNumDisplayed = RecvLongChar(2*itmp)*256+RecvLongChar(2*itmp-1);

            %data
            if ( (RecvDataNum-2) >= (AdcDataNum-AdcDataNumDisplayed) )
                itmpmax = (AdcDataNum-AdcDataNumDisplayed) + 2;
                DataRecvFin = 1;
            else
                itmpmax = RecvDataNum;
            end
            
            %dataŠi”[
            for itmp=3:itmpmax
                AdcData(jtmp) = RecvLongChar(itmp*2)*256 + RecvLongChar(itmp*2-1);
                jtmp=jtmp+1;
            end
            
            if (DataRecvFin == 1)
                break;
            end
        end
        
        %dec2hex(AdcData')
        DataI1LSB = AdcData(2:2:end-1);
        DataI2LSB = AdcData(3:2:end);
        DataDeltaILSB = DataI1LSB - DataI2LSB;
        
        %DataE = ((1:length(DataDeltaILSB)) * SWV_STEP_VOLTAGE + SWV_INIT_VOLTAGE)/1000;
        %DataE = linspace(SWV_INIT_VOLTAGE,SWV_FINAL_VOLTAGE,length(DataDeltaILSB));
        if (SWV_INIT_VOLTAGE < SWV_FINAL_VOLTAGE)
            steptmp = SWV_STEP_VOLTAGE;
        else 
            steptmp = -SWV_STEP_VOLTAGE;
        end
        %DataE = ((1:length(DataDeltaILSB)) * steptmp + SWV_INIT_VOLTAGE)/1000;
        DataE = ((0:length(DataDeltaILSB)-1) * steptmp + SWV_INIT_VOLTAGE)/1000;
        
        htext.String = 'SWV Done!!!';
        
        DataDeltaI = (DataDeltaILSB*HW_LSB_mV) / HW_RIV;

        %plot
        set(ax1,'xtick',[]);
        set(ax1,'ytick',[]);
        %plot(ax1, AdcData, '-x');
        %plot(ax1, DataE, DataDeltaILSB, '-x');
        plot(ax1, DataE, DataDeltaI, '-x');
        xlim auto;
        ylim auto;
        set(ax1,'FontName','Arial','FontSize',16);
        set(ax1,'LineWidth', 1);
        xlabel(ax1,'E (V)','FontName','Arial');
        ylabel(ax1,'I (\muA)','FontName','Arial');
        %ylabel(ax1,'I (LSB)','FontName','Arial');
        
        set(ax2,'xtick',[]);
        set(ax2,'ytick',[]);
        plot(ax2, DataE, DataI1LSB, '-x', DataE, DataI2LSB, '-x');
        %hold on;
        %plot(ax2, DataE, DataI2, '-x');
        %hold off;
        xlim auto;
        ylim auto;
        set(ax2,'FontName','Arial','FontSize',16);
        set(ax2,'LineWidth', 1);
        xlabel(ax2,'E (V)','FontName','Arial');
        %ylabel(ax2,'I1,I2 (\muA)','FontName','Arial');
        ylabel(ax2,'I1,I2 (LSB)','FontName','Arial');
        
        %file output
        
        SWV_INIT_WAIT = 200;
        starttimetext = datestr(now,'yyyymmdd_HHMMSS');
        swvfilename = ['.\output\swv_outputdata_' starttimetext '.dat'];

        % output parameters
        strtmp = sprintf('--- Parameters');
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Initial wait time (10ms): %d\t',SWV_INIT_WAIT);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Frequency (Hz): %d\t',SWV_FREQ);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Initial voltage (mV): %d\t',SWV_INIT_VOLTAGE);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Final voltage (mV): %d\t',SWV_FINAL_VOLTAGE);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Amplitude (mV): %d\t',SWV_AMPLITUDE);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Step (mV): %d\t',SWV_STEP_VOLTAGE);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('Offset voltage (mV): %d\t',SWV_OFFSET_VOLTAGE);
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('-----');
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        
        % output header
        strtmp = sprintf('E(V)\tdI(uA)\tI1(LSB)\tI2(LSB)\tdI(LSB)');
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
                
        % output data
        dlmwrite(swvfilename, [DataE' DataDeltaI' DataI1LSB' DataI2LSB' DataDeltaILSB'], ... 
            '-append',  'delimiter', '\t', 'newline', 'pc');
    end

%% CV meas
    function CvMeasButton_Callback(~,~)

        %init CV(SPI, ADC)
        htext.String = 'SWV Init';
        BleDeviceLedControl(2);
        pause(0.1);
        
        %start CV
        htext.String = 'CV Start';
        BleDeviceLedControl(5);
        pause(0.1);

        %poling
        while (1)
            RecvLongChar = BleReadLongCharValue();
            htext.String = char(RecvLongChar');
            if ( strcmp(char(RecvLongChar(1:end-1)'),'CV Done!!!') )
                disp(RecvLongChar')
                break;
            end
            pause(1);        
        end
        
        %"CV Done!!!" Daq
        jtmp = 1;
        DataRecvFin = 0;
        while (1)
            %ADC data set
            BleDeviceLedControl(6);
            pause(0.01);
            %ƒf?[ƒ^Žó?M
            RecvLongChar = BleReadLongCharValue();
            RecvDataNum = length(RecvLongChar)/2;

            %header
            itmp = 1;
            AdcDataNum = RecvLongChar(2*itmp)*256+RecvLongChar(2*itmp-1);
            itmp = 2;
            AdcDataNumDisplayed = RecvLongChar(2*itmp)*256+RecvLongChar(2*itmp-1);

            %data
            if ( (RecvDataNum-2) >= (AdcDataNum-AdcDataNumDisplayed) )
                itmpmax = (AdcDataNum-AdcDataNumDisplayed) + 2;
                DataRecvFin = 1;
            else
                itmpmax = RecvDataNum;
            end
            
            %dataŠi”[
            for itmp=3:itmpmax
                AdcData(jtmp) = RecvLongChar(itmp*2)*256 + RecvLongChar(itmp*2-1);
                jtmp=jtmp+1;
            end
            
            if (DataRecvFin == 1)
                break;
            end
        end
        
        %dec2hex(AdcData')
        DataI = AdcData;
        
        CV_STEP_POTENTIAL = 5;
        CV_LOWER_POTENTIAL = 0;
        CV_UPPER_POTENTIAL = 800;
        
        DataE1 = ((1:length(DataI)/2) * CV_STEP_POTENTIAL + CV_LOWER_POTENTIAL)/1000;
        DataE2 = ( -(1:length(DataI)/2) * CV_STEP_POTENTIAL + CV_UPPER_POTENTIAL)/1000;
        
        DataE = [DataE1 DataE2];
        
        %plot
        set(ax1,'xtick',[]);
        set(ax1,'ytick',[]);
        %plot(ax1, AdcData, '-x');
        plot(ax1, DataE, DataI, '-x');
        xlim auto;
        ylim auto;
        set(ax1,'FontName','Arial','FontSize',16);
        set(ax1,'LineWidth', 1);
        xlabel(ax1,'E (V)','FontName','Arial');
        %ylabel(ax1,'I (\muA)','FontName','Arial');
        ylabel(ax1,'I (LSB)','FontName','Arial');
                
        %file output
        starttimetext = datestr(now,'yyyymmdd_HHMMSS');
        swvfilename = ['.\output\swv_outputdata_' starttimetext '.dat'];

        % output header
        strtmp = sprintf('E(V)\tI1(uA)\tI2(uA)\tdI(uA)');
        dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        dlmwrite(swvfilename, [DataE' DataI'], ... 
            '-append',  'delimiter', '\t', 'newline', 'pc');
    end
%% ChronoAmperometry meas
%Automatically restart the ampero meassurement after it has completed
    function ContinuousAmperoStartButton_Callback(~,~)
        continuousAmperoFlag = true;
        htext.String = 'Continuous amperometry starting...';
        AmperoButton_Callback();
    end
%% ChronoAmperometry meas
    function AmperoButton_Callback(~,~)

        %ax2‚ð”ñ•\Ž¦
        cla(ax2);
        set(ax2,'visible','off');
        %ax1‚ð‘å‚«‚­
        cla(ax1);
        set(ax1,'Position', [left_m, bot_m, col_r, ver_r*2+mid_m]);
        
        %file read
        htext.String = 'Update parameters';
        filereadbutton_Callback();
        pause(0.1);
        
        %param set
        AmperoParamSetButton_Callback();
        pause(0.1);

        %init CA(SPI, ADC)
        htext.String = 'HW Init';
        BleDeviceLedControl(2);
        pause(0.1);
        
        %start ampero
        htext.String = 'Chronoamperometry';
        BleDeviceLedControl(8);
        pause(0.1);

        AdcDataNumLast = 1;
        AdcData = [];
        IData = [];

        amperoStopFlag = 0;
        amperoCompleteFlag = false;
        %polling
        while (amperoStopFlag == 0)
            RecvLongChar = BleReadLongCharValue();
            htext.String = char(RecvLongChar');
            if ( strcmp(char(RecvLongChar(1:end-1)'),'Measuring Ampero!!!') )
                disp(RecvLongChar)
            end
            if ( strcmp(char(RecvLongChar(1)),'A' ) )  %ampero
                if ( strcmp(char(RecvLongChar(2)),'M' ) || strcmp(char(RecvLongChar(2)),'F' ) )   %measuring
                    AdcDataNum = RecvLongChar(4)*256+RecvLongChar(3);
                    jtmp = 3;
                    for itmp=AdcDataNumLast:AdcDataNum
                        AdcData(itmp) = RecvLongChar(jtmp*2)*256 + RecvLongChar(jtmp*2-1);
                        jtmp=jtmp+1;
                        IData(itmp) = (AdcData(itmp)*HW_LSB_mV - AMPERO_OFFSET_VOLTAGE) / HW_RIV;
                        IDataFilt = filter(AMPERO_RA_B, AMPERO_RA_A, IData);
                    end
                    AdcDataNumLast = AdcDataNum;
                    htext.String = 'Measuring Ampero ...';
                end
                if ( strcmp(char(RecvLongChar(1:2)'),'AF') )    %finished
                    disp('Chronoamperometry Done!!!')
                    htext.String = 'Chronoamperometry Done!!!';
                    amperoCompleteFlag = true;
                    break;
                end
            else
                htext.String = '---';
                %not amperometry
            end
            
            if (~isempty(AdcData))
                TimeData = AMPERO_PERIOD*(1:length(AdcData))/1000;
                %plot
                set(ax1,'xtick',[]);
                set(ax1,'ytick',[]);
                %plot(ax1, AdcData, '-x');
                plot(ax1, TimeData,IData, '-o', TimeData(AMPERO_RA_NUM:end),IDataFilt(AMPERO_RA_NUM:end), '-x');
                %plot(ax1, TimeData(AMPERO_RA_NUM:end),IDataFilt(AMPERO_RA_NUM:end), '-o');
                xlim auto;
                ylim auto;
                set(ax1,'FontName','Arial','FontSize',16);
                set(ax1,'LineWidth', 1);
                xlabel(ax1,'Time (s)','FontName','Arial');
                ylabel(ax1,'I (\muA)','FontName','Arial');
                
                %plot adc data
%                 set(ax2,'xtick',[]);
%                 set(ax2,'ytick',[]);
%                 plot(ax2, AdcData, '-x');
%                 plot(ax2, TimeData,AdcData, '-o');
%                 xlim auto;
%                 ylim auto;
%                 set(ax2,'FontName','Arial','FontSize',16);
%                 set(ax2,'LineWidth', 1);
%                 xlabel(ax2,'Time (s)','FontName','Arial');
%                 ylabel(ax2,'I (LSB)','FontName','Arial');
            end
            pause(1);
        end
        
        %Time data
        TimeData = AMPERO_PERIOD*(1:length(AdcData))/1000;
        
        %file output
        starttimetext = datestr(now,'yyyymmdd_HHMMSS');
        amperofilename = ['.\output\chronoamperometry_outputdata_' starttimetext '.dat'];

        strtmp = sprintf('--- Parameters');
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('measurement points: %d\t',AMPERO_POINTS);
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('period (ms): %d\t',AMPERO_PERIOD);
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('offset voltage (mV): %d\t',AMPERO_OFFSET_VOLTAGE);
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('potential (mV): %d\t',AMPERO_POTENTIAL);
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        strtmp = sprintf('-----');
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');

        % output header
        strtmp = sprintf('Time(s)\tI(uA)\tI(LSB)');
        dlmwrite(amperofilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
        
        % output data
        dlmwrite(amperofilename, [TimeData' IData' AdcData'], ... 
            '-append',  'delimiter', '\t', 'newline', 'pc');
    end

%% ChronoAmperometry stop
    function AmperoStopButton_Callback(~,~)

        %stop ampero
        htext.String = 'Chronoamperometry STOP';
        amperoStopFlag = 1;
        continuousAmperoFlag = false;
        amperoCompleteFlag = true;
        BleDeviceLedControl(10);
        pause(0.1);
   end



%% establish bluetooth
    function BleDeviceEstablish()
        disp('Establish link');
        % establish link
        % [19] : <Tx> - GAP_EstablishLinkRequest
        % PeerAddr       : 54:4A:16:5E:2B:9F
        % 01 09 FE 09 00 00 00 9F 2B 5E 16 4A 54
        % #2: 54 4A 16 75 77 CE
        
        % Launchpad device ID: CC:78:AB:87:6D:04
        
        switch (deviceID)
            case ('keyfob')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    '9F';'2B';'5E';'16';'4A';'54'];    %keyfob
            case ('proto2')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    'CE';'77';'75';'16';'4A';'54'];     %#2 prototype
            case ('proto3')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    '33';'77';'75';'16';'4A';'54'];     %#3 prototype
            case ('launchpad01')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    '04';'6D';'87';'AB';'78';'CC'];     %launchpad
            case ('ring01')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    'EC';'BF';'D8';'89';'71';'24'];     %ring01 24:71:89:D8:BF:EC
            case ('ring02')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    'FC';'BF';'D8';'89';'71';'24'];     %ring01 24:71:89:D8:BF:EC
            case ('hcar01')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    '3F';'AF';'09';'89';'71';'24'];     %HCAR01 24:71:89:09:AF:3F
            case ('flex01')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    'E9';'A3';'1D';'89';'71';'24'];     %flex01 24:71:89:1D:A3:E9
            case ('flexA01')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    'D9';'A3';'1D';'89';'71';'24'];     %flex01 24:71:89:1D:A3:D9
           case ('ampJ18_00')   %dev kit
            GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                '85';'DF';'7E';'AB';'78';'CC'];         %ampJ18_00 CC:78:AB:7E:DF:85                
           case ('ampJ18_01')
            GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                '8C';'20';'A6';'2D';'07';'98'];         %ampJ18_01 98:07:2D:A6:20:8C
            case ('ampJ18_02')
                GAP_EstablishLinkRequest=['01';'09';'FE';'09';'00';'00';'00'; ... 
                    '7F';'1F';'A6';'2D';'07';'98'];     %ampJ18_02 98:07:2D:A6:1F:7F
        end

%         if (disp_debug == 1)
% %             GAP_EstablishLinkRequest;
%         end
        
        TxDataDec = hex2dec(GAP_EstablishLinkRequest);
        fwrite(BleDongle, char(TxDataDec)');

        % [20] : <Rx> - GAP_HCI_ExtentionCommandStatus (9 Bytes)
        % 04 FF 06 7F 06 00 09 FE 00

        [RecvData, ~] = fread(BleDongle,9);
        if (disp_debug)
        RecvDataHex = dec2hex(RecvData);
        disp(RecvDataHex);
        end

        % check the results
        if ( RecvData(8) == hex2dec('FE') && ...   %command
             RecvData(7) == hex2dec('09') ) %command
            if ( RecvData(6) == hex2dec('00') )   %status:success
                disp('Connection OK');
                htext.String = 'Connection OK';
                [~, ~, ~] = BleRecvPacket();
                % [RecvData2, Count2] = fread(BleDongle,22);
                % RecvDataHex2 = dec2hex(RecvData2);
                % RecvDataHex2 = RecvDataHex2'
                % if (Count2 < 1)
                %     disp('No response from device');
                %     htext.String = 'No response from device';
                % end
            else
                disp('Connection status: Unsccess');
                htext.String = 'Error connecting!';

            end
            
        else
            disp('No device found');
        end
        
        % -Type           : 0x04 (Event)
        % -EventCode      : 0x00FF (Event)
        % -Data Length    : 0x0B (11) bytes(s)
        %  Event          : 0x0607 (1543) (GAP_LinkParamUpdate)
        %  Status         : 0x00 (0) (Success)
        %  ConnHandle     : 0x0000 (0)
        %  ConnInterval   : 0x0320 (800)
        %  ConnLatency    : 0x0000 (0)
        %  ConnTimeout    : 0x03E8 (1000)
        % Dump(Rx):
        % 0000:04 FF 0B 07 06 00 00 00 20 03 00 00 E8 03       ........ .....
        % 
        % for GAP_LinkParamUpdate read dummy
        pause(0.1);
        [~, ~, ~] = BleRecvPacket();

    end

%% start daq
%     function BleDeviceDaqStart()
%         % clear serial buffer
%         while (BleDongle.BytesAvailable > 0)
%             fread(BleDongle,1);
%         end        
%         
%         disp('Accelerometer X notification enabled');
%         % write to ble device
%         WriteAddress	= '003C';   % accelerometer X axis notification enable
%         WriteValue      = '0001';   % enable
%         WriteData = MakePacket_GATT_WriteCharValue(WriteAddress,WriteValue);
%         WriteData;
%         fwrite(BleDongle, char(WriteData));
%         
%         % read 2 times. ToDo: check status etc. 
%         [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket();
%         % check the results
%         if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
%              RecvDataBody(4) == hex2dec('92') ) %command
%             if ( RecvDataBody(3) == hex2dec('00') )   %status:success
%                 disp('Notification enable command OK');
%                 [RecvDataHdr2, RecvDataBody2, RecvError] = BleRecvPacket();
%                 if (RecvDataHdr2 == 0)
%                     htext.String = 'No response from Device';
%                 end
%             end
%         else
%             disp('Enable command NG');
%         end
% 
%         disp('Accelerometer Y notification enabled');
%         % write to ble device
%         WriteAddress	= '0040';   % accelerometer Y axis notification enable
%         WriteValue      = '0001';   % enable
%         WriteData = MakePacket_GATT_WriteCharValue(WriteAddress,WriteValue);
%         WriteData;
%         fwrite(BleDongle, char(WriteData));
%         
%         % read 2 times. ToDo: check status etc. 
%         [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket();
%         % check the results
%         if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
%              RecvDataBody(4) == hex2dec('92') ) %command
%             if ( RecvDataBody(3) == hex2dec('00') )   %status:success
%                 disp('Notification enable command OK');
%                 [RecvDataHdr2, RecvDataBody2, RecvError] = BleRecvPacket();
%                 if (RecvDataHdr2 == 0)
%                     htext.String = 'No response from Device';
%                 end
%             end
%         else
%             disp('Enable command NG');
%         end
% 
%         disp('Accelerometer Z notification enabled');
%         % write to ble device
%         WriteAddress	= '0044';   % accelerometer Y axis notification enable
%         WriteValue      = '0001';   % enable
%         WriteData = MakePacket_GATT_WriteCharValue(WriteAddress,WriteValue);
%         WriteData;
%         fwrite(BleDongle, char(WriteData));
%         
%         % read 2 times. ToDo: check status etc. 
%         [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket();
%         % check the results
%         if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
%              RecvDataBody(4) == hex2dec('92') ) %command
%             if ( RecvDataBody(3) == hex2dec('00') )   %status:success
%                 disp('Notification enable command OK');
%                 [RecvDataHdr2, RecvDataBody2, RecvError] = BleRecvPacket();
%                 if (RecvDataHdr2 == 0)
%                     htext.String = 'No response from Device';
%                 end
%             end
%         else
%             disp('Enable command NG');
%         end
%         
%         disp('Accelerometer enabled');
%         % write to ble device
%         WriteAddress	= '0035';   % accelerometer enable
%         WriteValue      = '0001';   % enable
%         WriteData = MakePacket_GATT_WriteCharValue(WriteAddress,WriteValue);
%         if (disp_debug == 1) 
%             WriteDataHex = dec2hex(WriteData);
%             WriteDataHex = WriteDataHex'
%         end
%         fwrite(BleDongle, char(WriteData));
% 
% %         GATT_WriteCharValue=['01';'92';'FD';'06';'00';'00';'34';'00';'01';'00'];
% %         TxDataDec = hex2dec(GATT_WriteCharValue);
% %         fwrite(BleDongle, char(TxDataDec)');
%         
%         % read 2 times. ToDo: check status etc. 
%         [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket();
% 
%         % check the results
%         if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
%              RecvDataBody(4) == hex2dec('92') ) %command
%             if ( RecvDataBody(3) == hex2dec('00') )   %status:success
%                 disp('Enable command OK');
%                 [RecvDataHdr2, RecvDataBody2, RecvError] = BleRecvPacket();
%                 if (RecvDataHdr2 == 0)
%                     htext.String = 'No response from Device';
%                 end
%             end
%         else
%             disp('Enable command NG');
%         end
%     end

%% Led control
    function BleDeviceLedControl(LedControlValue)
        % clear serial buffer
        while (BleDongle.BytesAvailable > 0)
            fread(BleDongle,1);
        end        
        
        % write to ble device
        WriteAddress	= '001E';   % LED
        switch(LedControlValue)
            case 0
                disp('LED Off');
                WriteValue      = '00';   % disable
            case 1
                disp('LED On');
                WriteValue      = '01';   % enable
            case 2
                disp('SPI ADC Init');
                WriteValue      = '02';   % enable
            case 3
                disp('SWV start');
                WriteValue      = '03';   % enable
            case 4
                disp('SWV data acq');
                WriteValue      = '04';   % enable
            case 5
                disp('CV start');
                WriteValue      = '05';   % enable
            case 6
                disp('CV data acq');
                WriteValue      = '06';   % enable
            case 7
                disp('SWV start(05)');
                WriteValue      = '07';   % enable
            case 8
                disp('ChronoAmperometry');
                WriteValue      = '08';   % enable
            case 9
                disp('SWV start(06)');
                WriteValue      = '09';   % enable
            case 10
                disp('ChronoAmperometry STOP');
                WriteValue      = '0A';   % enable
            case 11
                disp('SWV start(07)');
                WriteValue      = '0B';   % enable
            otherwise
        end

        WriteData = MakePacket_GATT_WriteCharValue05(WriteAddress,WriteValue);
%         WriteData;
        fwrite(BleDongle, char(WriteData));
        
        % read 2 times. ToDo: check status etc. 
        [~, RecvDataBody, ~] = BleRecvPacket();
        % check the results
        if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
             RecvDataBody(4) == hex2dec('92') ) %command
            if ( RecvDataBody(3) == hex2dec('00') )   %status:success
                disp('LED control command OK');
                [RecvDataHdr2, ~, ~] = BleRecvPacket();
                if (RecvDataHdr2 == 0)
                    htext.String = 'No response from Device';
                end
            end
        else
            disp('LED control command NG');
        end       
    end

%% SWV Param Set
    function BleDeviceSwvParamSet(SwvParamAddr, SwvParamData)
        % clear serial buffer
        while (BleDongle.BytesAvailable > 0)
            fread(BleDongle,1);
        end

        % write to ble device
        WriteAddress	= '0020';   % LED1
        
        WriteValue1 = char(dec2hex(SwvParamAddr,4));
        WriteValue2 = char(dec2hex(SwvParamData,4));
        WriteValue = [WriteValue1 WriteValue2];
        
        WriteData = MakePacket_GATT_WriteCharValue08(WriteAddress,WriteValue);
%         WriteData;
        fwrite(BleDongle, char(WriteData));
        
        % read 2 times. ToDo: check status etc. 
        [~, RecvDataBody, ~] = BleRecvPacket();
        % check the results
        if ( RecvDataBody(5) == hex2dec('FD') && ...   %command
             RecvDataBody(4) == hex2dec('92') ) %command
            if ( RecvDataBody(3) == hex2dec('00') )   %status:success
                disp('Swv param set command OK');
                [RecvDataHdr2, ~, ~] = BleRecvPacket();
                if (RecvDataHdr2 == 0)
                    htext.String = 'No response from Device';
                end
            end
        else
            disp('Swv param set command NG');
        end       
    end

%% Read long char
    function RecvLongChar = BleReadLongCharValue()

        % [5] : <Tx> - 10:23:04.829
        % -Type           : 0x01 (Command)
        % -OpCode         : 0xFD8C (GATT_ReadLongCharValue)
        % -Data Length    : 0x06 (6) byte(s)
        %  ConnHandle     : 0x0000 (0)
        %  Handle         : 0x002A (42)
        %  Offset         : 0x0000 (0)
        % Dump(Tx):
        % 0000:01 8C FD 06 00 00 2A 00 00 00                   ......*...

        GATT_ReadLongCharValue=['01';'8C';'FD';'06';'00';'00';'2A';'00';'00';'00'];

%         if (disp_debug == 1)
%             disp(GATT_ReadLongCharValue);
%         end
        
        TxDataDec = hex2dec(GATT_ReadLongCharValue);
        fwrite(BleDongle, char(TxDataDec)');

        % [9] : <Rx> - 10:23:05.249
        % -Type           : 0x04 (Event)
        % -EventCode      : 0x00FF (HCI_LE_ExtEvent)
        % -Data Length    : 0x06 (6) bytes(s)
        %  Event          : 0x050D (1293) (ATT_ReadBlobRsp)
        %  Status         : 0x1A (26) (The Procedure Is Completed)
        %  ConnHandle     : 0x0000 (0)
        %  PduLen         : 0x00 (0)
        % Dump(Rx):
        % 0000:04 FF 06 0D 05 1A 00 00 00                      .........        

        %read
        while (1)
            [RecvDataHdr, RecvDataBody, ~] = BleRecvPacket();
            if( RecvDataHdr(1) == hex2dec('04') && ...	%DataType(Event)
                RecvDataHdr(2) == hex2dec('FF') && ...   %EventCode
                RecvDataBody(1) == hex2dec('0D') && ...
                RecvDataBody(2) == hex2dec('05') )
            
                if( RecvDataHdr(3) == hex2dec('06') && ...  %Data Length
                    RecvDataBody(3) == hex2dec('1A') ) %Status ?I—¹
                    %disp('end of data');
                    break;
                else
                    %disp('data body');
                    if (exist('RecvDataTmp','var'))
                        RecvDataTmp = vertcat(RecvDataTmp,RecvDataBody(7:end));
                    else
                        RecvDataTmp = RecvDataBody(7:end);
                    end
                end
            end
        end
        RecvLongChar = RecvDataTmp;
    end

%% make packet GATT_WriteCharValue
%     function WriteData = MakePacket_GATT_WriteCharValue(WriteAddress, WriteValue)
%         WriteDataType        = hex2dec('01');
%         WriteDataOpCode1     = hex2dec('FD');
%         WriteDataOpCode2     = hex2dec('92');
%         WriteDataDataLength	 = hex2dec('06');
%         WriteDataConnHandle1 = hex2dec('00');
%         WriteDataConnHandle2 = hex2dec('00');
%         WriteDataHandle1     = hex2dec(WriteAddress(1:2));
%         WriteDataHandle2     = hex2dec(WriteAddress(3:4));
%         WriteDataValue1      = hex2dec(WriteValue(1:2));
%         WriteDataValue2      = hex2dec(WriteValue(3:4));
% 
%         WriteData = uint8([WriteDataType, WriteDataOpCode2, ...
%                            WriteDataOpCode1, WriteDataDataLength, ...
%                            WriteDataConnHandle2, WriteDataConnHandle1, ...
%                            WriteDataHandle2, WriteDataHandle1, ...
%                            WriteDataValue2, WriteDataValue1]);
%     end

%% make packet GATT_WriteCharValue
    function WriteData = MakePacket_GATT_WriteCharValue05(WriteAddress, WriteValue)
        WriteDataType        = hex2dec('01');
        WriteDataOpCode1     = hex2dec('FD');
        WriteDataOpCode2     = hex2dec('92');
        WriteDataDataLength	 = hex2dec('05');
        WriteDataConnHandle1 = hex2dec('00');
        WriteDataConnHandle2 = hex2dec('00');
        WriteDataHandle1     = hex2dec(WriteAddress(1:2));
        WriteDataHandle2     = hex2dec(WriteAddress(3:4));
        WriteDataValue1      = hex2dec(WriteValue(1:2));
        %WriteDataValue2      = hex2dec(WriteValue(3:4));

        WriteData = uint8([WriteDataType, WriteDataOpCode2, ...
                           WriteDataOpCode1, WriteDataDataLength, ...
                           WriteDataConnHandle2, WriteDataConnHandle1, ...
                           WriteDataHandle2, WriteDataHandle1, ...
                           WriteDataValue1]);
    end

%% make packet GATT_WriteCharValue
    function WriteData = MakePacket_GATT_WriteCharValue08(WriteAddress, WriteValue)
        WriteDataType        = hex2dec('01');
        WriteDataOpCode1     = hex2dec('FD');
        WriteDataOpCode2     = hex2dec('92');
        WriteDataDataLength	 = hex2dec('08');
        WriteDataConnHandle1 = hex2dec('00');
        WriteDataConnHandle2 = hex2dec('00');
        WriteDataHandle1     = hex2dec(WriteAddress(1:2));
        WriteDataHandle2     = hex2dec(WriteAddress(3:4));
        WriteDataValue1      = hex2dec(WriteValue(1:2));
        WriteDataValue2      = hex2dec(WriteValue(3:4));
        WriteDataValue3      = hex2dec(WriteValue(5:6));
        WriteDataValue4      = hex2dec(WriteValue(7:8));

        WriteData = uint8([WriteDataType, WriteDataOpCode2, ...
                           WriteDataOpCode1, WriteDataDataLength, ...
                           WriteDataConnHandle2, WriteDataConnHandle1, ...
                           WriteDataHandle2, WriteDataHandle1, ...
                           WriteDataValue2, WriteDataValue1, ...
                           WriteDataValue4, WriteDataValue3]);
       disp(WriteData);
    end


%% receive packet
    function [RecvDataHdr, RecvDataBody, RecvError] = BleRecvPacket()
        % receive packet
        [RecvDataHdr, Count] = fread(BleDongle,3);
        if (disp_debug)        
            RecvDataHdrHex = dec2hex(RecvDataHdr);
            disp(RecvDataHdrHex);
        end
        if(Count<3)
            RecvDataHdr = 0;
            RecvDataBody = 0;
            RecvError = 1;
        else
%             ReadDataType        = RecvDataHdr(1);
%             ReadDataEventCode	= RecvDataHdr(2);
            ReadDataDataLength	= RecvDataHdr(3);
            [RecvDataBody, ~] = fread(BleDongle,ReadDataDataLength);
            RecvDataBodyHex = dec2hex(RecvDataBody,2);
            if (disp_debug == 1)
                disp(RecvDataBodyHex);
            end
            RecvError = 0;
        end
    end

%% stop
%     function stopbutton_Callback(~,~)
%         bool_stop = 1;
% 
%         % fclose(BleDevice);
% 
%     end

%% Runtime error
%     function daqrterr_Callback(~,~)
%         %‹­?§“I‚ÉƒXƒgƒbƒv‚µ?A?Ä“xƒXƒ^?[ƒg
%         pause(0.1);
%         bool_stop = 0;
%     end

%% Parameter file open
    function fileopenbutton_Callback(~,~)
        dos(['notepad ' paramfile '&']);
    end

%% Parameter file read
    function filereadbutton_Callback(~,~)
        fpid = fopen(paramfile,'r');
        tmp1 = textscan(fpid, '%s %s', 'Delimiter','\t');
        fclose(fpid);

        param = tmp1{1};

        %General
%         dummy               = param(1);
        ComName             = char(param(2)); %COMƒ|?[ƒg
%         BleDeviceID         = param(3);  
        deviceID            = char(param(4));    %ƒfƒoƒCƒXID
%         dummy               = param(5);
        
        %SWV
%         dummy               = param(6);        
        SWV_INIT_WAIT       = str2double(param(7));     % Initial wait time (ms)
        SWV_FREQ            = str2double(param(8));     % Frequency (Hz)
        SWV_INIT_VOLTAGE	= str2double(param(9));     % Initial voltage (mV)
        SWV_FINAL_VOLTAGE	= str2double(param(10));    % Final voltage (mV)
        SWV_AMPLITUDE       = str2double(param(11));    % Amplitude (mV)
        SWV_STEP_VOLTAGE	= str2double(param(12));    % Step (mV)
        SWV_OFFSET_VOLTAGE	= str2double(param(13));	% Offset voltage (mV)

        SWV_INIT_VOLTAGE_OFFSET  = SWV_INIT_VOLTAGE + SWV_OFFSET_VOLTAGE;
        SWV_FINAL_VOLTAGE_OFFSET = SWV_FINAL_VOLTAGE + SWV_OFFSET_VOLTAGE;
%         dummy               = param(14);
        
        %Chronoamperometry
%         dummy               = param(15);
        AMPERO_POINTS       = str2double(param(16));    % measurement points
        AMPERO_PERIOD       = str2double(param(17));    % period in ms
        AMPERO_OFFSET_VOLTAGE   = str2double(param(18));    % offset voltage in mV
        AMPERO_POTENTIAL	= str2double(param(19));    % potential in mV
        AMPERO_RA_NUM = str2double(param(20));
        AMPERO_RA_A = AMPERO_RA_NUM;
        AMPERO_RA_B = ones(1,AMPERO_RA_NUM);
        AMPERO_POTENTIAL_OFFSET = AMPERO_POTENTIAL + AMPERO_OFFSET_VOLTAGE;
        
%         dummy               = param(21);
        %Hardware paremeters
%         dummy               = param(22);
        HW_ADC_VREF         = str2double(param(23));    % Vref in mV
        HW_ADC_RESOLUTION	= str2double(param(24));    % ADC resolution (bits)
        HW_RIV           = str2double(param(25));    % Transimpedance gain (kOhm)
        
        HW_LSB_mV = HW_ADC_VREF/(2^HW_ADC_RESOLUTION);  %1LSB in mV
        
    end


%% close
    function closebutton_Callback(~,~)
        bool_close = 1;
        close;
    end

end
