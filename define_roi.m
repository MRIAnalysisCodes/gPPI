function define_roi(roi_xyz,roi_name,radius,spm_path)
    matlabbatch{1}.spm.util.voi.spmmat = {spm_path};
    matlabbatch{1}.spm.util.voi.adjust = 1;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = roi_name;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = roi_xyz;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = radius;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.spmmat = {''};
    matlabbatch{1}.spm.util.voi.roi{2}.spm.contrast = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.conjunction = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
    matlabbatch{1}.spm.util.voi.roi{2}.spm.thresh = 1;
    matlabbatch{1}.spm.util.voi.roi{2}.spm.extent = 0;
    %matlabbatch{1}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.util.voi.expression = 'i1&i2';

    spm_jobman('run',matlabbatch);
end