function [] = exportfigpptx(figure_handle)

ppt = actxserver('PowerPoint.Application');
ppt.Visible = 1;

Presentation = ppt.Presentation.Add;

blankSlide = Presentation.SlideMaster.CustomLayouts.Item(1);
Slide1 = Presentation.Slides.AddSlide(1,blankSlide);

