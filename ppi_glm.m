function [ppi_beta] = ppi_glm(ppi_terms,interest_effect)
    subject_num = size(ppi_terms,2);
    
    for subject_i = 1:subject_num
        ppi = ppi_terms(subject_i).PPI;
        bold = ppi_terms(subject_i).BOLD;
        psy = ppi_terms(subject_i).PSY;
        roi_num = size(bold,2);
        timeserise_length = size(bold,1);
        cond_num = size(interest_effect,2);
        for roii = 1:roi_num
            for roij = 1:roi_num
                if roij~=roii
                    bold_roi_y = bold(:,roii);
                    bold_roi_x = bold(:,roij);
                    psy_x = psy(:,interest_effect);
                    ppi_x = squeeze(ppi(interest_effect,roij,:))';
                    ppi_input_terms = [ones(timeserise_length,1),bold_roi_x,psy_x,ppi_x];   
                    b = regress(zscore(bold_roi_y),zscore(ppi_input_terms));
                    b_ppi = b(end - cond_num + 1:1:end,1);
                    for cond_i = 1:cond_num
                        beta{subject_i,cond_i}(roii,roij) = b_ppi(cond_i,1);
                    end
                else
                    for cond_i = 1:cond_num
                        beta{subject_i,cond_i}(roii,roij) = NaN;
                    end
                end
            end
        end
    end
    
    ppi_beta.interest_effect = interest_effect;
    ppi_beta.beta = beta;
    
end