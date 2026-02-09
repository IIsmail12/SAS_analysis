
/* =============================================================== */
/* ASSOCIATION ANALYSIS                 */
/* =============================================================== */


/* 1. Gender x AI Usage */

proc freq data=work.survey_clean;
    tables gender * tool_ai / chisq expected;
run;

/* 2. current situation(work/study) x AI Usage */
proc freq data=work.survey_clean;
    tables current_situation * tool_ai / chisq expected;
run;

/* 2. education x visual_pref */

data survey_assoc;
    set work.survey_clean;
    if Q4_graphs >= 5 then visual_pref = "High";
    else visual_pref = "Low/Medium";
run;
proc freq data=survey_assoc;
    tables education_level * visual_pref / chisq expected;
run;

/* --------------------------------------------------------------- */
/* 3️⃣ Education Level × AI Tool Usage                              */
/* Research Question: Is AI tool usage associated with education?  */
/* --------------------------------------------------------------- */

proc freq data=work.survey_clean;
    tables education_level * tool_ai / chisq expected;
    title "Association: Education Level × AI Tool Usage";
run;
/* --------------------------------------------------------------- */
/* 4️⃣ Current Situation × Learning Satisfaction                    */
/* Research Question: Does satisfaction differ by situation?       */
/* --------------------------------------------------------------- */

/* Convert satisfaction (Likert 1–7) into 2 groups for Chi-square */

data survey_assoc;
    set work.survey_clean;
    if Q8_satisfaction >= 5 then satisfaction_level = "High";
    else satisfaction_level = "Low/Medium";
run;

proc freq data=survey_assoc;
    tables current_situation * satisfaction_level / chisq expected;
    title "Association: Situation × Learning Satisfaction";
run;