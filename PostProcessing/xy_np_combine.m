function  xy_np_combine(working_dir)

filelist = dir(strcat(working_dir,'/*.mat'));

%mkdir(strcat(working_dir,'/','np_combine'));

for i=1:length(filelist)
    load(strcat(working_dir,'/',filelist(i).name));
    working_buff = working_buff';
    % %% Calibration Transformation of data
    %     working_buff(1,:) = (working_buff(1,:)/rad)*100;
    %     working_buff(2,:) = (working_buff(2,:)/rad)*100;
    %
    %     if (flxy==1)
    %         temp = working_buff(1,:);
    %         working_buff(1,:) = working_buff(2,:);
    %         working_buff(2,:) = temp;
    %     end
    %
    %     working_buff(1,:) = working_buff(1,:)- xcen;
    %     working_buff(2,:) = working_buff(2,:)- ycen;
    %
    %     if (flx==1)
    %         working_buff(1,:) = -1*working_buff(1,:);
    %     end
    %
    %     if (fly==1)
    %         working_buff(2,:) = -1*working_buff(2,:);
    %     end
    %%
    nose_poke = working_buff(5,:);
    np_logical = nose_poke>1;
    k=1;
    if sum(np_logical)>1 % check if there are any nose pokes in this file
        np_transition = diff(np_logical); %this will show the transitions
        b=np_transition;
        flag=1;
        c=[];
        
        for j=1:length(b)
            if b(j)==1 && flag==1
                c(k,1) = j;
                c(k,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0
                c(k,2) = j;
                flag=1;
                k=k+1;
            end
        end
        
        e = c;
        
        np_vect = zeros(1,length(working_buff));
        for  n=1:size(e,1)
            if (e(n,2)-e(n,1))>10
                np_vect(e(n,1):e(n,2))=4;
            end
        end
        
        working_buff(5,:) = np_vect;
    end
    
    %%
    js_touch = working_buff(3,:);
    jt_logical = (js_touch>0.5);
    k=1;
    if sum(jt_logical)>1 % check if there are any joystick touches
        jt_transition = diff(jt_logical); %this will show the transitions
        b=jt_transition;
        flag=1;
        c=[];
        
        for j=1:length(b)
            if b(j)==1 && flag==1
                c(k,1) = j;
                c(k,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0
                c(k,2) = j;
                flag=1;
                k=k+1;
            end
        end
        
        e = c;
        %        number_changes=1;
        %
        %        while(number_changes>0)
        %        number_changes=0;
        %        d=[];
        %        m=1;
        %        k=1;
        %        while (k<(size(e,1)))
        %           if ((e(k+1,1)-e(k,2))<10)
        %                 number_changes = number_changes+1;
        %                 d(m,1) = e(k,1);
        %                 d(m,2) = e(k+1,2);
        %                 m=m+1;
        %                 k=k+2;
        %             else
        %                 d(m,1) = e(k,1);
        %                 d(m,2) = e(k,2);
        %                 k=k+1;
        %                 m = m+1;
        %             end
        %        end
        %
        %        if (k==size(e,1))
        %            d(m,1) = e(k,1);
        %            d(m,2) = e(k,2);
        %        end
        %
        %
        %        e = d;
        %        d =[];
        %        end
        %    c=[];
        
        jt_vect = zeros(1,length(working_buff));
        for  n=1:size(e,1)
            if (e(n,2)-e(n,1))>100
                jt_vect(e(n,1):e(n,2))=4;
            end
        end
        
        working_buff(3,:) = jt_vect;
    end
    
    %%
    js_touch = working_buff(4,:);
    jt_logical_2 = (js_touch>0.5);
    k=1;
    if sum(jt_logical_2)>1 % check if there are any post touches in this file
        jt_transition = diff(jt_logical_2); %this will show the transitions
        b=jt_transition;
        flag=1;
        c=[];
        
        for j=1:length(b)
            if b(j)==1 && flag==1
                c(k,1) = j;
                c(k,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0
                c(k,2) = j;
                flag=1;
                k=k+1;
            end
        end
        
        e = c;
        %        number_changes=1;
        %
        %        while(number_changes>0)
        %        number_changes=0;
        %        d=[];
        %        m=1;
        %        k=1;
        %        while (k<(size(e,1)))
        %           if ((e(k+1,1)-e(k,2))<10)
        %                 number_changes = number_changes+1;
        %                 d(m,1) = e(k,1);
        %                 d(m,2) = e(k+1,2);
        %                 m=m+1;
        %                 k=k+2;
        %             else
        %                 d(m,1) = e(k,1);
        %                 d(m,2) = e(k,2);
        %                 k=k+1;
        %                 m = m+1;
        %             end
        %        end
        %
        %        if (k==size(e,1))
        %            d(m,1) = e(k,1);
        %            d(m,2) = e(k,2);
        %        end
        %
        %
        %        e = d;
        %        d =[];
        %        end
        %    c=[];
        
        jt_vect = zeros(1,length(working_buff));
        for  n=1:size(e,1)
            if (e(n,2)-e(n,1))>10
                jt_vect(e(n,1):e(n,2))=4;
            end
        end
        
        working_buff(4,:) = jt_vect;
    end
    
    
    
    %%
    save(strcat(working_dir,'/',filelist(i).name),'working_buff','framenumber_prev');
    
end
