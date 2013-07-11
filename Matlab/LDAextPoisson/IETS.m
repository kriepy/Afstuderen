
t=[];
for i=1:19
    p=[];
    for j=1:10
        %if ~(i==17 && j==5)
            f=exp(-(DataPois{1}.Run{i}.Step{j}.L)/((i+1)*5*2000));%/(M*len));
            if ~isnan(f)
                p=[p f];
            end
        %end
    end
    t=[t mean(p)];
end
plot(t)