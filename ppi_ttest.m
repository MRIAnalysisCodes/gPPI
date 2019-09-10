function result = ppi_ttest(ppi_beta)
    
    beta = ppi_beta.beta;
    con_num = size(ppi_beta.interest_effect,2);
    subj_num = size(ppi_beta.beta,1);
    node_num = size(beta{1,1},1);
    
    
    % Prepare the data.
    for con_i = 1:con_num
        for subj_i = 1:subj_num
            reshaped_beta{con_i}(subj_i,:) = reshape(beta{subj_i,con_i},[1,node_num * node_num]);
        end
    end
    
    t_result_p = zeros(1,size(reshaped_beta{1,1},2));
    t_result_t = zeros(1,size(reshaped_beta{1,1},2));
    
    for t_i = 1:size(reshaped_beta{1,1},2)
        if isnan(reshaped_beta{1,1}(1,t_i)) == 0
            con_1 = reshaped_beta{1,1}(:,t_i);
            con_2 = reshaped_beta{1,2}(:,t_i);
            [H,P,CI,STATS] = ttest(con_1,con_2);
            t_result_p(:,t_i) = P;
            t_result_t(:,t_i) = STATS.tstat;
        else
            t_result_p(:,t_i) = NaN;
            t_result_t(:,t_i) = NaN;
        end
    end
    
    t_result_p = reshape(t_result_p,[node_num,node_num]);
    t_result_t = reshape(t_result_t,[node_num,node_num]);
    result.ttest_p = t_result_p;
    result.ttest_t = t_result_t;
    result.interest = ppi_beta.interest_effect;    
end