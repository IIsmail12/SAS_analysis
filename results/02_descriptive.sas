/* Gender */
proc freq data=work.survey_clean noprint;
    tables gender / out=gender_freq;
run;

/* Age group */
proc freq data=work.survey_clean noprint;
    tables age_group / out=age_freq;
run;

/* Education level */
proc freq data=work.survey_clean noprint;
    tables education_level / out=edu_freq;
run;

/* Current situation */
proc freq data=work.survey_clean noprint;
    tables current_situation / out=situation_freq;
run;
data gender_freq;
    set gender_freq;
    Variable = "Gender";
    Category = gender;
    keep Variable Category Count Percent;
run;

data age_freq;
    set age_freq;
    Variable = "Age group";
    Category = age_group;
    keep Variable Category Count Percent;
run;

data edu_freq;
    set edu_freq;
    Variable = "Education level";
    Category = education_level;
    keep Variable Category Count Percent;
run;

data situation_freq;
    set situation_freq;
    Variable = "Current situation";
    Category = current_situation;
    keep Variable Category Count Percent;
run;
data respondent_profile;
    set gender_freq
        age_freq
        edu_freq
        situation_freq;
run;
title "Table 1. Socio-demographic characteristics of respondents (N = 42)";

proc print data=respondent_profile noobs label;
    var Variable Category Count Percent;
    format Percent 6.2;
    label
        Variable = "Variable"
        Category = "Category"
        Count    = "Frequency"
        Percent  = "Percentage (%)";
run;
