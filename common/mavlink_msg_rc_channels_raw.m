% RC_CHANNELS_RAW ( #35 )
% The RAW values of the RC channels received. The standard PPM modulation is as follows: 1000 microseconds: 0%, 2000 microseconds: 100%. A value of UINT16_MAX implies the channel is unused. Individual receivers/transmitters might violate this specification..  (ACCACIO 12/08/2019)
classdef mavlink_msg_rc_channels_raw < mavlink_msg
    properties (SetAccess = protected)
        prop_time_boot_ms       = uint32 ( zeros(1,1 ) ); % 4 bytes
        prop_chan1_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan2_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan3_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan4_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan5_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan6_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan7_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_chan8_raw          = uint16 ( zeros(1,1 ) ); % 2
        prop_port               = uint8  ( zeros(1,1 ) ); % 1 
        prop_rssi               = uint8  ( zeros(1,1 ) ); % 1
end
    
    methods
        
        function obj = mavlink_msg_rc_channels_raw()
            len       = uint8( 22  ); % 1*4  + 8*2 + 2*1!
            msgid     = uint8( 35  ); % ver Common Messages - MavLink
            crc_extra = uint8( 104 ); % #define MAVLINK_MESSAGE_CRCS {50, 124, 137, 0, 237, 217, 104, 119, 0, 0, 0, 89, 0, 0, 0, 0, 0, 0, 0, 0, 214, 159, 220, 168, 24, 23, 170, 144, 67, 115, 39, 246, 185, 104, 237, 244, 222, 212, 9, 254, 230, 28, 28, 132, 221, 232, 11, 153, 41, 39, 214, 223, 141, 33, 15, 3, 100, 24, 239, 238, 30, 200, 183, 0, 130, 0, 148, 21, 0, 52, 124, 0, 0, 0, 20, 0, 152, 143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 183, 63, 54, 0, 0, 0, 0, 0, 0, 0, 175, 102, 158, 208, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 204, 49, 170, 44, 83, 46, 0}#endif
            
            obj = obj@mavlink_msg( msgid, len, crc_extra );
        end
        
        %% Separa os bytes de entrada
        function obj = split_payload( obj )
            obj = split_payload@mavlink_msg( obj );
        
            obj.prop_time_boot_ms         = obj.cast_from_bytes( obj.mav_payload(  1:4  ), 'uint32' );
            obj.prop_chan1_raw            = obj.cast_from_bytes( obj.mav_payload(  5:6  ), 'uint16' );
            obj.prop_chan2_raw            = obj.cast_from_bytes( obj.mav_payload(  7:8 ),  'uint16' );
            obj.prop_chan3_raw            = obj.cast_from_bytes( obj.mav_payload(  9:10 ), 'uint16' );
            obj.prop_chan4_raw            = obj.cast_from_bytes( obj.mav_payload( 11:12 ), 'uint16' );
            obj.prop_chan5_raw            = obj.cast_from_bytes( obj.mav_payload( 13:14 ), 'uint16' );
            obj.prop_chan6_raw            = obj.cast_from_bytes( obj.mav_payload( 15:16 ), 'uint16' );
            obj.prop_chan7_raw            = obj.cast_from_bytes( obj.mav_payload( 17:18 ), 'uint16' );
            obj.prop_chan8_raw            = obj.cast_from_bytes( obj.mav_payload( 19:20 ), 'uint16' );            
            obj.prop_port                 = obj.cast_from_bytes( obj.mav_payload( 21:21 ), 'uint8' );
            obj.prop_rssi                 = obj.cast_from_bytes( obj.mav_payload( 22:22 ), 'uint8' );
            
        end
        
        %% Empacota em bytes para enviar
        function obj = pack( obj ) 
            obj.mav_payload(  1:4  ) = obj.cast_to_bytes( obj.prop_time_boot_ms ); 
            obj.mav_payload(  5:6  ) = obj.cast_to_bytes( obj.prop_chan1_raw  ); 
            obj.mav_payload(  7:8 )  = obj.cast_to_bytes( obj.prop_chan2_raw  ); 
            obj.mav_payload(  9:10 ) = obj.cast_to_bytes( obj.prop_chan3_raw  ); 
            obj.mav_payload( 11:12 ) = obj.cast_to_bytes( obj.prop_chan4_raw ); 
            obj.mav_payload( 13:14 ) = obj.cast_to_bytes( obj.prop_chan5_raw );            
            obj.mav_payload( 15:16 ) = obj.cast_to_bytes( obj.prop_chan6_raw );            
            obj.mav_payload( 17:18 ) = obj.cast_to_bytes( obj.prop_chan7_raw );            
            obj.mav_payload( 19:20 ) = obj.cast_to_bytes( obj.prop_chan8_raw );              
            obj.mav_payload( 21:21 ) = obj.cast_to_bytes( obj.prop_port );  
            obj.mav_payload( 22:22 ) = obj.cast_to_bytes( obj.prop_rssi );  
            
            obj = pack@mavlink_msg( obj  );
        end
        
%% Gets e sets das propriedades em alto nivel
        
        %% time_boot_ms
        function obj = set_prop_time_boot_ms( obj, val )
            obj.prop_time_boot_ms = obj.validate_input( val, 'uint32', 1 );
        end
        
        function val = get_prop_time_boot_ms( obj )
            val = obj.prop_time_boot_ms;
        end
        %% ch 01
        function obj = set_prop_chan1_raw( obj, val )
            obj.prop_chan1_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan1_raw( obj )
            val = obj.prop_chan1_raw;
        end
        %% ch 02
        function obj = set_prop_chan2_raw( obj, val )
            obj.prop_chan2_raw= obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan2_raw( obj )
            val = obj.prop_chan2_raw;
        end
        %% ch 03
        function obj = set_prop_chan3_raw( obj, val )
            obj.prop_chan3_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan3_raw( obj )
            val = obj.prop_chan3_raw;
        end       
        %% ch 04
        function obj = set_prop_chan4_raw( obj, val )
            obj.prop_chan4_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan4_raw( obj )
            val = obj.prop_chan4_raw;
        end
        %% ch 05
        function obj = set_prop_chan5_raw( obj, val )
            obj.prop_chan5_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan5_raw( obj )
            val = obj.prop_chan5_raw;
        end
        %% ch 06
        function obj = set_prop_chan6_raw( obj, val )
            obj.prop_chan6_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan6_raw( obj )
            val = obj.prop_chan6_raw;
        end
        %% ch 07
        function obj = set_prop_chan7_raw( obj, val )
            obj.prop_chan7_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan7_raw( obj )
            val = obj.prop_chan7_raw;
        end
         %% ch 08
        function obj = set_prop_chan8_raw( obj, val )
            obj.prop_chan8_raw = obj.validate_input( val, 'uint16', 1 );
        end
        
        function val = get_prop_chan8_raw( obj )
            val = obj.prop_chan8_raw;
        end
        
         %% port
        function obj = set_prop_port( obj, val )
            obj.prop_port = obj.validate_input( val, 'uint8', 1 );
        end
        
        function val = get_prop_port( obj )
            val = obj.prop_port;
        end        
        %% rssi
        function obj = set_prop_rssi( obj, val )
            obj.prop_rssi = obj.validate_input( val, 'uint8', 1 );
        end
        
        function val = get_prop_rssi( obj )
            val = obj.prop_rssi;
        end  
    end
end
