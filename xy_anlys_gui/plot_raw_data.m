function [handles] = plot_raw_data(handles, axnum)
%plot_raw_data plots raw sensor information onto axes axnum. np, js, post,
%x, y, dev, are all 1/0 flags instructing whether or not to plot raw data.
% also plots analog information
npons = [handles.np1, handles.np2, handles.np3, handles.np4, handles.np5];
npon = get(npons(axnum), 'Value');

lickons = [handles.lick1, handles.lick2, handles.lick3, handles.lick4, handles.lick5];
lickon = get(lickons(axnum), 'Value');

postons = [handles.post1, handles.post2, handles.post3, ...
    handles.post4, handles.post5];
poston = get(postons(axnum), 'Value');

jsons = [handles.js1, handles.js2, handles.js3, handles.js4, handles.js5];
json = get(jsons(axnum), 'Value');

rews = [handles.rew1, handles.rew2, handles.rew3, handles.rew4, handles.rew5];
rewon = get(rews(axnum), 'Value');

lasers = [handles.laser1, handles.laser2, handles.laser3, ...
    handles.laser4, handles.laser5];
laseron = get(lasers(axnum), 'Value');

analogmenus = [handles.analogmenu1, handles.analogmenu2, ...
    handles.analogmenu3, handles.analogmenu4, handles.analogmenu5];
analogind = get(analogmenus(axnum), 'Value');

filterframes = [handles.filter1, handles.filter2, handles.filter3, ...
    handles.filter4, handles.filter5];
smoothwindow = get(filterframes(axnum), 'String');
smoothval = smoothwindow{get(filterframes(axnum), 'Value')};
smoothval = str2num(smoothval);

axlst = [handles.axes1, handles.axes2, handles.axes3, handles.axes4, ...
    handles.axes5];
ax = axlst(axnum);

%flag indicating y axes will be centered at 0, rather than 3.5
zerocenter = analogind > 2;
%LINEWIDTH is 2 if 3 or less items, 1 otherwise
LINEWIDTH = 1 + ((npon+poston+json+rewon+laseron+(analogind>1))<5);

xrange = handles.xaxis;
axes(ax); zoom reset; cla; hold on; 
if npon
    plot_np(handles, ax, zerocenter, LINEWIDTH, xrange(2));
end
if lickon
    plot_lick(handles, ax, zerocenter, LINEWIDTH, xrange(2));
end
if poston
    plot_post(handles,ax, zerocenter, LINEWIDTH, xrange(2));
end
if json
    plot_js(handles,ax, zerocenter, LINEWIDTH, xrange(2));
end
if rewon
    plot_rew(handles,ax, zerocenter, LINEWIDTH, xrange(2));
end
if laseron
    plot_laser(handles, ax, zerocenter, LINEWIDTH, xrange(2));
end

if analogind > 1
    plot_analog(handles, ax, analogind, xrange(2), smoothval)
end

LIMIT = handles.RADIUS*1.08;
if zerocenter
    axis(ax, [xrange(1) xrange(2) -LIMIT LIMIT]);
else
    axis(ax, [xrange(1) xrange(2) 0 LIMIT]);
end

hold off;

end

function plot_np(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    npdata = data(1, :)*6;
    if scaling
        npdata = npdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        npdata,'r','LineWidth',LINEWIDTH);
end

function plot_lick(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    lickdata = data(9,:)*5.5;
    if scaling
        lickdata = lickdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        lickdata,'color',[0.5 0.5 0.5],'LineWidth',LINEWIDTH);
end

function plot_post(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    postdata = data(2, :)*5;
    if scaling
        postdata = postdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        postdata,'g','LineWidth',LINEWIDTH);
end

function plot_js(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    postdata = data(3, :)*4;
    if scaling
        postdata = postdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        postdata,'b','LineWidth',LINEWIDTH);
end

function plot_rew(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    rewdata = data(4, :)*3;
    if scaling
        rewdata = rewdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        rewdata,'m','LineWidth',LINEWIDTH);    
end

function plot_laser(handles, ax, scaling, LINEWIDTH, xmax)
    data = handles.plotdata;
    rewdata = data(5, :)*2;
    if scaling
        rewdata = rewdata*2 - 6;
    end
    plot(ax,(1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax,...
        rewdata,'c','LineWidth',LINEWIDTH);
end

function plot_analog(handles, ax, analogind, xmax, smoothval)
    data = handles.plotdata;
    if analogind == 2;
        data = data(6, :);
    elseif analogind == 3
        data = data(7, :);
    elseif analogind == 4
        data = data(8, :);
    end
    if analogind < 5
    plot(ax, (1/handles.SAMPLE_RATE):(1/handles.SAMPLE_RATE):xmax, ...
        smooth(data, smoothval), 'k', 'LineWidth', 2)
    end
end