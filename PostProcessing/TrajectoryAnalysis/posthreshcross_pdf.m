function [pos_mag,pos_pdf] = posthreshcross_pdf(stats,maxtime)
stats = get_stats_with_len(stats,50);

tstruct = stats.traj_struct;
pos_mag = zeros(numel(tstruct),maxtime);


for stlen=1:numel(tstruct)
    pos_mag_temp = tstruct(stlen).magtraj;
    if numel(pos_mag_temp)>0
        end_t = min(numel(pos_mag_temp),maxtime);
        pos_mag(stlen,1:end_t) = pos_mag_temp(1:end_t);
    end
    
end
pos_mag(pos_mag==0) = nan;
edges = 0:0.025:6.35;
pos_pdf = zeros(numel(edges),maxtime);

for ii=1:maxtime
    pos_pdf(:,ii)=histc(pos_mag(:,ii),edges);
    pos_pdf(:,ii) = pos_pdf(:,ii)./sum(pos_pdf(:,ii));
end