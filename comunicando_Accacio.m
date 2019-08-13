%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% --- Lendo placa por Mavlink --- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fclose( s_port );
clear; clc; close all; instrreset;

addpath('/home/accacio/MAVLink_Matlab/ardupilotmega')
addpath('/home/accacio/MAVLink_Matlab/common')

%% Exemplo a partir daqui

%% CHANGE THESE
serial_port_name = '/dev/ttyACM1';
serial_baud_rate = 115200;

%% DO NOT CHANGE BELOW THIS POINT
fprintf('\n connecting...');

parse = parser();

% Open serial connection
s_port = serial( serial_port_name );
s_port.BaudRate = serial_baud_rate;
s_port.InputBufferSize = 10000;

fopen( s_port );
flushinput( s_port );

%%

fprintf('\n connected...\n');
% pause
t = tic;

% Run for [tsim] seconds

tsim = 1000;
lat = []; lon = []; hdg = [];
vx  = []; vy  = []; vz  = [];

while toc(t) <  tsim
    
    if s_port.BytesAvailable > 1000
        b = fread( s_port, s_port.BytesAvailable );
   
        [parse, msg] = parse.byte_stream(b');        
       
        for i = 1:length( msg )
            fprintf( 'Msg (%d) %s\n', msg{i}.get_msgid(), class(msg{i}) );
            
            if msg{i}.get_msgid() == 33
                px4 = msg{i};
%                 fprintf('Latitude: %.4f \t Longitude: %.4f\n', px4.get_prop_lat(), px4.get_prop_lon())
%                 fprintf('Time:     %.4f \t Alt      : %.4f\n', px4.get_prop_time_boot_ms(), px4.get_prop_alt())
%                 fprintf('Vx  :     %.4f \t Rel Alt:   %.4f\n', px4.get_prop_vx(), px4.get_prop_relative_alt())
%                 fprintf('Vy  :     %.4f \t Vz     :   %.4f\n', px4.get_prop_vy(), px4.get_prop_vz())
%                 fprintf('Heading:  %.4f \n\n\n', px4.get_prop_hdg)
                
                %[vx vy vyaw]                
                    vx      = [vx, px4.get_prop_vx()];
                    vy      = [vy, px4.get_prop_vy()];
                    %vyaw    = [vyaw px4.get_prop_hdg()];
                
                %[lat lon hdg]
                    lat = [lat, px4.get_prop_lat()];
                    lon = [lon, px4.get_prop_lon()];
                    hdg = [hdg, px4.get_prop_hdg()];
                    
            elseif msg{i}.get_msgid() == 35
                fprintf('Channel 06: %.4f \n', get_prop_chan6_raw())
                fprintf('Time (ms):  %.4f\n', px4.get_prop_time_boot_ms())
            end
        end
        
        stats = parse.get_stats();
        fprintf( 'Total Msg: %d\t Msg Errors: %d\t Unknown Msg:%d\n', ...
                                stats.total, stats.errors, stats.unknown );
    end
end

fclose( s_port );

%% Plots

subplot(321),plot(lat,'linewidth',2), grid minor, ylabel('Lat')
subplot(323),plot(lon,'linewidth',2), grid minor, ylabel('Lon')
subplot(325),plot(hdg/100,'linewidth',2), grid minor, ylabel('\psi [deg]')

subplot(322),plot(vx,'linewidth',2), grid minor, ylabel(' v_{x} [m/s]')
subplot(324),plot(vy,'linewidth',2), grid minor, ylabel(' v_{y} [m/s]')
% subplot(326),plot(hdg/100,'linewidth',2), grid minor

