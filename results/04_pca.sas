proc princomp data=work.survey_clean
              out=pca_scores
              plots= all;
    var Q1_Explore Q2_need_learn Q3_syllabus
        Q4_graphs Q5_AI Q6_discuss Q7_share;
run;


