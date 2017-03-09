function varargout = mooshik(varargin)
% MUSIC_APP MATLAB code for mooshik.fig
%      MUSIC_APP, by itself, creates a new MUSIC_APP or raises the existing
%      singleton*.
%
%      H = MUSIC_APP returns the handle to a new MUSIC_APP or the handle to
%      the existing singleton*.
%
%      MUSIC_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSIC_APP.M with the given input arguments.
%
%      MUSIC_APP('Property','Value',...) creates a new MUSIC_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before music_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to music_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help music_app

% Last Modified by GUIDE v2.5 08-Mar-2017 19:32:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
global player;
rng('shuffle');
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mooshik_OpeningFcn, ...
                   'gui_OutputFcn',  @mooshik_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mooshik is made visible.
function mooshik_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to music_app (see VARARGIN)

% Choose default command line output for music_app
handles.output = hObject;
% base='C:\Users\arvindn\Music\MyMusic\';
base='C:\Users\arvindn\Music\MyMusic\';
    % genre_index=get(handles.popupmenu1,'value');
    % genre=get(handles.popupmenu1,'string');
    % base=strcat(base,genre{genre_index},'\');
setappdata(handles.popupmenu1,'base_path',base);
    % files=dir(fullfile(base,'*.mp3'));
    % set(handles.listbox1,'string',{files.name});
    % disp(base);
    % Update handles structure
guidata(hObject, handles);

% UIWAIT makes music_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mooshik_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
workingdir=getappdata(handles.popupmenu1,'pwd');
files = get(handles.listbox1,'string');
index= get(handles.listbox1,'value');
filename= strcat(workingdir,files{index});
% disp(workingdir)
disp(files{index})
set(handles.edit1,'string',files{index});
[y,Fs] = audioread(filename);
if(get(handles.left_audio,'Value'))
    s=size(y);
    z=zeros(s(1),1);
    y= [ y(:,1),z];
else if(get(handles.right_audio,'Value'))
        s=size(y);
        z=zeros(s(1),1);
        y= [z, y(:,2)];
    end
end      
global player;
player = audioplayer(y,Fs);
player.TimerPeriod=1;
player.TimerFcn=@player_callback;
set(handles.edit6,'UserData',player.TotalSamples/player.SampleRate);
set(handles.edit5,'UserData',0);
setappdata(handles.listbox1,'sample',Fs);
setappdata(handles.listbox1,'signal',y);
setappdata(handles.listbox1,'index',index);

% disp(get(handles.slider3,''));
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
base=getappdata(handles.popupmenu1,'base_path');
genre_index=get(handles.popupmenu1,'value');
genre=get(handles.popupmenu1,'string');
%  disp(genre{genre_index});
workingdir=strcat(base,genre{genre_index},'\');
setappdata(handles.popupmenu1,'pwd',workingdir);
files=dir(fullfile(workingdir,'*.mp3'));
set(handles.listbox1,'string',{files.name});
%  disp(workingdir);
% Update handles structure
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Next track.
function ff_Callback(hObject, eventdata, handles)
% hObject    handle to ff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
global player;
workingdir=getappdata(handles.popupmenu1,'pwd');
index=getappdata(handles.listbox1,'index');
files = get(handles.listbox1,'string');
index=index+1;
s=size(files);
disp(s);
if(index>s(1))
    index=1;
end
filename= strcat(workingdir,files{index});
% disp(files{index});
set(handles.edit1,'string',files{index});
set(handles.listbox1,'value',index);
[y,Fs] = audioread(filename);
if(get(handles.left_audio,'Value'))
    s=size(y);
    z=zeros(s(1),1);
    y= [ y(:,1),z];
else if(get(handles.right_audio,'Value'))
        s=size(y);
        z=zeros(s(1),1);
        y= [z, y(:,2)];
    end
end   
player = audioplayer(y,Fs);
set(handles.edit6,'UserData',player.TotalSamples/player.SampleRate);
set(handles.edit5,'UserData',0);
play(player);
setappdata(handles.listbox1,'sample',Fs);
setappdata(handles.listbox1,'signal',y);
setappdata(handles.listbox1,'index',index);
guidata(hObject, handles);


% --- Executes on button press in Previous track.
function bb_Callback(hObject, eventdata, handles)
% hObject    handle to bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
workingdir=getappdata(handles.popupmenu1,'pwd');
index=getappdata(handles.listbox1,'index');
global player;
files = get(handles.listbox1,'string');
s=size(files);
index=index-1;
if(index<1)
    index=s(1);
end
filename= strcat(workingdir,files{index});
% disp(files{index});
set(handles.edit1,'string',files{index});
set(handles.listbox1,'value',index);
[y,Fs] = audioread(filename);
if(get(handles.left_audio,'Value'))
    s=size(y);
    z=zeros(s(1),1);
    y= [ y(:,1),z];
else if(get(handles.right_audio,'Value'))
        s=size(y);
        z=zeros(s(1),1);
        y= [z, y(:,2)];
    end
end   
player = audioplayer(y,Fs);
set(handles.edit6,'UserData',player.TotalSamples/player.SampleRate);
set(handles.edit5,'UserData',0);
play(player);
setappdata(handles.listbox1,'sample',Fs);
setappdata(handles.listbox1,'signal',y);
setappdata(handles.listbox1,'index',index);
guidata(hObject, handles);


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
% player.TimerPeriod=1;
% player.TimerFcn=@player_callback;
resume(player);

function player_callback(obj,eventdata)
    global player;
    h=findall(0,'Tag','slider3');
    h2=findall(0,'Tag','edit5');
    h3=findall(0,'Tag','edit6');
    t2=get(h2,'UserData');
    t3=get(h3,'UserData');
    t2=t2+player.TimerPeriod;
    t3=t3-player.TimerPeriod;
    m2 = floor(t2/60);
    s2 = t2-m2*60;
    m3 = floor(t3/60);
    s3 = t3-m3*60;
    set(h2,'String',strcat(num2str(cast(m2,'uint16')),':',num2str(cast(s2,'uint16'))));
    set(h3,'String',strcat(num2str(cast(m3,'uint16')),':',num2str(cast(s3,'uint16'))));
    set(h2,'UserData',t2);
    set(h3,'UserData',t3);
    set(h,'Max',player.TotalSamples);
    set(h,'Value',player.CurrentSample);





% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player
stop(player);



% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Helptab



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Unmute.
function vol_ctrl_Callback(hObject, eventdata, handles)
% hObject    handle to vol_ctrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('goman');
system('sndvol');


%Radio buttons 1 through 5 handle playback speed inside uibuttongroup1

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);
Fs=getappdata(handles.listbox1,'sample');
%disp(Fs/2);
player.SampleRate=Fs/2;


% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);
Fs=getappdata(handles.listbox1,'sample');
%disp(Fs);
player.SampleRate=Fs;

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);
Fs=getappdata(handles.listbox1,'sample');
%disp(Fs*1.5);
player.SampleRate=Fs*1.5;
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);
Fs=getappdata(handles.listbox1,'sample');
%disp(Fs*2);
player.SampleRate=Fs*2;
% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
pause(player);
Fs=getappdata(handles.listbox1,'sample');
%disp(Fs*4);
player.SampleRate=Fs*4;
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in shuffle.
function shuffle_Callback(hObject, eventdata, handles)
% hObject    handle to shuffle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
handles.output = hObject;
% if(~isplaying(player))
    index=getappdata(handles.listbox1,'index');
    files=get(handles.listbox1,'string');
    s=size(files);
    i=index;
    while(i==index)
        i=round(100*rand);
        while(i>s(1))
            i=round(100*rand);
        end
    end
    index=i;
    workingdir=getappdata(handles.popupmenu1,'pwd');
    filename= strcat(workingdir,files{index});
    % disp(files{index});
    set(handles.edit1,'string',files{index});
    set(handles.listbox1,'value',index);
    [y,Fs] = audioread(filename);
    if(get(handles.left_audio,'Value'))
    s=size(y);
    z=zeros(s(1),1);
    y= [ y(:,1),z];
    else if(get(handles.right_audio,'Value'))
        s=size(y);
        z=zeros(s(1),1);
        y= [z, y(:,2)];
        end
    end   
    player = audioplayer(y,Fs);
    set(handles.edit6,'UserData',player.TotalSamples/player.SampleRate);
    set(handles.edit5,'UserData',0);
    player.TimerPeriod=1;
    player.TimerFcn=@player_callback;
    play(player);
    setappdata(handles.listbox1,'sample',Fs);
    setappdata(handles.listbox1,'signal',y);
    setappdata(handles.listbox1,'index',index);  
% else
%     errordlg('Cannot shuffle when playing a track','Error');
% end
 guidata(hObject, handles);


% --- Executes on button press in repeat.
function repeat_Callback(hObject, eventdata, handles)
% hObject    handle to repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
if(~isplaying(player))
    set(handles.edit6,'UserData',player.TotalSamples/player.SampleRate);
    set(handles.edit5,'UserData',0);
    play(player);
else
    errordlg('Cannot repeat when playing a track','Error');
end

% --- Executes on button press in left_audio radiobutton
function left_audio_Callback(hObject, eventdata, handles)
% hObject    handle to left_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
if(~isplaying(player))
    set(handles.left_audio,'Value',1);
    msgbox('Output media changed. Select track from list ->','Alert');
else
    set(handles.left_audio,'Value',1);
    errordlg('Output media changed. Cannot update output when playing','Alert');
end

% --- Executes on button press in right_audio radiobutton
function right_audio_Callback(hObject, eventdata, handles)
% hObject    handle to left_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
if(~isplaying(player))
    set(handles.right_audio,'Value',1); 
    msgbox('Output media changed. Select track from list ->','Alert');
else
    set(handles.right_audio,'Value',1);
    errordlg('Output media changed. Cannot update output when playing','Alert');
end

% --- Executes on button press in right_audio radiobutton
function dual_audio_Callback(hObject, eventdata, handles)
% hObject    handle to left_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
if(~isplaying(player))
    set(handles.dual_audio,'Value',1); 
    msgbox('Output media changed. Select track from list ->','Alert');
else
    set(handles.dual_audio,'Value',1);
    errordlg('Output media changed. Cannot update output when playing','Alert');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global player;
switch eventdata.Key
    case 's'
        stop_Callback(hObject, eventdata, handles)
    case 'p'
        pause_Callback(hObject, eventdata, handles)
    case 'h'
        shuffle_Callback(hObject, eventdata, handles);
    case 'r'
        repeat_Callback(hObject, eventdata, handles);
    case 'b'
        bb_Callback(hObject, eventdata, handles);
    case 'n'
        ff_Callback(hObject, eventdata, handles);
    case 'v'
        vol_ctrl_Callback(hObject, eventdata, handles);
    otherwise
        play_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in logo.
function logo_Callback(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
