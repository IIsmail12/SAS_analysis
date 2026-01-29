
proc fastclus data=work.pca_scores 
              maxclusters=3 #more interpretation less complexity
              out=work.clusters;
    var prin1 prin2 prin3; # are the PCA component scores
run;

proc freq data=work.clusters;
    tables cluster * gender / chisq;  #chiq test on the work cluster (analsying gender)
run;

proc means data=work.clusters mean;
    class cluster;
    var learning_effectiveness;  #mean effectiveness for learning_effectiveness
run;
