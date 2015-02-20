[trial_len,rate,maxdist,t_list_17]=pp_traj_anly(jstruct_17,[2.52 2.48]);
[trial_len,rate,maxdist,t_list_18]=pp_traj_anly(jstruct_18,[2.531 2.48]);
[trial_len,rate,maxdist,t_list_22]=pp_traj_anly(jstruct_22,[2.531 2.52]);
[trial_len,rate,maxdist,t_list_23]=pp_traj_anly(jstruct_23,[2.531 2.52]);
[trial_len,rate,maxdist,t_list_24]=pp_traj_anly(jstruct_24,[2.531 2.52]);
[trial_len,rate,maxdist,t_list_25]=pp_traj_anly(jstruct_25,[2.531 2.52]);

edges = -180:10:180;

t_list_25(find(t_list_25==0))=nan;
t_list_24(find(t_list_24==0))=nan;
t_list_23(find(t_list_23==0))=nan;
t_list_22(find(t_list_22==0))=nan;
t_list_18(find(t_list_18==0))=nan;
t_list_17(find(t_list_17==0))=nan;

dist_17 = histc(t_list_17,edges);
dist_18 = histc(t_list_18,edges);
dist_22 = histc(t_list_22,edges);
dist_23 = histc(t_list_23,edges);
dist_24 = histc(t_list_24,edges);
dist_25 = histc(t_list_25,edges);

dist_17 = dist_17/sum(dist_17);
dist_18 = dist_18/sum(dist_18);
dist_22 = dist_22/sum(dist_22);
dist_23 = dist_23/sum(dist_23);
dist_24 = dist_24/sum(dist_24);
dist_25 = dist_25/sum(dist_25);

figure;hold on
plot(edges,dist_17,'k');
plot(edges,dist_18,'k');
plot(edges,dist_22,'b');
plot(edges,dist_23,'r');
plot(edges,dist_24,'c');
plot(edges,dist_25,'p');