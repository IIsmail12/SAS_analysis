/* =============================================================== */
/* FALLBACK SCRIPT: PCA + CLUSTERING ON LEARNING PREFERENCES       */
/* Project: Statistics and Data Analysis                           */
/* Purpose: Dimensionality reduction + learner profiling           */
/* =============================================================== */

/* --------------------------------------------------------------- */
/* STEP 0: Assumptions                                             */
/* --------------------------------------------------------------- */
/* - Clean dataset already exists: work.survey_clean               */
/* - Likert-scale variables are coded numerically (1–7)            */
/* - Q8_satisfaction is excluded from PCA and used later           */
/* --------------------------------------------------------------- */


/* --------------------------------------------------------------- */
/* STEP 1: Principal Component Analysis (PCA)                      */
/* --------------------------------------------------------------- */
/* Reduce 7 correlated learning-preference variables into           */
/* a smaller set of uncorrelated components                         */

proc princomp data=work.survey_clean
              out=work.pca_scores
              n=3                /* retain first 3 components */
              std;               /* standardize variables     */
    var Q1_Explore 
        Q2_need_learn 
        Q3_syllabus 
        Q4_graphs 
        Q5_AI 
        Q6_discuss 
        Q7_share;
run;

/* Output dataset: work.pca_scores */
/* New variables created: Prin1, Prin2, Prin3 */


/* --------------------------------------------------------------- */
/* STEP 2: Cluster Analysis using PCA Scores                       */
/* --------------------------------------------------------------- */
/* Cluster individuals based on underlying learning dimensions     */
/* FASTCLUS is appropriate for continuous component scores         */

proc fastclus data=work.pca_scores
              maxclusters=3      /* number of clusters */
              out=work.clustered
              seed=12345;        /* ensures reproducibility */
    var Prin1 Prin2 Prin3;
run;

/* Output dataset: work.clustered */
/* Cluster assignment variable: Cluster */


/* --------------------------------------------------------------- */
/* STEP 3: Cluster Size Distribution                               */
/* --------------------------------------------------------------- */
/* Check how respondents are distributed across clusters           */

proc freq data=work.clustered;
    tables Cluster;
    title "Cluster Size Distribution";
run;


/* --------------------------------------------------------------- */
/* STEP 4: Cluster Profiling using PCA Scores                      */
/* --------------------------------------------------------------- */
/* Interpret clusters by comparing mean component scores            */

proc means data=work.clustered mean;
    class Cluster;
    var Prin1 Prin2 Prin3;
    title "Mean PCA Scores by Cluster";
run;


/* --------------------------------------------------------------- */
/* STEP 5: Link Clusters to Learning Satisfaction (Optional)       */
/* --------------------------------------------------------------- */
/* Assess whether learner profiles differ in overall satisfaction  */

proc means data=work.clustered mean std;
    class Cluster;
    var Q8_satisfaction;
    title "Learning Satisfaction by Cluster";
run;


/* --------------------------------------------------------------- */
/* STEP 6 (Optional): Cluster Visualization                        */
/* --------------------------------------------------------------- */
/* Visualize separation between clusters using first two PCs       */
/* Include only ONE cluster plot in the report                     */

proc sgplot data=work.clustered;
    scatter x=Prin1 y=Prin2 / group=Cluster;
    xaxis label="Principal Component 1";
    yaxis label="Principal Component 2";
    title "Cluster Plot Based on PCA Scores";
run;

/* =============================================================== */
/* END OF SCRIPT                                                   */
/* =============================================================== */
