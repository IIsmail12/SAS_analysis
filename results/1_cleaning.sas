/* ================================================================================= */
/* STEP 1: IMPORT THE EXCEL FILE (RAW DATA)                                          */
/* ================================================================================= */

*Import excel file;
libname project xlsx "C:\Users\IIsra\SAS_analysis\survey.xlsx";

*Print first 5 rows of raw dataset;
title "Learning preferences";
proc sql outobs=5; 
	select *
	from project.survey;
run;

/* ================================================================================= */
/* STEP 2: TRANSFORM AND STORE (CLEAN DATA)                                          */
/* ================================================================================= */

*Define format for Y/N questions;
proc format;
    value yn_fmt
        1 = "Yes"
        0 = "No";

*New temporal dataset for cleaning data; 
data work.survey_clean;
    set project.survey;  
**Remove columns;
    drop Name 
         Email
         'Start time'n 
         'Completion time'n
         Other;
**Rename columns;
    rename 
        'Studies last 2 years'n = studies_recent
        'Age group'n           = age_group
        'Level of studies'n     = education_level
        'Current situation'n  = current_situation
        'Study time'n           = study_time_pref;
**Binary Encoding for Studies last 2 years question;
    if 'Studies last 2 years'n = "Yes" then studies_binary = 1;
    else studies_binary = 0;
**Create dummy variables for Tools question;
    tool_ai     = (index(Tools, "Artificial Intelligence") > 0);
    tool_org    = (index(Tools, "Organization apps") > 0);
    tool_video  = (index(Tools, "Video platforms") > 0);
    tool_books  = (index(Tools, "Physical books") > 0);
    tool_online = (index(Tools, "Online courses") > 0);
**Create dummy variables for Techniques question;
	tech_concept = (index(Techniques, "Concept maps") > 0);
    tech_lists   = (index(Techniques, "Lists") > 0);
    tech_flash   = (index(Techniques, "Flashcards") > 0);
**Add Labels to dummy variables and likert questions;
	label 
	        tech_flash      = "Uses Flashcards"
	        tech_lists      = "Uses Lists/Bullet points"
	        tech_concept    = "Uses Concept maps"
			tool_ai         = "Uses AI Tools (ChatGPT, etc.)"
	        tool_org        = "Uses Organization Apps (Notion, Trello)"
	        tool_books      = "Uses Physical books/paper notes"
	        tool_online     = "Uses Online courses (Coursera/Udemy)"
	        tool_video      = "Uses Video Platforms (YouTube, etc.)"
	        Q1_Explore      = "I like to explore topics beyond the syllabus"
	        Q2_need_learn   = "I only learn what is strictly necessary"
	        Q3_syllabus     = "I follow a strict study plan/syllabus"
	        Q4_graphs       = "I prefer using graphs and visual aids"
	        Q5_AI           = "I use AI tools to assist my learning"
	        Q6_discuss      = "I enjoy discussing topics with peers"
	        Q7_share        = "I frequently share notes with others"
	        Q8_satisfaction = "Overall satisfaction with current habits"
	        studies_binary = "Studied in the last 2 years (Binary)";
    
/***Assign format to Y/N questions;
    format studies_binary tool_ai tool_org tool_video tool_books tool_online 
           tech_concept tech_lists tech_flash yn_fmt.;*/
    
run;

/* Check the structure of the cleaned dataset */
title "Cleaned Dataset Metadata";
proc contents data=work.survey_clean;
run;

/*title "Final Cleaned Dataset (First 5 Rows)";*/
proc print data=work.survey_clean(obs=5);
run;