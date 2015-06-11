for i=1:length(list)

load(list(i).name);
stats = xy_getstats(jstruct,[0 inf]);

[a,b,c,d,e,f]=xy_vel(jstruct);
figure
% subplot(2,3,1)
pcolor(log(a));
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);
shading flat
axis equal
axis image

figure
% subplot(2,3,4)
pcolor(log(b));
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);
shading flat
axis equal
axis image

figure
% subplot(2,3,2)
pcolor(c');
caxmax = prctile(reshape(c(c>0),numel(c(c>0)),1),75);
caxis([0 caxmax]);
shading flat
axis equal
axis image
h = colorbar;
title(h,'mm/ms');
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);

figure
% subplot(2,3,3)
pcolor(d');
caxmax = prctile(reshape(d(d>0),numel(d(d>0)),1),75);
caxis([0 caxmax]);
shading flat
axis equal
axis image
h = colorbar;
title(h,'mm/ms');
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);

figure
% subplot(2,3,5)
pcolor(e');
caxmax = prctile(reshape(e(e>0),numel(e(e>0)),1),75);
caxis([0 caxmax]);
shading flat
axis equal
axis image
h = colorbar;
title(h,'mm/ms');
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);

figure
% subplot(2,3,6)
pcolor(f');
caxmax = prctile(reshape(f(f>0),numel(f(f>0)),1),75);
caxis([0 caxmax]);
shading flat
axis equal
axis image
h = colorbar;
title(h,'mm/ms');
set(gca,'xTickLabel',{'-7.6';'0';'7.6'});
set(gca,'xTick',[1,60,120]);
set(gca,'YTickLabel',{'-7.6';'0';'7.6'});
set(gca,'YTick',[1,60,120]);
end
