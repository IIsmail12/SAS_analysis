
proc princomp data=work.survey
              out=work.pca_scores
              plots=none; #add diagram later
                
    #brain storm labels             
    var autonomy_learning
        intrinsic_motivation
        syllabus_preference
        visual_learning
        digital_tools_comfort
        social_learning
        peer_exchange;
run;


