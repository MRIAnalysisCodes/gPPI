function [Flag,summary] = get_ppi_terms(data_path,matlabbatch,roi_xyz,roi_name,radius,condition_number)

    % Get the Subject's information
    Subjects = struct2cell(dir(data_path))';
    Subjects = Subjects(3:size(Subjects))';
    
    %Check the error in Mac Os.
    if strcmp(Subjects{1,1},'.DS_Store')
        Subjects(1,:) = [];
    end
    
    % creat process space
    str=data_path;
    index_dir=findstr(str,'/');
    father_path = str(1:index_dir(end)-1);
    process_path = [father_path,filesep,'Process'];
    mkdir(process_path);
    clear str index_dir 
    
    for subject_i = 1:size(Subjects,1)
        Subjects_file_path = [data_path,filesep,Subjects{subject_i,1}];
        copyfile(Subjects_file_path,process_path);
        spm_jobman('run',matlabbatch);
%        mkdir([output_path,filesep,Subjects{i,1}]);
%         movefile([process_path,filesep,'SPM.mat'],[Subjects_file_path,filesep,'SPM.mat']);
%         delete([process_path,filesep,'*.nii']);
%         delete([process_path,filesep,'*.mat']);
        spm_path = [process_path,filesep,'SPM.mat'];
        
        % extract the time series of each ROI.
        for roi_i = 1:size(roi_xyz,1)
            define_roi(roi_xyz(roi_i,:),roi_name{roi_i,1},radius,spm_path)
            
        end
        
        % Get the PPI term of each condition.
        for cond_i = 1:condition_number
            for k = 1:size(roi_xyz,1)
            define_ppi(spm_path,process_path,roi_name{k,1},cond_i)
            load([process_path,filesep,'PPI_',roi_name{k,1},'cond00',num2str(cond_i),'.mat']);
            PPI_all(cond_i,k,:) = PPI.ppi;
            BOLD(:,k) = PPI.Y;
            PSY(:,cond_i) = PPI.P;
            end
        end
        
        summary(subject_i).PPI = PPI_all; 
        summary(subject_i).BOLD = BOLD;
        summary(subject_i).PSY = PSY;
        clear PPI_all BOLD PSY
        
        rmdir(process_path,'s')
    end
    
    Flag = 'success';
end