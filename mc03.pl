:-abolish(asked/2).
:-dynamic(ask/2).
:-dynamic ask2/4, asked/2.

/* Tools for questioning the patient */
askif(Qcode) :- ask(Qcode,A), positive_answer(Qcode,A).
askifnot(Qcode) :- not(askif(Qcode)).
positive_answer(Qcode,A) :- positive(A).
positive_answer(Qcode,A) :- not(negative(A)),
  not(positive(A)), write('Please answer yes or no.'),
  read(A2), retract(asked(Qcode,A)),
  asserta(asked(Qcode,A2)), positive(A2).
ask(Qcode,A) :- asked(Qcode,A).
ask(Qcode,A) :- not(asked(Qcode,A)), questioncode(Qcode,Q),
  write(Q), write('? (yes|no) '), read(A2), ask2(Q,Qcode,A2,A).
ask2(Q,Qcode,'?',A) :- explain(Qcode), ask(Qcode,A).
ask2(Q,Qcode,A,A) :- not(A='?'), asserta(asked(Qcode,A)).
positive(yes).
negative(no).

/* Top-level diagnosis rules */
diagnosis(appendicitis) :- askif(abdominal_pain), symptom_appendicitis_1, mantrels_score.
diagnosis(pancreatitis) :-
  askif(abdominal_pain), symptom_pancreatitis, patient_history_pancreatitis, physical_findings_pancreatitis_1.
diagnosis(pancreatitis) :-
  askif(abdominal_pain), symptom_pancreatitis, patient_history_pancreatitis, physical_findings_pancreatitis_2.
diagnosis(pancreatitis) :-
  askif(abdominal_pain), symptom_pancreatitis, patient_history_pancreatitis, physical_findings_pancreatitis_3.
diagnosis(pancreatitis) :-
  askif(abdominal_pain), symptom_pancreatitis, patient_history_pancreatitis, physical_findings_pancreatitis_4.
diagnosis(pancreatitis) :-
  askif(abdominal_pain), symptom_pancreatitis, patient_history_pancreatitis, physical_findings_pancreatitis_5.
diagnosis(cirrhosis) :- askif(abdominal_pain), symptom_cirrhosis_1, symptom_cirrhosis_2, symptom_cirrhosis_3, symptom_cirrhosis_4.
diagnosis(tetanus) :- tetanus_vacc, askif(abdominal_pain), symptom_tetanus_1, symptom_tetanus_3, symptom_tetanus_4, symptom_tetanus_5, tetanus_trigger.
diagnosis(tetanus) :- tetanus_vacc, symptom_tetanus_1, symptom_tetanus_2,  tetanus_trigger.
diagnosis(rabies) :- rabies_vacc, animal_bite, symptom_rabies_1, symptom_rabies_2, symptom_rabies_3, symptom_rabies_4.
diagnosis(asthma) :- symptom_asthma, patient_history_asthma, physical_findings_asthma.
diagnosis(myocardial_infarction) :- symptom_myocardial_infarction, physical_findings_myocardial_infarction.
diagnosis(myocardial_infarction) :- symptom_myocardial_infarction, lifestyle_factors.
diagnosis(stroke) :- symptom_stroke.
diagnosis(meningitis) :- symptom_meningitis_child.
diagnosis(meningitis) :- symptom_meningitis_1, symptom_meningitis_2, symptom_meningitis_3, symptom_meningitis_4, symptom_meningitis_5, symptom_meningitis_history.
diagnosis(gout) :- symptom_gout_symptom_1, gout_history, gout_trigger.
diagnosis(gout) :- symptom_gout_symptom_2, gout_history, gout_trigger.
diagnosis(default).

/* Definitions of intermediate predicates */
nausea_and_vomiting :- askif(nausea), askif(vomiting). %-- 1pt
%---
mantrels_score :- symptom_appendicitis_2, symptom_appendicitis_3, symptom_appendicitis_4, symptom_appendicitis_5.
mantrels_score :- symptom_appendicitis_6, symptom_appendicitis_3, symptom_appendicitis_4, symptom_appendicitis_5.
mantrels_score :- symptom_appendicitis_2, symptom_appendicitis_6, symptom_appendicitis_4, symptom_appendicitis_5.
mantrels_score :- symptom_appendicitis_2, symptom_appendicitis_3, symptom_appendicitis_6, symptom_appendicitis_5.
mantrels_score :- symptom_appendicitis_2, symptom_appendicitis_3, symptom_appendicitis_4, symptom_appendicitis_6.
%---
symptom_appendicitis_1 :- askif(rebound_tenderness). %-- 3 pts
symptom_appendicitis_2 :- askif(child), askif(hemiscrotum). %-- 1pt
symptom_appendicitis_2 :- askif(woman), askif(pregnant), askif(first_quarter), askif(rlq). %-- 1pt
symptom_appendicitis_2 :- askif(woman), askif(pregnant), askifnot(first_quarter), askif(ruq). %-- 1pt
symptom_appendicitis_2 :- askif(periumbilical), askif(rlq). %-- 1pt
symptom_appendicitis_2 :- askif(avoid_pain), askif(rlq). %-- 1pt
symptom_appendicitis_3 :- askif(anorexia). %-- 1pt
symptom_appendicitis_4 :- nausea_and_vomiting.
symptom_appendicitis_5 :- askif(fever). %-- 1 pt
symptom_appendicitis_6 :- askif(constipation). %-- 1 pt
symptom_appendicitis_6 :- askif(diarrhea). %-- 1 pt
%---
symptom_pancreatitis :- askif(severe_constant_pain), askif(upper_ab).
symptom_pancreatitis :- nausea_and_vomiting.
symptom_pancreatitis :- askif(diarrhea).
patient_history_pancreatitis  :- askif(recent_operation).
patient_history_pancreatitis  :- askif(history_hypertriglyceridemia).
patient_history_pancreatitis  :- askif(alcoholism).
physical_findings_pancreatitis_1  :- askif(fever), askif(tachycardia).
physical_findings_pancreatitis_1  :- askif(hypotension).
physical_findings_pancreatitis_2  :- askif(rebound_tenderness).
physical_findings_pancreatitis_3  :- askif(jaundice).
physical_findings_pancreatitis_4  :- askif(dyspnea).
physical_findings_pancreatitis_5  :- askif(hematemesis).
physical_findings_pancreatitis_5  :- askif(melena).
physical_findings_pancreatitis_5  :- askif(pale), askif(diaphoretic), askif(listless_appearance).
%---
symptom_asthma :- askif(wheezing).
symptom_asthma :- askif(coughing).
symptom_asthma :- askif(dyspnea).
patient_history_asthma :- askif(history_asthma).
patient_history_asthma :- askif(history_allergy).
patient_history_asthma :- askif(history_sinusitis).
patient_history_asthma :- askif(history_eczema).
patient_history_asthma :- askif(history_polyps).
patient_history_asthma :- askif(smoker).
physical_findings_asthma :- askif(episodic).
%---
symptom_myocardial_infarction :- askif(chest_pain), askif(fatigue).
symptom_myocardial_infarction :- askif(chest_pain), askif(chest_pain_char_1).
symptom_myocardial_infarction :- askif(chest_pain), askif(chest_pain_char_2).
symptom_myocardial_infarction :- askif(chest_pain), askif(chest_pain_char_3).
symptom_myocardial_infarction :- askif(chest_pain), askif(chest_pain_char_4).
symptom_myocardial_infarction :- askif(chest_pain), askif(malaise).
vital_signs_myocardial_infarction :- askif(tachycardia).
vital_signs_myocardial_infarction :- askif(ventricular_ectopy).
vital_signs_myocardial_infarction :- askif(hypertension).
vital_signs_myocardial_infarction :- askif(hypotension), askif(cardiogenic_shock).
vital_signs_myocardial_infarction :- askif(respiratory_rate).
vital_signs_myocardial_infarction :- askif(coughing), askif(wheezing).
physical_findings_myocardial_infarction :- vital_signs_myocardial_infarction.
physical_findings_myocardial_infarction :- askif(rales).
lifestyle_factors :- askif(smoker), askif(history_cad), askif(hypertension), askif(senior_citizen).
%---
symptom_stroke :- askif(paralysis).
symptom_stroke :- askif(hemisensory).
symptom_stroke :- askif(visual_loss).
symptom_stroke :- askif(diplopia).
symptom_stroke :- askif(dysarthria).
symptom_stroke :- askif(facial_droop).
symptom_stroke :- askif(ataxia).
symptom_stroke :- askif(nystagmus).
symptom_stroke :- askif(aphasia).
%---
symptom_meningitis_1 :- askif(fever).
symptom_meningitis_1 :- askif(headache).
symptom_meningitis_1 :- askif(confusion).
symptom_meningitis_2 :- askif(stiffneck).
symptom_meningitis_2 :- askif(musclepain).
symptom_meningitis_3 :- askif(nausea).
symptom_meningitis_3 :- askif(vomiting).
symptom_meningitis_4 :- askif(sleepy).
symptom_meningitis_5 :- askif(irritlight).
symptom_meningitis_history :- askif(westnile).
symptom_meningitis_history :- askif(mosquitobite).
symptom_meningitis_history :- askif(exposed_to_child_with_fever).
symptom_meningitis_child:- askif(child), askif(bulgingfont), askif(cryingwhencarry), askif(decreasemusc).
%---
symptom_gout_symptom_1 :- askif(jointswell).
symptom_gout_symptom_1 :- askif(jointpain).
symptom_gout_symptom_2 :- askif(musclepain), askif(fever).
gout_history :- askif(familygout).
gout_trigger :- askif(gouttrigger).
%---
symptom_tetanus_1 :- askif(headache).
symptom_tetanus_1 :- askif(musclepain).
symptom_tetanus_1 :- askif(stiffneck).
symptom_tetanus_2 :- askif(risussardonicus).
symptom_tetanus_2 :- askif(jawpain).
symptom_tetanus_3 :- askif(legsextened).
symptom_tetanus_4 :- askif(difficultswallow).
symptom_tetanus_5 :- askif(seizure).
symptom_tetanus_5 :- askif(spasms).
tetanus_vacc :- askifnot(tetanusvacc).
tetanus_trigger :- askif(wounded).
%---
animal_bite :- askif(animalbite).
rabies_vacc :- askifnot(rabies_vacc).
symptom_rabies_1 :- askif(fever).
symptom_rabies_1 :- askif(chills).
symptom_rabies_1 :- askif(sorethroat).
symptom_rabies_2 :- askif(decreasemusc).
symptom_rabies_2 :- askif(anorexia).
symptom_rabies_3 :- askif(nausea).
symptom_rabies_3 :- askif(vomiting).
symptom_rabies_3 :- askif(diarrhea).
symptom_rabies_4 :- askif(malaise).
symptom_rabies_4 :- askif(anxiety).
symptom_rabies_4 :- askif(insomnia).
symptom_rabies_4 :- askif(depression).
symptom_rabies_4 :- askif(confusion).
%---
symptom_cirrhosis_1 :- askif(fatigue).
symptom_cirrhosis_2 :- askif(anorexia).
symptom_cirrhosis_2 :- askif(decreasemusc).
symptom_cirrhosis_3 :- askif(jaundice).
symptom_cirrhosis_4 :- askif(angiomas).
symptom_cirrhosis_4 :- askif(reddishpalms).
symptom_cirrhosis_4 :- askif(whitenails_lunula).
symptom_cirrhosis_4 :- askif(fingercubbing).

/* Diagnosis decoding */
start_diagnosis(D) :- diagnosis(X), diagnosis_code(X,D).
diagnosis_code(appendicitis,'The patient probably has acute appendicitis').
diagnosis_code(pancreatitis,'The patient probably has acute pancreatitis').
diagnosis_code(asthma,'The patient probably has acute asthma').
diagnosis_code(myocardial_infarction,'The patient probably has acute myocardial infarction').
diagnosis_code(stroke,'The patient probably has acute ischemic stroke').
diagnosis_code(meningitis, 'The patient probably has meningitis').
diagnosis_code(gout, 'The patient probably has Gout').
diagnosis_code(tetanus, 'The patient probably has Tetanus').
diagnosis_code(rabies, 'The patient probably has Rabies').
diagnosis_code(cirrhosis, 'The patient probably has Cirrhosis').
diagnosis_code(default,'Sorry, I dont seem to be able to diagnose the disease').

/* Question decoding */
questioncode(child, 'Is the patient a child').
questioncode(woman, 'Is the patient a woman').
questioncode(pregnant, 'Is the patient pregnant').
questioncode(first_quarter, 'Is the patient in the early stage of pregnancy (1st quarter)').
questioncode(hemiscrotum,'Does the patient have an inflamed hemiscrotum').
questioncode(abdominal_pain,'Does the patient have abdominal pain').
questioncode(periumbilical,'Is the abdominal pain around the umbilicus area').
questioncode(rlq,'Is the abdominal migrating to the right lower quadrant area').
questioncode(ruq,'Is the abdominal migrating to the right upper quadrant area').
questioncode(avoid_pain,
  'When the patient is lying down, flexing her hips and pushing up her legs, does the patient feel reduced abdominal pain').
questioncode(rebound_tenderness, 'When the affected area is touched, does the patient feels pain or discomfort').
questioncode(nausea,'Does the patient have a feeling of illness or discomfort in the digestive system').
questioncode(anorexia,'Does the patient experience loss of appetite').
questioncode(vomiting,'Does the patient vomit and feel pain afterwards').
questioncode(diarrhea,'Does the patient have diarrhea').
questioncode(constipation,'Does the patient have constipation').
questioncode(duration,'Does the duration of symptoms is less than 48 hours').
questioncode(fever,'Does the patient have fever').
questioncode(severe_constant_pain,'Is the pain severe and constant').
questioncode(upper_ab,'Is the abdominal pain around the upper abdomen').
questioncode(recent_operation,'Does the patient have a recent history of operative or other invasive procedures').
questioncode(history_hypertriglyceridemia, 'Does the patient have a family history of hypertriglyceridemia').
questioncode(alcoholism,'Does the patient have a previous biliary colic and binge alcohol consumption').
questioncode(tachycardia,'Does the patient have a rapid resting heart rate above 100 beats per minute').
questioncode(hypotension,'Does the patient have an abnormally low blood pressure').
questioncode(jaundice,'Does the patient manifests a morbid condition of jaundice').
questioncode(dyspnea,'Does the patient shows sign of shortness of breath').
questioncode(hematemesis, 'Is the patient vomiting blood').
questioncode(melena,'Does the patient discharges a passage of dark, tarry stools containing blood').
questioncode(pale,'Does the patient have a light color').
questioncode(diaphoretic,'Does the patient excessively generating sweat or perspiration').
questioncode(listless_appearance,'Does the patient lacks energy, enthusiasm, or liveliness').
questioncode(wheezing,'Is there a continuous, coarse, whistling sound produced in the respiratory airways during breathing').
questioncode(coughing,'Is the patient coughing').
questioncode(chest_pain,'Does the patient have chest tightness or pain').
questioncode(history_asthma,'Does the patient have a family history of asthma').
questioncode(history_allergy,'Does the patient have a family history of allergy').
questioncode(history_sinusitis,'Does the patient have a family history of sinusitis').
questioncode(history_eczema,'Does the patient have a family history of eczema').
questioncode(history_polyps,'Does the patient have a family history of nasal polyps').
questioncode(smoker,'Does the patient have a history of smoking').
questioncode(episodic,'Does the patient have a sporadic airflow obstruction').
questioncode(fatigue,'Does the patient have a weariness caused by exertion (exhaustion)').
questioncode(malaise,'Does the patient have a feeling of general bodily discomfort, fatigue or unpleasantness,').
questioncode(chest_pain_char_1,'Is it intense and unremitting for 30-60 minutes').
questioncode(chest_pain_char_2,'Is the pain situated under the sternum, spreading to neck, shoulder, jaw and left arm').
questioncode(chest_pain_char_3,'Is the pain like a substernal pressure sensation that also may be characterized as squeezing, aching, burning, or even sharp').
questioncode(chest_pain_char_4,'Is the pain located in epigastric region, with a feeling of indigestion or of fullness and gas').
questioncode(ventricular_ectopy,'Does the patient have an irregular pulse').
questioncode(hypertension,'Does the patient have a high blood pressure').
questioncode(cardiogenic_shock,'Does the patient have a cardiogenic shock').
questioncode(respiratory_rate,'Is the patient breathing fast').
questioncode(history_cad,'Does the patient have a family history of coronary artery disease').
questioncode(senior_citizen,'Is the patient a senior citizen').
questioncode(rales,'Does the patient have an abnormal clicking, rattling or crackling sound heard with a stethoscope').
questioncode(paralysis,'Does the patient have hemiparesis, monoparesis, or quadriparesis').
questioncode(hemisensory,'Does the patient have a loss of feeling on one side of the body').
questioncode(visual_loss,'Does the patient lose his/her vision').
questioncode(diplopia,'Does the patient have a condition where one perceives two images or double vision').
questioncode(dysarthria,'Does the patient have difficulty in articulating words').
questioncode(facial_droop,'Does the patient have one corner of their mouth to droop').
questioncode(ataxia,'Does the patient shows lack of coordination while performing voluntary movements').
questioncode(nystagmus,'Does the patient shows rapid involuntary eye movement').
questioncode(aphasia,'Does the patient lose partial or total language skills').
questioncode(headache,'Does the patient experience headaches').
questioncode(stiffneck,'Does the patient have neck pains').
questioncode(musclepain,'Does the patient have muscle pains').
questioncode(confusion,'Does the patient experience confusion').
questioncode(bulgingfont,'Does the patient have bulging fontanelle').
questioncode(cryingwhencarry,'Does the patient cry when carried').
questioncode(decreasemusc,'Does the patient have decreased muscle tone').
questioncode(sleepy,'Does the patient always feel sleepy').
questioncode(irritlight,'Does the patient gets irritated with lights').
questioncode(westnile,'Does the patient have history of travel to West Nile').
questioncode(mosquitobite,'Was the patient bitten by a mosquito').
questioncode(exposed_to_child_with_fever,'Was the patient exposed to a child with fever').
questioncode(jointswell,'Does the patient have reddish swelling of joints in fingers or toes').
questioncode(jointpain,'Does the patient experience pain of the instep, wrist, elbow, knee and ankle').
questioncode(familygout, 'Does the patient have a family history of Gout?').
questioncode(gouttrigger, 'Does the patient experience the pain and swelling after eating seafoods, organ meat or drinking beer').
questioncode(jawpain, 'Does the patient experience jaw pain').
questioncode(risussardonicus, 'Does the patient show a permanent grin with lips getting thinner ').
questioncode(legsextended, 'Does the patient show unusually long or extended legs ').
questioncode(difficultswallow, 'Does the patient have diffulty to swallow').
questioncode(seizure, 'Does the patient experience episodes of seizure ').
questioncode(spasms, 'Does the patient experince spasms').
questioncode(tetanusvacc, 'Is the patient vaccinated with tetanus immunization').
questioncode(wounded, 'Is the patient wounded').
questioncode(animalbite,'Was the patient bitten by or scratched by an animal').
questioncode(rabies_vacc, 'Is the patient vaccinated with rabies immunization').
questioncode(chills, 'Is the patient experiencing chills').
questioncode(sorethroat, 'Does the patient have sorethroat').
questioncode(anxiety, 'Does the patient feel uneasy or anxious about something').
questioncode(insomnia, 'Does the patient have difficulty sleeping').
questioncode(depression, 'Does the patient experience depression').
questioncode(angiomas, 'Does the patient have swollen blood vessels that looks like spiderwebs just below the skin').
questioncode(reddishpalms, 'Does the patient have unusual reddish palms').
questioncode(whitenails_lunula, 'Does the nails of the patient turn white and the lunula start to disappear').
questioncode(fingercubbing, 'Does the patient experience finger clubbing').