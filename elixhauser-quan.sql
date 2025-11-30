
-- ELIXHAUSER QUAN COMORBIDITY SCORE
-- Logic taken from: https://github.com/MIT-LCP/mimic-code

DROP TABLE IF EXISTS elixhauser_quan CASCADE;
CREATE TABLE elixhauser_quan AS
WITH diagnosis_list AS
(
    SELECT hadm_id, icd9_code
    FROM diagnoses_icd
),
elixhauser AS
(
    SELECT hadm_id
    , MAX(CASE WHEN icd9_code BETWEEN '39891' AND '39899' OR icd9_code BETWEEN '40201' AND '40291' OR icd9_code BETWEEN '40401' AND '40491' OR icd9_code = '428' OR icd9_code BETWEEN '4280' AND '4289' THEN 1 ELSE 0 END) AS congestive_heart_failure
    , MAX(CASE WHEN icd9_code BETWEEN '42610' AND '42613' OR icd9_code = '4262' OR icd9_code = '4263' OR icd9_code = '4264' OR icd9_code BETWEEN '42650' AND '42653' OR icd9_code BETWEEN '4266' AND '4268' OR icd9_code = '4270' OR icd9_code = '4272' OR icd9_code = '42731' OR icd9_code = '42760' OR icd9_code = '4279' OR icd9_code = '7850' OR icd9_code = 'V450' OR icd9_code = 'V533' THEN 1 ELSE 0 END) AS cardiac_arrhythmias
    , MAX(CASE WHEN icd9_code BETWEEN '09320' AND '09324' OR icd9_code BETWEEN '3940' AND '3971' OR icd9_code BETWEEN '3979' AND '3979' OR icd9_code BETWEEN '4240' AND '42491' OR icd9_code BETWEEN '7463' AND '7466' OR icd9_code = 'V422' OR icd9_code = 'V433' THEN 1 ELSE 0 END) AS valvular_disease
    , MAX(CASE WHEN icd9_code BETWEEN '4150' AND '41519' OR icd9_code BETWEEN '4160' AND '4169' OR icd9_code = '4170' OR icd9_code = '4178' OR icd9_code = '4179' THEN 1 ELSE 0 END) AS pulmonary_circulation
    , MAX(CASE WHEN icd9_code BETWEEN '4400' AND '4409' OR icd9_code BETWEEN '44100' AND '4419' OR icd9_code BETWEEN '4420' AND '4429' OR icd9_code BETWEEN '4431' AND '4439' OR icd9_code BETWEEN '4471' AND '4471' OR icd9_code = '5571' OR icd9_code = '5579' OR icd9_code = 'V434' THEN 1 ELSE 0 END) AS peripheral_vascular
    , MAX(CASE WHEN icd9_code BETWEEN '4011' AND '4019' OR icd9_code BETWEEN '40210' AND '40291' OR icd9_code BETWEEN '40410' AND '40491' OR icd9_code BETWEEN '40511' AND '40599' OR icd9_code BETWEEN '4372' AND '4372' THEN 1 ELSE 0 END) AS hypertension
    , MAX(CASE WHEN icd9_code BETWEEN '3420' AND '3449' OR icd9_code BETWEEN '43820' AND '43853' OR icd9_code = '78072' THEN 1 ELSE 0 END) AS paralysis
    , MAX(CASE WHEN icd9_code BETWEEN '3300' AND '3319' OR icd9_code = '3320' OR icd9_code = '3334' OR icd9_code = '3335' OR icd9_code = '3340' OR icd9_code BETWEEN '3350' AND '3359' OR icd9_code = '340' OR icd9_code BETWEEN '3411' AND '3419' OR icd9_code BETWEEN '34500' AND '34591' OR icd9_code BETWEEN '34700' AND '34701' OR icd9_code = '3481' OR icd9_code = '3483' OR icd9_code = '7803' OR icd9_code = '7843' THEN 1 ELSE 0 END) AS other_neurological
    , MAX(CASE WHEN icd9_code BETWEEN '490' AND '4928' OR icd9_code BETWEEN '49300' AND '49392' OR icd9_code BETWEEN '494' AND '4941' OR icd9_code BETWEEN '4950' AND '505' OR icd9_code = '5064' THEN 1 ELSE 0 END) AS chronic_pulmonary
    , MAX(CASE WHEN icd9_code BETWEEN '25000' AND '25033' OR icd9_code = '64800' OR icd9_code = '64801' OR icd9_code = '64802' OR icd9_code = '64803' OR icd9_code = '64804' OR icd9_code = '24900' OR icd9_code = '24901' OR icd9_code = '24910' OR icd9_code = '24911' OR icd9_code = '24920' OR icd9_code = '24921' OR icd9_code = '24930' OR icd9_code = '24931' THEN 1 ELSE 0 END) AS diabetes_uncomplicated
    , MAX(CASE WHEN icd9_code BETWEEN '25040' AND '25093' OR icd9_code = '7751' OR icd9_code = '24940' OR icd9_code = '24941' OR icd9_code = '24950' OR icd9_code = '24951' OR icd9_code = '24960' OR icd9_code = '24961' OR icd9_code = '24970' OR icd9_code = '24971' OR icd9_code = '24980' OR icd9_code = '24981' OR icd9_code = '24990' OR icd9_code = '24991' THEN 1 ELSE 0 END) AS diabetes_complicated
    , MAX(CASE WHEN icd9_code BETWEEN '243' AND '2442' OR icd9_code = '2448' OR icd9_code = '2449' THEN 1 ELSE 0 END) AS hypothyroidism
    , MAX(CASE WHEN icd9_code BETWEEN '40301' AND '40493' OR icd9_code BETWEEN '585' AND '5859' OR icd9_code = '586' OR icd9_code = 'V420' OR icd9_code = 'V451' OR icd9_code = 'V560' OR icd9_code = 'V561' OR icd9_code = 'V562' OR icd9_code = 'V5631' OR icd9_code = 'V5632' OR icd9_code = 'V568' THEN 1 ELSE 0 END) AS renal_failure
    , MAX(CASE WHEN icd9_code = '07022' OR icd9_code = '07023' OR icd9_code = '07032' OR icd9_code = '07033' OR icd9_code = '07044' OR icd9_code = '07054' OR icd9_code = '4560' OR icd9_code = '4561' OR icd9_code = '45620' OR icd9_code = '45621' OR icd9_code = '5710' OR icd9_code = '5712' OR icd9_code = '5713' OR icd9_code BETWEEN '57140' AND '57149' OR icd9_code = '5715' OR icd9_code = '5716' OR icd9_code = '5718' OR icd9_code = '5719' OR icd9_code = '5723' OR icd9_code = '5728' OR icd9_code = '5735' OR icd9_code = 'V427' THEN 1 ELSE 0 END) AS liver_disease
    , MAX(CASE WHEN icd9_code BETWEEN '53100' AND '53491' THEN 1 ELSE 0 END) AS peptic_ulcer
    , MAX(CASE WHEN icd9_code BETWEEN '042' AND '0449' THEN 1 ELSE 0 END) AS aids
    , MAX(CASE WHEN icd9_code BETWEEN '1400' AND '1729' OR icd9_code BETWEEN '1740' AND '1958' OR icd9_code BETWEEN '20000' AND '20892' OR icd9_code = '2386' THEN 1 ELSE 0 END) AS lymphoma
    , MAX(CASE WHEN icd9_code BETWEEN '1960' AND '1991' OR icd9_code BETWEEN '20970' AND '20975' OR icd9_code = '20979' OR icd9_code = '78951' THEN 1 ELSE 0 END) AS metastatic_cancer
    , MAX(CASE WHEN icd9_code = '7010' OR icd9_code BETWEEN '7100' AND '7109' OR icd9_code BETWEEN '7140' AND '71433' OR icd9_code BETWEEN '71481' AND '71489' OR icd9_code BETWEEN '7200' AND '7209' OR icd9_code = '725' THEN 1 ELSE 0 END) AS rheumatoid_arthritis
    , MAX(CASE WHEN icd9_code BETWEEN '2860' AND '2869' OR icd9_code = '2871' OR icd9_code BETWEEN '2873' AND '2875' THEN 1 ELSE 0 END) AS coagulopathy
    , MAX(CASE WHEN icd9_code = '2780' OR icd9_code = '27800' OR icd9_code = '27801' OR icd9_code = '27803' THEN 1 ELSE 0 END) AS obesity
    , MAX(CASE WHEN icd9_code BETWEEN '260' AND '2639' THEN 1 ELSE 0 END) AS weight_loss
    , MAX(CASE WHEN icd9_code BETWEEN '2760' AND '2769' THEN 1 ELSE 0 END) AS fluid_electrolyte
    , MAX(CASE WHEN icd9_code = '2800' OR icd9_code BETWEEN '2801' AND '2809' OR icd9_code = '2810' OR icd9_code BETWEEN '2811' AND '2819' OR icd9_code = '28521' OR icd9_code = '28522' OR icd9_code = '28529' OR icd9_code = '2859' THEN 1 ELSE 0 END) AS blood_loss_anemia
    , MAX(CASE WHEN icd9_code BETWEEN '2800' AND '28529' OR icd9_code = '2859' THEN 1 ELSE 0 END) AS deficiency_anemias
    , MAX(CASE WHEN icd9_code BETWEEN '2910' AND '2913' OR icd9_code = '2915' OR icd9_code = '2918' OR icd9_code = '29181' OR icd9_code = '29189' OR icd9_code = '2919' OR icd9_code BETWEEN '30300' AND '30393' OR icd9_code BETWEEN '30500' AND '30503' THEN 1 ELSE 0 END) AS alcohol_abuse
    , MAX(CASE WHEN icd9_code = '2920' OR icd9_code BETWEEN '29282' AND '29289' OR icd9_code = '2929' OR icd9_code BETWEEN '30400' AND '30493' OR icd9_code BETWEEN '30520' AND '30593' OR icd9_code = '64830' OR icd9_code = '64831' OR icd9_code = '64832' OR icd9_code = '64833' OR icd9_code = '64834' THEN 1 ELSE 0 END) AS drug_abuse
    , MAX(CASE WHEN icd9_code BETWEEN '29500' AND '29911' OR icd9_code = 'V113' THEN 1 ELSE 0 END) AS psychoses
    , MAX(CASE WHEN icd9_code = '3004' OR icd9_code = '30112' OR icd9_code = '3090' OR icd9_code = '3091' OR icd9_code = '311' THEN 1 ELSE 0 END) AS depression
  FROM diagnosis_list
  GROUP BY hadm_id
)
SELECT * FROM elixhauser;
