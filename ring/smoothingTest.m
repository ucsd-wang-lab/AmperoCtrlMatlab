%Smoothing test

%Read in data
filePath = 'C:\Lab\Ring\testing\data\';
fileName = 'swv_outputdata_20190306_155648.dat';
A = importdata(strcat(filePath, fileName));

data_potential = A.data(:,1);
data_delta = A.data(:,2);
data_I1_cnts = A.data(:,3);
data_I2_cnts = A.data(:,4);

fig = figure();
subplot(2,1,1);
plot(data_potential, data_delta);
xlim auto;
ylim auto;
xlabel('E (V)','FontName','Arial');
ylabel('I (\muA)','FontName','Arial');

subplot(2,1,2);
plot(data_potential, smoothdata(data_delta));
xlim auto;
ylim auto;
xlabel('E (V)','FontName','Arial');
ylabel('I (\muA)','FontName','Arial');
%Smooth data
%Plot data
%Save data
% 
% %dec2hex(AdcData')
% DataI1LSB = AdcData(2:2:end-1);
% DataI2LSB = AdcData(3:2:end);
% DataDeltaILSB = DataI1LSB - DataI2LSB;
% 
% %DataE = ((1:length(DataDeltaILSB)) * SWV_STEP_VOLTAGE + SWV_INIT_VOLTAGE)/1000;
% %DataE = linspace(SWV_INIT_VOLTAGE,SWV_FINAL_VOLTAGE,length(DataDeltaILSB));
% if (SWV_INIT_VOLTAGE < SWV_FINAL_VOLTAGE)
%     steptmp = SWV_STEP_VOLTAGE;
% else 
%     steptmp = -SWV_STEP_VOLTAGE;
% end
% %DataE = ((1:length(DataDeltaILSB)) * steptmp + SWV_INIT_VOLTAGE)/1000;
% DataE = ((0:length(DataDeltaILSB)-1) * steptmp + SWV_INIT_VOLTAGE)/1000;
% 
% 
% htext.String = 'SWV Done!!!';
% 
% DataDeltaI = (DataDeltaILSB*HW_LSB_mV) / HW_RIV;
% 
% %plot
% set(ax1,'xtick',[]);
% set(ax1,'ytick',[]);
% %plot(ax1, AdcData, '-x');
% %plot(ax1, DataE, DataDeltaILSB, '-x');
% plot(ax1, DataE, DataDeltaI, '-x');
% xlim auto;
% ylim auto;
% set(ax1,'FontName','Arial','FontSize',16);
% set(ax1,'LineWidth', 1);
% xlabel(ax1,'E (V)','FontName','Arial');
% ylabel(ax1,'I (\muA)','FontName','Arial');
% %ylabel(ax1,'I (LSB)','FontName','Arial');
% 
% set(ax2,'xtick',[]);
% set(ax2,'ytick',[]);
% plot(ax2, DataE, DataI1LSB, '-x', DataE, DataI2LSB, '-x');
% %hold on;
% %plot(ax2, DataE, DataI2, '-x');
% %hold off;
% xlim auto;
% ylim auto;
% set(ax2,'FontName','Arial','FontSize',16);
% set(ax2,'LineWidth', 1);
% xlabel(ax2,'E (V)','FontName','Arial');
% %ylabel(ax2,'I1,I2 (\muA)','FontName','Arial');
% ylabel(ax2,'I1,I2 (LSB)','FontName','Arial');
% 
% %file output
% 
% SWV_INIT_WAIT = 200;
% starttimetext = datestr(now,'yyyymmdd_HHMMSS');
% swvfilename = ['.\output\swv_outputdata_' starttimetext '.dat'];
% 
% % output parameters
% strtmp = sprintf('--- Parameters');
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Initial wait time (10ms): %d\t',SWV_INIT_WAIT);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Frequency (Hz): %d\t',SWV_FREQ);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Initial voltage (mV): %d\t',SWV_INIT_VOLTAGE);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Final voltage (mV): %d\t',SWV_FINAL_VOLTAGE);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Amplitude (mV): %d\t',SWV_AMPLITUDE);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Step (mV): %d\t',SWV_STEP_VOLTAGE);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('Offset voltage (mV): %d\t',SWV_OFFSET_VOLTAGE);
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% strtmp = sprintf('-----');
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% 
% % output header
% strtmp = sprintf('E(V)\tdI(uA)\tI1(LSB)\tI2(LSB)\tdI(LSB)');
% dlmwrite(swvfilename, strtmp, '-append', 'delimiter', '', 'newline', 'pc');
% 
% % output data
% dlmwrite(swvfilename, [DataE' DataDeltaI' DataI1LSB' DataI2LSB' DataDeltaILSB'], ... 
%     '-append',  'delimiter', '\t', 'newline', 'pc');