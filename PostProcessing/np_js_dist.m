function list = np_js_dist(np,js)
list = [];
for i=1:size(np,1)
 for j=1:size(np,2)
 if np(i,j,1)>0
    list =[ list (js(i,find(js(i,:)))-np(i,j,1))];
 end
 end
end

list = list/10000;

list = list(find((list>-1)&(list<1)));