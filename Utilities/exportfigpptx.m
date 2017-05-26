function [] = exportfigpptx(pptname,fig_handles,subplotformat)
%% Created by Teja Pratap Bollu 
% Last edit: 04/20/2017
%
% PPTNAME: Filename to save powerpoint as. Function tries to open an
% existing ppt, if no ppt with PPTNAME exists, it creates a new ppt
%
% FIG_HANDLES: Figure handles of figures required to be written to this
% slid of the ppt presentation
%
% SUBPLOT_FORMAT: Format of subplots for arranging the figures supplied in
% FIG_HANDLES

ppt = actxserver('PowerPoint.Application');

try
    Presentation = ppt.Presentation.Open(pptname);
catch
     display('Creating a new Presentation');
    Presentation = ppt.Presentation.Add;
end

numfigs = numel(fig_handles);

%Create a new slide
blankSlide = Presentation.SlideMaster.CustomLayouts.Item(7);
Slide1 = Presentation.Slides.AddSlide(1,blankSlide);

%Resize the figures to fit the slide
index1 = subplotformat(1);
index2 = subplotformat(2);
xcoord_split = 960/(index2+1);
ycoord_split = 540/(index1+1);
numfigs = min(numfigs,index1*index2);

ratio_reduce = 1/(max(index1,index2));

width = 720*ratio_reduce;
height = 540*ratio_reduce;

%Convert figures to a metafiles
if ~exist(strcat(matlabroot,'/temp/'))
    mkdir(strcat(matlabroot,'/temp/'));
end

for i = 1:numfigs
    saveas(fig_handles(i),strcat(matlabroot,'\temp\temp_fig',num2str(i)),'emf');
end


%place the figures in according to subplot
for i=1:index2
    for j=1:index1
        try
        pic_handles(i,j) = Slide1.Shapes.AddPicture(strcat(matlabroot,'\temp\temp_fig',num2str((i-1)*index1+j),'.emf'),'msoFalse','msoTrue',(xcoord_split*i-width/2),(ycoord_split*j-height/2),width,height);
        delete(strcat(matlabroot,'\temp\temp_fig',num2str((i-1)*index1+j),'.emf'));
        catch
        end
    end
end

%done save presentation and quit
Presentation.SaveAs(pptname);

ppt.Quit;
ppt.delete;