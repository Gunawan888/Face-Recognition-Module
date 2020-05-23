img = '1.pgm';

fig = uifigure('Name', 'FACE RECOGNITION');
panel = uipanel(fig,'Position',[100 100 196 135]);
open = uibutton(panel,'push','Position',[11 65 140 22],'Text','Open','ButtonPushedFcn', @(btn,event) Open(btn, img));
show = uibutton(panel,'push','Position',[11 40 140 22],'Text','Show','ButtonPushedFcn', @(btn,event) Show(btn, img));

function Open(event,img)
   newFile = uigetfile('*.pgm'); %#ok<NASGU>
   f = msgbox('File succesfully entered');
end

function Show(event,img)
   imshow(img);
end
