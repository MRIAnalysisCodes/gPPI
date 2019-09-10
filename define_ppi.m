function define_ppi(spm_path,process_path,roi_name,condition_number)

        matlabbatch{1}.spm.stats.ppi.spmmat = {spm_path};
        matlabbatch{1}.spm.stats.ppi.type.ppi.voi = {[process_path,filesep,'VOI_',roi_name,'_1.mat']};
        matlabbatch{1}.spm.stats.ppi.type.ppi.u = [condition_number 1 1];
        matlabbatch{1}.spm.stats.ppi.name = [roi_name,'cond' num2str(condition_number,'%.3d')];
        matlabbatch{1}.spm.stats.ppi.disp = 0;
        
        spm_jobman('run',matlabbatch);
end