;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MODEL VARIABLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

extensions [
  rnd
  profiler
  stats
]

breed [energy_consumers energy_consumer]
breed [energy_technologies energy_technology]

globals [
  ;STATISTICAL ANALYSIS VARIABLES
  dataframe

  ;SENSITIVITY ANALYSIS VARIABLES
  lhs_experiment_number
  experiment_ID
  lhs_matrix

  ;EXPERIMENTAL VARIABLES
  seed

  ;ENERGY TECHNOLOGY VARIABLES
  technologies
  tech_attributes
  PV_AttPerf_list
  EV_AttPerf_list
  HP_AttPerf_list

  ;VALUE VARIABLES
  win_schwartz_matrix
  win_segments
  schwartz_values
  cultural_value_system

  ;SCHWARTZ VALUE INDICES (CONVENIENCE VARIABLES)
  HED_index
  STM_index
  SD_index
  UNI_index
  BEN_index
  CT_index
  SEC_index
  POW_index
  ACH_index

  ;WIN (Waarden In Nederland) SEGMENT VARIABLES
  broad_mind
  social_mind
  caring_faithful
  conservative
  hedonist
  materialist
  professional
  balanced_mind

  ;POPULATION LEVEL ATTITUDE VARIABLES
  PV_sentiment
  EV_sentiment
  HP_sentiment

  ;POPULATION LEVEL METRICS
  population_awareness_level
  population_confidence_level
  societal_threat_level
  societal_uncertainty_level
]

;Energy technologies are objects with (fixed) state variables (i.e. performance on each attribute is relative to the performance on that attribute of a modal counterpart)
energy_technologies-own [
  tech_type
  attribute_performance_list
  purchasing_cost
  operating_cost
  comfort
  safety
  environment
  autonomy
  privacy
  visible?
  highly_differentiated?
]

links-own [
  strength
  link_type
]

energy_consumers-own [

  ;VISUALIZATION
  default_color

  ;Waarden-In-Nederland (WIN) SEGMENT VARIABELS
  win_segment
  win_schwartz

  ;SOCIAL NETWORK VARIABLES
  social_distance
  n_social_links

  ;VALUE SYSTEM VARIABLES (LISTS)
  schwartz_memory
  schwartz_value_system
  value_system_extremities
  ideological_engagement

  ;SCHWARTZ VALUE VARIABLES
  hedonism
  stimulation
  self_direction
  universalism
  benevolence
  conformity_tradition
  security
  power
  achievement

  ;PERSONALITY TRAIT VARIABLES
  openness_to_experience
  narrow_mindedness
  extroversion
  introversion
  individuality
  non_conformism
  need_for_cognition
  conspiracy_thinking

  ;POLITICAL PARTISANSHIP
  liberalism
  conservatism

  ;HOT INTERACTION VARIABLES
  social_status
  peer_values
  link_strengths
  local_majority_mean
  partner
  value_dissimilarity
  influence_weight
  tolerance_threshold
  polarity_threshold
  interaction_outcome

  ;COLD INTERACTION VARIABLES
  communication_state
  AttPerf_interesting_level
  tech_att_ID
  sender_ID
  receiver_ID

  ;FACTUAL BELIEF (factBelief) VARIABLES (LISTS)
  FactStatement_AttPerf_PV
  ConfidenceWeight_AttPerf_PV
  FactStatement_AttPerf_EV
  ConfidenceWeight_AttPerf_EV
  FactStatement_AttPerf_HP
  ConfidenceWeight_AttPerf_HP

  ;INFORMATION EXPOSURE VARIABLES (BOOLEANS)
  tech_ownership?
  first_hand_experience?
  media_exposure?
  word_of_mouth?
  surprised?

  ;MEDIA BEHAVIOR & EXPOSURE VARIABLES
  media_exposure
  media_type
  media_content
  expertmedia_exposure
  massmedia_exposure
  nichemedia_exposure
  hot_media_dependence
  cold_media_dependence
  social_media_behavior
  mean_world_syndrome

  ;ONTOLOGICAL SECURITY & EXISTENTIAL ANXIETY VARIABLES
  perceived_threat
  experienced_uncertainty

  ;ATTITUDE VARIABLES
  utilitarian_scores
  value_expressive_scores
  social_adjustive_scores
  PV_attitude
  EV_attitude
  HP_attitude

  ;AWARENESS VARIABLES
  PV_awareness
  EV_awareness
  HP_awareness
]

;;;;;;;;;;;;;;;;;;;;;;;; STATISTICS PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to show-correlations
  set dataframe stats:newtable
  stats:set-names dataframe ["HED" "STM" "SD" "UNIV" "BEN" "CT" "SEC" "POW" "ACH"]

  let N count energy_consumers
  let teller 0
  while [teller < N] [
    let x0 [hedonism] of energy_consumer teller
    let x1 [stimulation] of energy_consumer teller
    let x2 [self_direction] of energy_consumer teller
    let x3 [universalism] of energy_consumer teller
    let x4 [benevolence] of energy_consumer teller
    let x5 [conformity_tradition] of energy_consumer teller
    let x6 [security] of energy_consumer teller
    let x7 [power] of energy_consumer teller
    let x8 [achievement] of energy_consumer teller

    stats:add dataframe (list x0 x1 x2 x3 x4 x5 x6 x7 x8)
    set teller teller + 1
  ]

  output-print " "
  output-print "Value Correlations Matrix:"
  output-type "Interaction Round:" output-print ticks
  let correlations stats:correlation dataframe
  output-print stats:print-correlation dataframe
end

to show-descriptives
  output-print " "
  output-print "HEDONISM:"
  output-type "Median:" output-print median stats:get-observations dataframe "HED"
  output-type "Mean:" output-print mean stats:get-observations dataframe "HED"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "HED"
  output-print " "
  output-print "STIMULATION:"
  output-type "Median:" output-print median stats:get-observations dataframe "STM"
  output-type "Mean:" output-print mean stats:get-observations dataframe "STM"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "STM"
  output-print " "
  output-print "SELF-DIRECTION:"
  output-type "Median:" output-print median stats:get-observations dataframe "SD"
  output-type "Mean:" output-print mean stats:get-observations dataframe "SD"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "SD"
  output-print " "
  output-print "UNIVERSALISM:"
  output-type "Median:" output-print median stats:get-observations dataframe "UNIV"
  output-type "Mean:" output-print mean stats:get-observations dataframe "UNIV"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "UNIV"
  output-print " "
  output-print "BENEVOLENCE:"
  output-type "Median:" output-print median stats:get-observations dataframe "BEN"
  output-type "Mean:" output-print mean stats:get-observations dataframe "BEN"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "BEN"
  output-print " "
  output-print "CONFORMITY & TRADITION:"
  output-type "Median:" output-print median stats:get-observations dataframe "CT"
  output-type "Mean:" output-print mean stats:get-observations dataframe "CT"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "CT"
  output-print " "
  output-print "SECURITY:"
  output-type "Median:" output-print median stats:get-observations dataframe "SEC"
  output-type "Mean:" output-print mean stats:get-observations dataframe "SEC"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "SEC"
  output-print " "
  output-print "POWER:"
  output-type "Median:" output-print median stats:get-observations dataframe "POW"
  output-type "Mean:" output-print mean stats:get-observations dataframe "POW"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "POW"
  output-print " "
  output-print "ACHIEVEMENT:"
  output-type "Median:" output-print median stats:get-observations dataframe "ACH"
  output-type "Mean:" output-print mean stats:get-observations dataframe "ACH"
  output-type "StDev:" output-print standard-deviation stats:get-observations dataframe "ACH"
  output-print " "
end


;;;;;;;;;;;;;;;;;;;;;;;; SETTING UP SIMULATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  ;NOTE: the 'clear-all' command is omitted due to conflict with BehaviorSpace procedures.
  clear-ticks
  clear-turtles
  clear-patches
  clear-drawing
  clear-all-plots
  clear-output
  reset-ticks

  profiler:reset

  ;Initiate global variables:
  set-globals

  ;If sensitivity analysis is activated, then calibrate model parameters according to LHS samples:
  if sensitivity_analysis? [setup-lhs-parameter-settings]

  ;If default settings is activated? then run model with default settings for all variables.
  if default_settings? [default-settings-all-vars]

  ;When hypothesis testing is activated, unfix all hypothesis testing variables (default-settings-hypothesis-testing-vars) in order to enable manipulation during BehaviorSpace experiments.
  if hypothesis_testing? [
    default-settings-booleans
;    default-settings-hypothesis-testing-vars
    default-settings-culture-MLI-vars
    default-settings-sim-model
    default-settings-sim-variables
    default-settings-value-system-calibration
    default-settings-non-experimental-vars
  ]

  ;When introspection testing is activated, unfix all introspection testing variables in order to enable manipulation during BehaviorSpace experiments.
  ;Also unfix intial value system calibration setting
  if introspection_testing? [
    ;'introspection-experiment-settings-booleans' activates ONLY introspection model
    introspection-experiment-settings-booleans
    default-settings-hypothesis-testing-vars
    default-settings-culture-MLI-vars
    default-settings-sim-model
    default-settings-sim-variables
;    default-settings-value-system-calibration
    default-settings-non-experimental-vars
  ]

;When culturalization testing is activated, unfix all culturalization testing variables (default-settings-culture-MLI-vars) in order to enable manipulation during BehaviorSpace experiments.
  if culturalization_testing? [
    default-settings-booleans
    default-settings-hypothesis-testing-vars
;    default-settings-culture-MLI-vars
    default-settings-sim-model
    default-settings-sim-variables
    default-settings-value-system-calibration
    default-settings-non-experimental-vars
  ]

  ;When SIM model testing is activated, unfix the SIM model (default-settings-sim-model) & initial value system calibration settings in order to enable manipulation during BehaviorSpace experiments.
  if sim_testing? [

    ifelse activate_only_sim? [
      SIM-experiment-settings-booleans
    ][
      default-settings-booleans
    ]

    default-settings-hypothesis-testing-vars
    default-settings-culture-MLI-vars
;    default-settings-sim-model
    default-settings-sim-variables
;    default-settings-value-system-calibration
    default-settings-non-experimental-vars
  ]

  ;When SIM variable testing is activated, unfix the SIM variables (default-settings-sim-variables) in order to enable manipulation during BehaviorSpace experiments.
  if sim_variable_testing? [

    ifelse activate_only_sim? [
      SIM-experiment-settings-booleans
    ][
      default-settings-booleans
    ]

    default-settings-hypothesis-testing-vars
    default-settings-culture-MLI-vars
    default-settings-sim-model
;    default-settings-sim-variables
    default-settings-value-system-calibration
    default-settings-non-experimental-vars
  ]

  ;Optionally fix the seed that is fed to the pseudorandom number generator (for reproducibility):
  if fix_seed? [fix-seed]

  ;Spawn energy_consumers and reset their information exposure state variables:
  load-energy_consumers
  reset-agent-information-exposure-states

  ;Spawn energy technology objects and calibrate their state variables:
  load-energy-technologies

  if count energy_consumers = 0 [
    error "WARNING: number of energy_consumers is set to zero! setup cannot be executed"
  ]

  ;Use global variables to allocate energy_consumers to WIN segments, construct Schwartz value systems, load factual beliefs and build the social network:
  load-win-segments
  load-win-schwartz
  load-factual-beliefs
  build-social-network

  ;Create convenience variables:
  update-schwartz-value-variables
  update-cultural-value-system

  ;Initiate agent personality heterogeneity:
  update-subjective-agent-variables

  ;Calibrate attitudes & sentiments for first tick
  execute-attitude-computation
  calculate-CET-sentiments

  ;Calibrate societal awareness & confidence levels for first tick
  execute-awareness-computation
  execute-confidence-computation

  ;Calibrate societal threat and uncertainty for first tick
  update-societal-threat-and-uncertainty

  output-print "Setup succesfull!"
  output-print " "
  output-print "Initial Value System settings:"
  output-print "1 = Dutch Culture"
  output-print "2 = Uniform (random)"
  output-print " "
  output-print "View Mode settings:"
  output-print "1 = None"
  output-print "2 = Trust (green = trust, red = mistrust, white = neutral"
  output-print "3 = Word-of-mouth process"
  output-print " "
  output-print "Factual Statement settings:"
  output-print "1 = Zero"
  output-print "2 = Random"
  output-print "3 = Perfect"
  output-print " "
  output-print "Confidence Weight settings:"
  output-print "1 = Random"
  output-print "2 = Maximal"
  output-print " "
  output-print "Social Interaction & Influence Model settings:"
  output-print "1 = Assimilation"
  output-print "2 = Biased assimilation"
  output-print "3 = Biased assimilation and repulsion"
  output-print "4 = Biased assimilation, repulsion and optimal distinctiveness"


  if profiler? [
    output-print "Profiler activated! Please wait 50 ticks for result..."
    profiler:start
    repeat 50 [ go ]
    profiler:stop
    output-print profiler:report
  ]

end

to go
  if (ticks < 1) [reset-timer]

  ;Update / reset important variables before the start of a new round of agent interaction:
  update-subjective-agent-variables
  update-societal-threat-and-uncertainty
  reset-agent-information-exposure-states

  ;Agents are potentially exposed to first hand experiences:
  if first_hand_exp? [activate-first-hand-experience]

  ;Agents are potentially exposed to media reports:
  if media_exp_model? [activate-media-exposure]

  ;If Social Influence Model (SIM) is switched on? Then agents engage in social interaction:
  if social_influence_model? [initiate-hot-agent-interaction]

  ;Agents potentially engage in introspection:
  if introspection? [activate-introspection]

  ;Update value system variables after activation micro-, meso- and/or macro-level drivers of belief system change:
  update-schwartz-value-variables
  update-cultural-value-system

  ;Only calculate attitudes every Xth tick, where X = output_tick_discretization
  ;This is done because the procedures behind calculating attitudes are most computationally intensive

  if output_tick_discretization? [
    ifelse ticks mod output_tick_discretization = 0 [
      set calculate_attitudes? true
      set calculate_awareness_confidence? true
    ][
      set calculate_attitudes? false
      set calculate_awareness_confidence? false
    ]
  ]

  if calculate_attitudes? [
    ;Compute attitudes for each energy technology included in the model:
    execute-attitude-computation
    calculate-CET-sentiments
  ]

  if calculate_awareness_confidence? [
    ;Compute the 'societal awareness level' (this indicates the overall knowledgeability of agents with regards to the performance of various energy technologies on a certain set of attributes).
    execute-awareness-computation
    ;Compute the general level of confidence within agent population: this represents the overall degree of every agent's perceived veracity of the factual beliefs it holds.
    execute-confidence-computation
  ]

  ;Activate visualization procedures:
  ifelse view_mode = 2 [
    visualize-trust
  ][
    ask links [set color white]
  ]

  if plot_social_links? [plot-social-links]
  if plot_ideological_engagement? [plot-ideological-engagement]
  if time_series_plots? [do-time-series-plots]
  if histogram_plots? [do-histogram-plots]
  if timer? [plot-timer]

  tick

  if ticks = n_ticks [
    output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")
    stop
  ]

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETUP PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to fix-seed
  random-seed seed
end

to load-energy_consumers
  create-energy_consumers number_of_energy_consumers
  ;Ask energy_consumers to initialize static variables.
  ask energy_consumers
  [
    set shape "circle"
    ;random shading helps distinguish nodes from one another
    set default_color cyan + 3 - (2 * random-float 3)

    ifelse random-float 1 <= social_media_users [
      set social_media_behavior "active"
    ][
      set social_media_behavior "non-active"
    ]

    ;Set pseudo-random initial agent level of 'mean_world_syndrome'.
    set mean_world_syndrome SPECIFY-FLOOR-CEILING! (random-normal 0.5 0.25) 0.001 0.999
    ;Initiate media exposure tellers:
    set expertmedia_exposure 1
    set massmedia_exposure 1
    set nichemedia_exposure 1
  ]
end

to load-win-segments
  ask energy_consumers [
    set win_segment (PICK-WIN-SEGMENT!)
  ]
end

to load-factual-beliefs
  ask energy_consumers
  [
    if init_factStatement_AttPerf_levels = 1 [
      set FactStatement_AttPerf_PV n-values length tech_attributes [0.001]
      set FactStatement_AttPerf_EV n-values length tech_attributes [0.001]
      set FactStatement_AttPerf_HP n-values length tech_attributes [0.001]
    ]
    if init_factStatement_AttPerf_levels = 2 [
      set FactStatement_AttPerf_PV n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.001 1]
      set FactStatement_AttPerf_EV n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.001 1]
      set FactStatement_AttPerf_HP n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.001 1]
    ]
    if init_factStatement_AttPerf_levels = 3 [
      set FactStatement_AttPerf_PV PV_AttPerf_list
      set FactStatement_AttPerf_EV EV_AttPerf_list
      set FactStatement_AttPerf_HP HP_AttPerf_list
    ]
    if init_confidenceWeight_AttPerf_levels = 1 [
      set ConfidenceWeight_AttPerf_PV n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.05 0.95]
      set ConfidenceWeight_AttPerf_EV n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.05 0.95]
      set ConfidenceWeight_AttPerf_HP n-values length tech_attributes [SPECIFY-FLOOR-CEILING! (random-float 1) 0.05 0.95]
    ]
    if init_confidenceWeight_AttPerf_levels = 2 [
      set ConfidenceWeight_AttPerf_PV n-values length tech_attributes [0.95]
      set ConfidenceWeight_AttPerf_EV n-values length tech_attributes [0.95]
      set ConfidenceWeight_AttPerf_HP n-values length tech_attributes [0.95]
    ]
  ]
end

to reset-agent-information-exposure-states
  ask energy_consumers [
    reset-info-exposure-states
    set color default_color
  ]
end

to load-energy-technologies
  foreach technologies [
    create-energy_technologies 1 [
      ask energy_technologies [
        set tech_type item (who - count energy_consumers) technologies
      ]
    ]
  ]

  ask energy_technologies [
    set hidden? true

    ;Initiate an (empty) local list
    let init_attribute_performance_list n-values length tech_attributes [0]

    if tech_type = "PV" [
      ;Purchasing cost of PV is considered to be generally higher than that of a GRID CONNECTION.
      set init_attribute_performance_list replace-item (position "purchasing cost" tech_attributes) init_attribute_performance_list 1
      ;Operating cost of PV is considered lower than GRID CONNECTION due to the lower cost of consuming self-generated electricity vs electricity supplied by the grid.
      set init_attribute_performance_list replace-item (position "operating cost" tech_attributes) init_attribute_performance_list 0
      ;Comfort of PV is considered lower than GRID CONNECTION due to the installation and maintenance of solar electricity system and the weather-dependency of PV performance.
      set init_attribute_performance_list replace-item (position "comfort" tech_attributes) init_attribute_performance_list 0
      ;Safety of PV is considered to be similar to that of a GRID CONNECTION.
      set init_attribute_performance_list replace-item (position "safety" tech_attributes) init_attribute_performance_list 0.5
      ;Environmental performance of PV is considered to be higher to that of a GRID CONNECTION.
      set init_attribute_performance_list replace-item (position "environment" tech_attributes) init_attribute_performance_list 1
      ;The autonomy aspect of PV is considered to be higher than that of a GRID CONNECTION, since PV enables a energy_consumer to (potentially) become energy-independent.
      set init_attribute_performance_list replace-item (position "autonomy" tech_attributes) init_attribute_performance_list 1
      ;The privacy aspect of PV is considered to be higher to that of a GRID CONNECTION, since PV enables a energy_consumer to (potentially) become energy-independent which enables full concealment of its energy consumption data.
      set init_attribute_performance_list replace-item (position "privacy" tech_attributes) init_attribute_performance_list 1

      ;Solar cells are highly visible products.
      set visible? true
      ;Solar cells are not highly differentiated products in the eyes of consumers.
      set highly_differentiated? false
    ]
    if tech_type = "EV" [
      ;Purchasing cost of EV is considered to be generally higher than that of an ICEV.
      set init_attribute_performance_list replace-item (position "purchasing cost" tech_attributes) init_attribute_performance_list 1
      ;Operating cost of EV is considered lower than ICEV due to lower cost of electricity vs fuel.
      set init_attribute_performance_list replace-item (position "operating cost" tech_attributes) init_attribute_performance_list 0
      ;Comfort of EV is considered lower than ICEV due to range anxiety.
      set init_attribute_performance_list replace-item (position "comfort" tech_attributes) init_attribute_performance_list 0
      ;Safety of EV is considered to be similar to that of an ICEV.
      set init_attribute_performance_list replace-item (position "safety" tech_attributes) init_attribute_performance_list 0.5
      ;Environmental performance of EV is considered to be higher than that of an ICEV.
      set init_attribute_performance_list replace-item (position "environment" tech_attributes) init_attribute_performance_list 1
      ;Autonomy aspect of an EV is considered to be similar to that of an ICEV.
      set init_attribute_performance_list replace-item (position "autonomy" tech_attributes) init_attribute_performance_list 0.5
      ;Privacy aspect of an EV is considered to be similar to that of an ICEV.
      set init_attribute_performance_list replace-item (position "privacy" tech_attributes) init_attribute_performance_list 0.5

      ;Cars are highly visible products.
      set visible? true
      ;Cars are highly differentiated (branded) products.
      set highly_differentiated? true
    ]
    if tech_type = "Heat Pump" [
      ;Purchasing cost of HEAT PUMP is considered to be generally higher than that of GAS HEATING.
      set init_attribute_performance_list replace-item (position "purchasing cost" tech_attributes) init_attribute_performance_list 1
      ;Operating cost of HEAT PUMP is considered lower than GAS HEATING due to lower cost of electricity vs gas.
      set init_attribute_performance_list replace-item (position "operating cost" tech_attributes) init_attribute_performance_list 0
      ;Comfort of HEAT PUMP is considered lower than GAS HEATING due to installation hastles and weather-dependent performance of HEAT PUMPS.
      set init_attribute_performance_list replace-item (position "comfort" tech_attributes) init_attribute_performance_list 0
      ;Safety of HEAT PUMP is considered to be higher to that of GAS HEATING.
      set init_attribute_performance_list replace-item (position "safety" tech_attributes) init_attribute_performance_list 1
      ;Environmental performance of HEAT PUMP is considered to be higher thab that of GAS HEATING.
      set init_attribute_performance_list replace-item (position "environment" tech_attributes) init_attribute_performance_list 1
      ;Autonomy aspect of an HEAT PUMP is considered to be higher than that of GAS HEATING, because a HEAT PUMP enables a energy_consumer to disconnect from the public gas infrastructure and (potentially) become self-reliant.
      set init_attribute_performance_list replace-item (position "autonomy" tech_attributes) init_attribute_performance_list 1
      ;Privacy aspect of an HEAT PUMP is considered to be similar to that of GAS HEATING.
      set init_attribute_performance_list replace-item (position "privacy" tech_attributes) init_attribute_performance_list 0.5

      ;Building heating & cooling (heat pumps) installations are not visible products.
      set visible? false
      ;Building heating & cooling (heat pumps) installations are not strongly differentiated products in the eyes of consumers.
      set highly_differentiated? false
    ]

    set attribute_performance_list BUILD-AttPerf-LIST! init_attribute_performance_list

    ;Load attribute performance values in easy to work with convenience variables.
    set purchasing_cost item (position "purchasing cost" tech_attributes) attribute_performance_list
    set operating_cost item (position "operating cost" tech_attributes) attribute_performance_list
    set comfort item (position "comfort" tech_attributes) attribute_performance_list
    set safety item (position "safety" tech_attributes) attribute_performance_list
    set environment item (position "environment" tech_attributes) attribute_performance_list
    set autonomy item (position "autonomy" tech_attributes) attribute_performance_list
    set privacy item (position "privacy" tech_attributes) attribute_performance_list
  ]

  ;Specify the attribute performances for each clean energy tech in convenience variables that can be used throughout the model's computations.
  set PV_AttPerf_list reduce sentence [attribute_performance_list] of energy_technologies with [tech_type = "PV"]
  set EV_AttPerf_list reduce sentence [attribute_performance_list] of energy_technologies with [tech_type = "EV"]
  set HP_AttPerf_list reduce sentence [attribute_performance_list] of energy_technologies with [tech_type = "Heat Pump"]
end

to set-globals
  ;Clear a specific selection of globals (NOTE: the 'clear-all' or 'clear-globals' command is omitted due to conflicts with BehaviorSpace procedures)
  set PV_sentiment 0
  set EV_sentiment 0
  set HP_sentiment 0

  set population_awareness_level 0
  set population_confidence_level 0

  set societal_threat_level 0
  set societal_uncertainty_level 0

  ;Specificy seed for feeding into pseudorandom number generator
  set seed 123456789

  ;Specify WIN (= Waarden In Nederland) segments, Schwartz values
  set win_segments ["broad mind" "social mind" "caring faithful" "conservative" "hedonist" "materialist" "professional" "balanced mind"]
  set schwartz_values ["hedonism" "stimulation" "self-direction" "universalism" "benevolence" "conformity-tradition" "security" "power" "achievement"]

  ;Specify clean energy technologies and their respective attributes
  set technologies ["PV" "EV" "Heat Pump"]
  set tech_attributes ["purchasing cost" "operating cost" "comfort" "safety" "environment" "autonomy" "privacy"]

  ;Load indices of Schwartz values into convenience variables (to be used in calculations throughout the model)
  set HED_index position "hedonism" schwartz_values
  set STM_index position "stimulation" schwartz_values
  set SD_index position "self-direction" schwartz_values
  set CT_index position "conformity-tradition" schwartz_values
  set SEC_index position "security" schwartz_values
  set UNI_index position "universalism" schwartz_values
  set BEN_index position "benevolence" schwartz_values
  set POW_index position "power" schwartz_values
  set ACH_index position "achievement" schwartz_values

  ;Specify initial Schwartz value profiles for each WIN segment using the 'link-win-schwartz' procedure
  link-win-schwartz
end

to load-win-schwartz
  ask energy_consumers [
    if init_value_distribution = 1 [
      ;Use the WIN-Schwartz matrix (see set-globals procedure) to obtain the Schwartz value profile that belongs to the agent's WIN segment
      set win_schwartz item win_segment win_schwartz_matrix
      ;Use the "build-schwartz-value-system" function to transform the WIN-specific Shwartz value profile into value levels that range from 0 to 1
      set schwartz_value_system BUILD-SCHWARTZ-VALUE-SYSTEM! win_schwartz
    ]
    if init_value_distribution = 2 [
      ;Agent value system consists of 9 random floats ranging from 0 to 1
      set schwartz_value_system (n-values 9 [SPECIFY-FLOOR-CEILING! (random-float 1) 0.001 0.999])
    ]
  ]
end

;The 'build-social-network' makes agents link with other agents on the basis of how similar these agents are with regards to the composition of their value systems.
;That is, agents with similar value systems tend to link up with one another (a form of preferential attachment that represents homophily).
;Agents linked with one another are presumed to be 'peers', which is to say that they know each other well and generally trust one another.
;Within the context of the current model, 'peers' are considered family, friends, or acquaintances.
;The 'build-social-network' procedure also enables agents to link up randomly with other agents...
;...As a consequence, agents with quite dissimilar value systems can become linked.
;Such 'random' links are able to represent the interaction between agents that are not necessarily befriended in any way.
;In doing so, 'random' links enable the modelling of potentially hostile interactions between agents.
to build-social-network
  ;first check whether there are at least 20 agents present in the population, otherwise this procedure gives errors.
  ifelse count energy_consumers > 20 [
    if peer_group_links = 0 and random_links = 0 [
      output-print "WARNING: social network cannot be built because there are no links"
      stop
    ]

    ;Make peer group links (i.e. link with other agents that are to be considered as peers).
    repeat peer_group_links [
      ask energy_consumers [
        ;Identify potential peers
        let potential_links other energy_consumers with [not link-neighbor? myself]
        ;Filter through potential peers on the basis of their 'social distance'.
        ;'Social distance' represents the similarity in worldview(s).
        ask potential_links [
          ;Social distance is formalized as the euclidan distance of any two agent value systems.
          set social_distance (CALCULATE-EUCLIDIAN-DISTANCE! schwartz_value_system ([schwartz_value_system] of myself))
        ]
        ;The smaller the euclidian distance (the smaller the social distance), the higher the similarity of agents' value systems, the stronger the urge to link up with one another (homophily!).
        let like_minded_agent min-one-of potential_links [social_distance]
        create-link-with like_minded_agent
      ]
    ]

    ;Make N random links (N = % of total energy_consumers)
    repeat round (random_links * (count energy_consumers)) [
      ask one-of energy_consumers [
        if count my-links > 0 [
          ;Kill one of links and replace with a link that randomly connects to another agent within the simulated environment.
          ask one-of my-links [die]
          let potential_links other energy_consumers with [not link-neighbor? myself]
          create-link-with one-of potential_links
        ]
      ]
    ]

    ;Due to stochastic nature of this procedure, it can occur that sometimes there exists an agent that has not been linked with any other agent.
    ;If this is the case, the agent is identified and told to link up with a randomly selected agent within the simulated environment.
    ask energy_consumers with [count link-neighbors = 0] [
      create-link-with one-of other energy_consumers
    ]

    ;Once all agents are linked, the social network can be constructed.
    ask energy_consumers [
      setxy random-xcor random-ycor
    ]

    ;For social network visualization purposes: activate the layout-spring procedure a few dozen times.
    repeat 200 [layout-spring energy_consumers links 1 20 80]

    ;Once the network is built, ask the energy_consumers to set some static variables that are to be used throughout the model's computations.
    ask energy_consumers [
      set n_social_links count link-neighbors
      ;Node size indicates social connectivity of agent.
      set size n_social_links / 3
      ;Social status is proportional to the connectivity of an agent.
      set social_status n_social_links * social_status_persuasiveness
    ]

    ;Initialize social link strength (which is indicator of the trust that exists between pairs of agents).
    ask links [
      set strength 1
      set link_type "peer"
    ]
  ][
    stop
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PARAMETER CALIBRATION PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to SIM-experiment-settings-booleans
  set profiler? false
  set timer? false
  set time_series_plots? false
  set histogram_plots? false
  set plot_awareness? false
  set plot_confidence? false
  set plot_ideological_engagement? false
  set first_hand_exp? false
  set media_exp_model? false
  set word_of_mouth_model? false
  set cultural_bias? false
  ;ONLY ACTIVATE SIM MODEL
  set social_influence_model? true
  set social_media? false
  set value_proselytizing? true
  set value_assessment_error? true
  set culturalization? false
  set multilateral_influence? false
  set introspection? false
  set antagonistic_dynamics? false
  set mutualistic_dynamics? false
  set calculate_attitudes? false
  set calculate_awareness_confidence? false
  set plot_social_links? false
end

to introspection-experiment-settings-booleans
  set profiler? false
  set timer? false
  set time_series_plots? false
  set histogram_plots? false
  set plot_awareness? false
  set plot_confidence? false
  set plot_ideological_engagement? false
  set first_hand_exp? false
  set media_exp_model? false
  set word_of_mouth_model? false
  set cultural_bias? false
  set social_influence_model? false
  set social_media? false
  set value_proselytizing? false
  set value_assessment_error? false
  set culturalization? false
  set multilateral_influence? false
  ;ONLY ACTIVATE INTROSPECTION MODEL
  set introspection? true
  set antagonistic_dynamics? true
  set mutualistic_dynamics? true
  set calculate_attitudes? false
  set calculate_awareness_confidence? false
  set plot_social_links? false
end

to default-settings-booleans ;FIX NON-EXPERIMENTAL BOOLEANS (22x)
  set profiler? false
  set timer? false
  set time_series_plots? false
  set histogram_plots? false
  set plot_awareness? false
  set plot_confidence? false
  set plot_ideological_engagement? false
  set first_hand_exp? false
  set media_exp_model? true
  set word_of_mouth_model? true
  set cultural_bias? true
  set social_influence_model? true
  set social_media? true
  set value_proselytizing? true
  set value_assessment_error? true
  set culturalization? true
  set multilateral_influence? true
  set introspection? true
  set antagonistic_dynamics? true
  set mutualistic_dynamics? true
  set calculate_attitudes? false
  set calculate_awareness_confidence? false
  set plot_social_links? false
end

to default-settings-hypothesis-testing-vars ;FIX HYPOTHESIS TESTING VARS (8x)
  set economic_instability 0.5
  set social_instability 0.5
  set environmental_instability 0.5
  set technological_change 0.5
  set media_influence 0.1
  set mass_media_bias 0.25
  set filter_bubble 0.9
  set intentional_vs_incidental_exposure 0.8
end

to default-settings-culture-MLI-vars ;FIX CULTURE & MLI VARS (2x)
  set culturalization_strength 1
  set peer_pressure 0.25
end

to default-settings-sim-model ;FIX SIM SETTINGS (1x)
  set social_influence_model 4
end

to default-settings-sim-variables ;FIX SIM VARIABLES (5x)
  set interaction_threshold_heterogeneity 0.5
  set tolerance 0.25
  set hostility 0.25
  set individualism 0.025
  set optimal_distinctiveness 1
end

to default-settings-value-system-calibration ;FIX VALUE SYSTEM CALIBRATION SETTINGS (1x)
  set init_value_distribution 1
end

to default-settings-non-experimental-vars ;FIX NON-EXPERIMENTAL VARS (24x)
  set view_mode 1
  set n_ticks 2500
  set number_of_energy_consumers 500

  set peer_group_links 5
  set random_links 0.1

  set init_factStatement_AttPerf_levels 2
  set init_confidenceWeight_AttPerf_levels 1

  set FHE_occurence_rate 0
  set media_exposure_rate 0.82
  set information_intake_error 0.05
  set random_exposure 0.2
  set surprise_threshold 1
  set social_media_users 0.73
  set social_media_activity 0.67

  set hot_interaction_intensity 0.8
  set value_convergence 0.25
  set value_assessment_error 0.05
  set social_status_persuasiveness 0.075

  set non_conformism_strength 1
  set cultural_expectation_error 0.05

  ;Unfix introspection variables during introspection testing.
  if not introspection_testing? [
    set value_antagonism 0.5
    set value_mutualism 0.25

    set tech_disruption_scope 0.05
    set value_disruption_intensity 0.1
  ]
end

to default-settings-experimental-settings ;FIX EXPERIMENTAL (BEHAVIORSPACE) BOOLEANS (10x) AND VARS (1x)
  set fix_seed? false
  set sensitivity_analysis? false
  set default_settings? true
  set hypothesis_testing? false
  set culturalization_testing? false
  set introspection_testing? false
  set sim_testing? false
  set sim_variable_testing? false
  set activate_only_sim? false

  set output_tick_discretization? true
  set output_tick_discretization 50
end

;72x VARIABLES IN TOTAL (of which 30x BOOLEANS)
;63x model parameters
;9x experimental (BehaviorSpace) settings (booleans)
to default-settings-all-vars ;63x VARS - check in WORD

  ;7x default setting groups (the 8th is for the BehaviorSpace settings -> default-settings-experimental-settings)

  default-settings-booleans
  default-settings-hypothesis-testing-vars
  default-settings-culture-MLI-vars
  default-settings-sim-model
  default-settings-sim-variables
  default-settings-value-system-calibration
  default-settings-non-experimental-vars

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GO PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to update-subjective-agent-variables
  ask energy_consumers [
    update-personality-traits
    update-non-conformism
    update-conspiracy-thinking
    update-need-for-cognition
    update-political-partisanship
    update-existential-security
  ]
end

to update-societal-threat-and-uncertainty
  set societal_threat_level mean [perceived_threat] of energy_consumers
  set societal_uncertainty_level mean [experienced_uncertainty] of energy_consumers
end

;Load Schwartz values into agent variables (makes referencing across model procedures easier).
to update-schwartz-value-variables
  ask energy_consumers [
    set hedonism (item HED_index schwartz_value_system)
    set stimulation (item STM_index schwartz_value_system)
    set self_direction (item SD_index schwartz_value_system)
    set universalism (item UNI_index schwartz_value_system)
    set benevolence (item BEN_index schwartz_value_system)
    set conformity_tradition (item CT_index schwartz_value_system)
    set security (item SEC_index schwartz_value_system)
    set power (item POW_index schwartz_value_system)
    set achievement (item ACH_index schwartz_value_system)

    ;Update the agent's value systems in terms of their absolute deviation from the neutrality position (= 0.5).
    ;It is presumed that agent's that hold extreme values are more ideologically (politically) active
    compute-value-extremities
    set ideological_engagement reduce + value_system_extremities
  ]
end

;Calculate cultural value orientation from Schwartz value system of energy_consumers.
to update-cultural-value-system
  set cultural_value_system (list
    (mean [hedonism] of energy_consumers)
    (mean [stimulation] of energy_consumers)
    (mean [self_direction] of energy_consumers)
    (mean [universalism] of energy_consumers)
    (mean [benevolence] of energy_consumers)
    (mean [conformity_tradition] of energy_consumers)
    (mean [security] of energy_consumers)
    (mean [power] of energy_consumers)
    (mean [achievement] of energy_consumers)
  )
end

to activate-first-hand-experience
  ask n-of (FHE_occurence_rate * count energy_consumers) energy_consumers [
    set first_hand_experience? true
    activate-cold-information-processing
  ]
end


to execute-awareness-computation

  compute-awareness

  let mean_awareness_PV mean [PV_awareness] of energy_consumers
  let mean_awareness_EV mean [EV_awareness] of energy_consumers
  let mean_awareness_HP mean [HP_awareness] of energy_consumers

  ;The overall awareness level of the agent population is computed as the mean of the mean awareness levels of all agents for each energy technology.
  ;VERIFICATION: Regardless of init settings, population_awareness_level seems to converge around 240 after circa 1000 ticks.
  let awareness mean (list mean_awareness_PV mean_awareness_EV mean_awareness_HP)
  set awareness SPECIFY-FLOOR-CEILING! awareness 0.001 1000
  set population_awareness_level 1 / awareness

  if plot_awareness? [
    set-current-plot "Awareness"
    create-temporary-plot-pen "pen"
    set-current-plot-pen "pen"
    set-plot-pen-color black
    plot population_awareness_level
  ]

end

to execute-confidence-computation
  ;An agent's confidence (with regards to its factual beliefs) is considered to be indicated by the overall level of certainty tied to an agent's factual beliefs about the world.
  ;Specifically, confidence in one's factual beliefs is represented as the sum of the certainty levels related to each AttPerf level for each clean energy technology.

  ;For all agents and each energy technology: first collect the certainty levels linked to each agent's factual belief about the attribute performance levels of a particular technology,
  ;And then divide that list by the number of agents present within the simulation.

  ;Use reduce & sentence primitives to unnest list:
  let PV_factBelief_confidence reduce sentence [ConfidenceWeight_AttPerf_PV] of energy_consumers
  ;Then sum the entire list:
  set PV_factBelief_confidence reduce + PV_factBelief_confidence
  ;Calculate the mean confidence of the population with regards to their knowledgeability about PhotoVoltaics by dividing 'PV_factBelief_confidence' by the number of agents present within the simulation.
  let mean_confidence_PV PV_factBelief_confidence / count energy_consumers

  ;Do the same for EV...
  let EV_factBelief_confidence reduce sentence [ConfidenceWeight_AttPerf_EV] of energy_consumers
  set EV_factBelief_confidence reduce + EV_factBelief_confidence
  let mean_confidence_EV EV_factBelief_confidence / count energy_consumers

  ;...and finally for HeatPump (HP)...
  let HP_factBelief_confidence reduce sentence [ConfidenceWeight_AttPerf_HP] of energy_consumers
  set HP_factBelief_confidence reduce + HP_factBelief_confidence
  let mean_confidence_HP HP_factBelief_confidence / count energy_consumers

  ;The overall confidence level of the agent population is computed as the mean of the mean confidence levels of all agents for each energy technology.
  set population_confidence_level mean (list mean_confidence_PV mean_confidence_EV mean_confidence_HP)

  if plot_confidence? [
    set-current-plot "Confidence"
    create-temporary-plot-pen "pen"
    set-current-plot-pen "pen"
    set-plot-pen-color black
    plot population_confidence_level
  ]
end

;The 'activate-media-exposure' serves to model the exposure of agents to various kinds of media.
;Agents are presumed to be exposed to either expert, niche or mass media channels throughout their lives.
;All types of media are presumed to influence the agents in some way.
;Media can influence an agent's value system by altering what it believes is important/valuable in life (i.e. 'hot' influencing).
;Media can also influence an agent by altering what it believes it knows about the state of the world (i.e. 'cold' influencing).
;Niche and mass media are presumed to be dominantly 'hot', whilst expert media is presumed to be dominantly 'cold'.
to activate-media-exposure
  ;Not all agents are exposed to media in each round of interaction, the global 'media_exposure_rate' modulates this.
  ask n-of (media_exposure_rate * count energy_consumers) energy_consumers [

    set media_exposure? true

    ;When experienced uncertainty is high (low), dependence on hot media increases (decreases) (see e.g. Jackob, 2010).
    ;When number (diversity) of information sources accessible to an agent is high (low), then dependence on media decreases (increases) (see e.g. Jackob, 2010).
    ;Diversity of information sources is represented by social connectivity (i.e. an agent that knows a lot of people can obtain information from its social network instead of media channels).
    ;Cap 'hot_media_dependence' at a floor of 0.1 and ceiling of 0.9 in order to avoid it from becoming 0% or 100% (these dependency levels are not considered realistic).
    set hot_media_dependence SPECIFY-FLOOR-CEILING! (experienced_uncertainty - (n_social_links * 0.01)) 0.1 0.9

    ;If an agent does NOT own a technology, the only way to obtain factual information about a clean energy technology is through 'cold' media (e.g. expert reports).
    ;If an agent owns a technology, it is able to experience its performance on a first-hand basis; obtaining factual knowledge about the technology in doing so.
    ifelse tech_ownership? [
      ;It is presumed that some technical information regarding product performance cannot be obtained through first-hand experience and must therefore be obtained through expert media.
      ;Hence, technology ownership will decrease, but not entirely negate cold media dependence.
      set cold_media_dependence SPECIFY-FLOOR-CEILING! (random-normal 0.5 0.1) 0 1
    ][
      ;If an agent does not own a technology, the only way to obtain factual and/or technical information about it is through expert media.
      set cold_media_dependence 1
    ]

    ;Determine whether the agent is perceiving a certain media type intentionally or incidentally.
    ifelse random-float 1 < intentional_vs_incidental_exposure [
      set media_exposure "intentional"
    ][
      set media_exposure "incidental"
    ]

    ;If an agent is intentionally perceiving a media type, determine the kind of media type the agent chooses to perceive.
    if media_exposure = "intentional" [
      let media_types ["expert" "niche" "mass"]

      ;It is presumed that agents with a high need for cognition tend to select expert media.
      let weight_expert need_for_cognition
      ;It is presumed that non-conformists and conspiracy thinkers tend to select niche media.
      let weight_niche (non_conformism + conspiracy_thinking) / 2
      ;It is presumed that traditional agents tend to select mass media.
      ;It is presumed that experienced uncertainty increases an agent's tendency to select mass (mainstream) media (hive / herd mentality).
      let uncertainty -0.5 + experienced_uncertainty
      let weight_mass ((security + conformity_tradition + benevolence) / 3) * (1 + uncertainty)

      ;Make a list of weights.
      let weights (list weight_expert weight_niche weight_mass)
      ;Make a list of list of paired media types and weights.
      let pairs (map list media_types weights)
      ;Set media type as the first item of a pair selected using the second item (i.e. "last i") as the weight.
      ;Media types with (relatively) larger weights are more likely to be selected.
      set media_type first rnd:weighted-one-of-list pairs [ [i] -> last i ]
    ]

    ;In case media exposure is incidental, an agent is exposed randomly to a given type of media.
    if media_exposure = "incidental" [
      ;Note: a list is transformed into string using 'reduce word'.
      set media_type reduce word n-of 1 ["expert" "niche" "mass"]
    ]

    ;If an agent perceives expert media, the content will be generated randomly.
    ;If an agent perceives niche or mass media, the content will either be generated randomly or selectively based on an agent's value profile (see 'determine-hot-media-content').
    ifelse media_type = "expert" [
      ;Cold media content is presumed to be random; which means agents do not intentionally seek to obtain a specific kind of factual information within the current model.
      set media_content "random"
      set expertmedia_exposure expertmedia_exposure + 1
      activate-cold-information-processing
    ][
      ifelse media_type = "mass" [
        set massmedia_exposure massmedia_exposure + 1
      ][
        set nichemedia_exposure nichemedia_exposure + 1
      ]
      determine-hot-media-content
      activate-hot-information-processing
    ]
    ;Agents who perceive mass media more than expert media are presumed to develop a more pessimistic worldview (mean world syndrome).
    ;It is presumed that the higher the frequency of being exposed to mass vs expert media, the more pessimistic (biased) one's beliefs of socio-environmental instability.
    set mean_world_syndrome (massmedia_exposure + nichemedia_exposure) / expertmedia_exposure

    reset-info-exposure-states
  ]
end

to initiate-hot-agent-interaction
  ;The 'initiate-hot-agent-interaction' procedure makes agents pick out an other agent in order to potentially start a 'hot' interaction with.
  ;A 'hot' interaction represents a heated/opinionated discussion about what each agent perceives to be as important/valuable.
  ;A 'hot' interaction between any pair of agents generally results in them influencing one another.
  ;The influence agents exert on one another should lead to various forms of social phenomena occuring, such as for example:
  ;The convergence of agents that are tolerant to / acceptant of one another, leading to the emergence of clusters of agents with similar value systems.
  ;The bifurcation (polarization) of worldviews between sets of agents who become hostile towards one another in their need to defend their ego's and ensure ontological security.

  ;Ask energy_consumers to update their interaction thresholds:
  ;These thresholds define agent heterogeneity in interaction styles (e.g. whether an agent is extro- vs introvert? whether an agent is hostile vs tolerant? et cetera: see description of 'update-interaction-thresholds' for more details).
  update-interaction-thresholds

  ;Ticks represent ROUNDS OF INTERACTION
  ;Within any given round of interaction, energy_consumer either participate in the interaction or they don't (this is dependent upon the setting of global variable 'hot_interaction_intensity').
  ask energy_consumers [
    if random-float 1 < hot_interaction_intensity [
      if any? my-links [

        ;Important abbreviations:
        ;AA = active agent (i.e. the agent that initiates the interaction)
        ;PA = passive agent (i.e. the agent that is called upon by an active agent to engage in an interaction)
        ;t0 = pre-interaction
        ;t1 = post-interaction
        ;MLI = multilateral influence

        ;Initiate a local boolean to track whether an agent is engaging in a hot interaction through social media channels or not.
        let social_media_interaction? false

        ifelse social_media? [
          ;Check whether an agent is an active user of social media.
          ifelse social_media_behavior = "active" [
            ;If social_media_activity is high, then active users of social media tend to interact with other agents through social-media channels.
            ;If social_media_activity is low, then active users of social media tend to interact with others through non social-media channels (e.g. word of mouth).
            ifelse random-float 1 < social_media_activity [

              ;Pick an interaction partner through social media by a linking with an agent that has not yet been linked with AND that is an active social-media user.
              let target_agents other energy_consumers with [not link-neighbor? myself and social_media_behavior = "active"]

              ;Check whether potential interaction partners were identified: if this is not the case? then pick an interaction partner from peer links.
              ifelse any? target_agents [
                ;Set partner agent.
                set partner one-of target_agents
                set social_media_interaction? true
              ][
                ;If no target agents (social media), ask active agent to pick an interaction partner from peer links.
                set partner one-of link-neighbors
              ];ifelse any? target_agents
            ][
              ;If active agent is not using social media in the current interaction round, ask active agent to pick an interaction partner from peer links.
              set partner one-of link-neighbors
            ] ;ifelse random-float 1 < social_media_activity
          ][
            ;If active agent is not an active social media user, ask active agent to pick an interaction partner from peer links.
            set partner one-of link-neighbors
          ] ;ifelse social_media_behavior = "active"
        ][
          ;If social-media model is switched off, ask active agent to pick an interaction partner from peer links.
          set partner one-of link-neighbors
        ] ;ifelse social_media?

        ;Initiate a local variable that holds the index of the value that will be discussed by pairs of interacting agents.
        let target_value_index 0

        ;If value_proselytizing? is TRUE, then agents will tend to communicate about 'extreme' values rather than 'moderate' values.
        ;If value_proselytizing? is FALSE, then agents will randomly select a value to communicate about.
        ifelse value_proselytizing? [
          ;Make a list of weights (a weight is represented by the 'extremeness' of a particular value).
          let weights value_system_extremities
          ;Make a list of indices the same length as an agent's value system.
          let indices n-values (length schwartz_value_system) [i -> i]
          ;Make a list of list containing pairs of indices with respective weights.
          let pairs (map list indices weights)
          ;Set 'target_value_index' as the first item of a pair selected using the second item (i.e. "last i") as the weight.
          ;Values with (relatively) larger weights (higher extremity) are more likely to be selected.
          set target_value_index first rnd:weighted-one-of-list pairs [ [i] -> last i ]
        ][
          ;Pick a value at random from Schwartz value system.
          set target_value_index random (length schwartz_value_system)
        ]

        ;Load active agent's pre-interaction value level into a local variable.
        let AA_value_t0 (item target_value_index schwartz_value_system)
        ;Load partner agent's pre-interaction value level into a local variable.
        let PA_value_t0 (item target_value_index ([schwartz_value_system] of partner))
        ;Load cultural mean of value in a local variable.
        let cultural_mean (item target_value_index cultural_value_system)
        ;An agent's assessment of cultural mean is presumed to be imperfect; a random float is therefore added/subtracted from cultural mean.
        set cultural_mean cultural_mean + (cultural_expectation_error - (2 * random-float cultural_expectation_error))

        ;Load in social status and consequent persuasiveness of both active and partner agents.
        ;Constrain social influence to [0.5,1.5]; agents with low number of social links may not attract as much social attention as agents that are well connected.
        let AA_social_influence SPECIFY-FLOOR-CEILING! social_status 0.5 1.5
        let PA_social_influence SPECIFY-FLOOR-CEILING! [social_status] of partner 0.5 1.5

        ;If an agent's pre-interaction (t0) value level moves towards extremity it indicates ego involvement.
        ;It is presumed that values central to self-concept are less susceptible to change.
        let AA_ego_involvement abs (AA_value_t0 - 0.5)
        let PA_ego_involvement abs (PA_value_t0 - 0.5)

        ;Create (local) peer pressure variables (for executing multilateral social influence).
        let AA_multilateral_mean 0
        let PA_multilateral_mean 0
        let AA_peer_pressure_intensity 0
        let PA_peer_pressure_intensity 0

        ;An agent is presumed to be influenced by the need to conform to the expectations of its peers (i.e. the opinion or values of a local majority).
        ;This peer pressure is represented as the weighted mean of the value levels that peers of a given agent hold (local_majority_mean).
        ;Specifically, the value levels of peers (peer_values) are weigthed (multiplied) by the trust in those peers (link_strength)...
        ;...The weighted value levels are then summed and consequently divided by the sum of link strengths in order to compute an agent's 'local_majority_mean'.
        ;An agent takes this local_majority_mean into consideration when processing 'hot' information (i.e. opinions or affective beliefs).
        if multilateral_influence? [
          set peer_values [item target_value_index schwartz_value_system] of link-neighbors
          set link_strengths [strength] of my-links
          set local_majority_mean (reduce + (map * peer_values link_strengths)) / (reduce + link_strengths)
          ask partner
          [
            set peer_values [item target_value_index schwartz_value_system] of link-neighbors
            set link_strengths [strength] of my-links
            set local_majority_mean (reduce + (map * peer_values link_strengths)) / (reduce + link_strengths)
          ]
          set AA_multilateral_mean local_majority_mean
          set PA_multilateral_mean [local_majority_mean] of partner
          ;It is presumed that conformism to subculture increases as experienced uncertainty increases:
          ;This effect is represented as an increase in the 'peer pressure intensity' experienced by an agent.
          set AA_peer_pressure_intensity peer_pressure * (1 + experienced_uncertainty)
          set PA_peer_pressure_intensity peer_pressure * (1 + [experienced_uncertainty] of partner)
        ]

        ;Determine the (absolute) difference between value levels of a pair of interacting agents:
        set value_dissimilarity (abs (PA_value_t0 - AA_value_t0))

        ;Add error (noise) in the agents' assessment of each other's value levels (represents bounded knowledgeability & mental capacities of agents).
        if value_assessment_error? [
          set value_dissimilarity SPECIFY-FLOOR-CEILING! (value_dissimilarity + (value_assessment_error - 2 * random-float value_assessment_error)) 0.001 0.999
        ]

        ;Load in influence weight and interaction thresholds based on the type of Social Influence Model selected.
        ;The influence weight determines the DIRECTION, and partly the STRENGTH, of convergence or divergence in value levels that occurs when agents interact.
        ;The tolerance threshold determines whether an agent interacts with or ignores an other agent.
        ;The polarity threshold determines whether an agent is repulsive or tolerant of an other agent's worldview.
        if (social_influence_model = 1) [assimilation]
        if (social_influence_model = 2) [biased-assimilation]
        if (social_influence_model = 3) [biased-assimilation-repulsion]
        if (social_influence_model = 4) [biased-assimilation-repulsion-optimal-distinctiveness]

        ;If the degree of value dissimilarity falls beneath the tolerance threshold or when it exceeds the polarity threshold, then agent interact.
        ifelse value_dissimilarity <= tolerance_threshold or value_dissimilarity >= polarity_threshold [
          ;Agents interact...

          ;Register whether the agents converge, individualize or diverge using the 'update-interaction-outcome' procedure.
          update-interaction-outcome

          ;NOTE: 'value_convergence' is typically constrained to a range of [0,0.5]
          ;NOTE: calculation of convergence is multiplicative because the STRENGTH of convergence must be modulated (NOT the direction).
          let AA_convergence (value_convergence * PA_social_influence * influence_weight) * (1 - AA_ego_involvement)
          let PA_convergence (value_convergence * AA_social_influence * influence_weight) * (1 - PA_ego_involvement)

          ;Make sure that convergence is constrained to [0,1]
          set AA_convergence SPECIFY-FLOOR-CEILING! AA_convergence 0.001 0.999
          set PA_convergence SPECIFY-FLOOR-CEILING! PA_convergence 0.001 0.999

          ;Determine the magnitude of value change for active agent.
          let AA_delta AA_convergence * (PA_value_t0 - AA_value_t0)
          ;Determine the magnitude of value change for partner agent.
          let PA_delta PA_convergence * (AA_value_t0 - PA_value_t0)

          ;Calculate post-interaction value level of active agent.
          let AA_value_t1 (SPECIFY-FLOOR-CEILING! (AA_value_t0 + AA_delta) 0.001 0.999)
          ;Calculate post-interaction value level of partner agent.
          let PA_value_t1 (SPECIFY-FLOOR-CEILING! (PA_value_t0 + PA_delta) 0.001 0.999)

          ;Determine the peer pressure experienced by AA:
          ;if multilateral_influence? is FALSE then AA_peer_pressure = 0 (this is because AA_peer_pressure is initiated as 0).
          let AA_peer_pressure abs ((AA_multilateral_mean - AA_value_t1) * AA_peer_pressure_intensity)
          set AA_peer_pressure AA_peer_pressure * (1 - non_conformism)
          ;Determine the peer pressure experienced by PA:
          ;if multilateral_influence? is FALSE then PA_peer_pressure = 0 (this is because PA_peer_pressure is initiated as 0).
          let PA_peer_pressure abs ((PA_multilateral_mean - PA_value_t1) * PA_peer_pressure_intensity)
          set PA_peer_pressure PA_peer_pressure * (1 - [non_conformism] of partner)

          let AA_value_t1_MLI AA_value_t1
          let PA_value_t1_MLI PA_value_t1

          ;Calculate post-interaction value level of active agent, including multilateral influence:
          ;if multilateral_influence? is FALSE, then AA_value_t1_MLI equals AA_value_t1 because AA_peer_pressure = 0
          ifelse AA_multilateral_mean > AA_value_t1 [
            set AA_value_t1_MLI AA_value_t1 + AA_peer_pressure
          ][
            set AA_value_t1_MLI AA_value_t1 - AA_peer_pressure
          ]

          ;Calculate post-interaction value level of partner agent, including multilateral influence:
          ;if multilateral_influence? is FALSE, then PA_value_t1_MLI equals PA_value_t1 because PA_peer_pressure = 0
          ifelse PA_multilateral_mean > PA_value_t1 [
            set PA_value_t1_MLI PA_value_t1 + PA_peer_pressure
          ][
            set PA_value_t1_MLI PA_value_t1 - PA_peer_pressure
          ]

          ;Determine average value change of interacting agents in order to update the trust level of their relationship.
          let mean_delta (abs AA_delta + abs PA_delta) / 2

          ;Quality of relationship is proportional to interaction rate (more specifically, instances & strength of value convergence).
          ;If agents converge, 'mutual trust' or 'quality of relationship' increases. If agents diverge, 'mutual trust' or 'quality of relationship' decreases.
          ;If agents 'individualize' then quality of relationship is left unaltered.
          if not social_media_interaction? [
            if interaction_outcome = "assimilate" [
              ask link who ([who] of partner) [
                set strength SPECIFY-FLOOR-CEILING! (strength * (1 + mean_delta)) 0.001 2
              ]
            ]
            if interaction_outcome = "repulse" [
              ask link who ([who] of partner) [
                set strength SPECIFY-FLOOR-CEILING! (strength * (1 - mean_delta)) 0.001 2
              ]
            ]
          ]

          ;Is culturalization switched on? then effect of culture on value change may become effective.
          ifelse culturalization? [
            ;Calculate the PRE-INTERACTION (t0) deviation of each agent with regards to the cultural mean.
            let AA_cultural_deviation_t0 (abs (AA_value_t0 - cultural_mean))
            let PA_cultural_deviation_t0 (abs (PA_value_t0 - cultural_mean))

            ;Calculate the POST-INTERACTION (t1) deviation of each agent with regards to the cultural mean.
            let AA_cultural_deviation_t1 (abs (AA_value_t1_MLI - cultural_mean))
            let PA_cultural_deviation_t1 (abs (PA_value_t1_MLI - cultural_mean))

            ;Determine whether agents move AWAY (t0 deviation < t1 deviation) from cultural mean or TOWARDS (t0 deviation > t1 deviation) cultural mean.
            ;AA delta deviation = PRE- vs POST-interaction difference in cultural deviation of active agent.
            let AA_delta_deviation (AA_cultural_deviation_t0 - AA_cultural_deviation_t1)
            ;PA delta deviation = PRE- vs POST-interaction difference in cultural deviation of partner agent.
            let PA_delta_deviation (PA_cultural_deviation_t0 - PA_cultural_deviation_t1)

            ;Initiate (local) culturalization variables.
            let AA_culturalization 1
            let PA_culturalization 1

            ;SP1 = Shape Parameter 1
            ;SP1 modulates the shape of the exponential function that determines the strength of culturalization on value change.
            let SP1 1

            ;Culturalization is activated ONLY IF an agent MOVES AWAY from cultural mean!
            if AA_delta_deviation < 0 [
              let x abs AA_delta_deviation
              ;The strength of culturalization increases as an agent's cultural deviation increases.
              let component1 (-1 * x ^ SP1)
              ;The strength of culturalization increases as experienced uncertainty increases.
              let component2 (culturalization_strength * (1 + experienced_uncertainty))
              ;The strength of culturalization  decreases as non-conformism increases.
              let component3 (1 - non_conformism * non_conformism_strength)
              ;Compute culturalization:
              set AA_culturalization 1 + (component1 * component2 * component3)
            ]
            if PA_delta_deviation < 0 [
              let x abs PA_delta_deviation
              ;The strength of culturalization increases as an agent's cultural deviation increases.
              let component1 (-1 * x ^ SP1)
              ;The strength of culturalization increases as experienced uncertainty increases.
              let component2 (culturalization_strength * (1 + [experienced_uncertainty] of partner))
              ;The strength of culturalization  decreases as non-conformism increases.
              let component3 (1 - [non_conformism] of partner * non_conformism_strength)
              ;Compute culturalization:
              set PA_culturalization 1 + (component1 * component2 * component3)
            ]

            ;Determine the magnitude of change in a particular value including the effect of culture (for active agent).
            let AA_delta_culturalized (AA_delta * AA_culturalization)
            ;Determine the magnitude of change in a particular value including the effect of culture (for partner agent).
            let PA_delta_culturalized (PA_delta * PA_culturalization)

            ;Determine new value levels for active and partner agents.
            let AA_value_t1_culturalized (SPECIFY-FLOOR-CEILING! (AA_value_t0 + AA_delta_culturalized) 0.001 0.999)
            let PA_value_t1_culturalized (SPECIFY-FLOOR-CEILING! (PA_value_t0 + PA_delta_culturalized) 0.001 0.999)

            ;Change agent's value system (including effect of culture).
            ;Change value system of active agent:
            set schwartz_value_system replace-item target_value_index schwartz_value_system AA_value_t1_culturalized
            ;Change value system of partner agent:
            ask partner [set schwartz_value_system replace-item target_value_index schwartz_value_system PA_value_t1_culturalized]
          ][
            ;Change agent's value system (excluding effect of culture).
            ;Change value system of active agent using AA_value_t1_MLI:
            set schwartz_value_system replace-item target_value_index schwartz_value_system AA_value_t1_MLI
            ;Change value system of partner agent using PA_value_t1_MLI:
            ask partner [set schwartz_value_system replace-item target_value_index schwartz_value_system PA_value_t1_MLI]
          ] ;ifelse culturalization?
        ][
          ;Agents do not interact, procedure is put to a stop.
          set interaction_outcome "ignore"
          stop
        ] ;ifelse value_dissimilarity <= tolerance_threshold or value_dissimilarity >= polarity_threshold
      ];if any? my-links
    ] ;if random-float 1 < interaction_intensity
  ] ;ask energy_consumers
end

to activate-introspection
  ;The introspection procedure ensures that agents (under certain specified conditions) become aware of the composition of their values systems (i.e. the relative ranking in importance of values within their value systems).
  ;Agent strive for a logical (consistent) value system; when primed to do so, agents engage in (1) antagonistic or (2) mutualistic reasoning.
  ;(1) It is illogical for agents to cherish values that are in conflict with one another:
  ;In case conflicting values (e.g. power and benevolence) hold similar levels, the agent solves this by increasing one and decreasing the other.
  ;(2) It is logical for agents to cherish values that are complementary to one another:
  ;In case mutualistic values (e.g. achievement and power) hold dissimilar levels, the agent solves this by moving the value levels towards one another.

  ;It is presumed that TECHNOLOGICAL CHANGE induces the introspective process.

  ;/// THEORETICAL DESCRIPTION OF LINK BETWEEN TECHNOLOGICAL CHANGE AND INTROSPECTION \\\
  ;Of all the normativities and moralities that surround us, we are only aware of the small subset that is problematic (Swierstra, 2015)
  ;These normativities become problematic when they conflict with competing normativities (Swierstra, 2015)
  ;An agents becomes aware of a value when it tends to conflict with other values (Swierstra, 2015)
  ;It is presumed that agents strive for consistency of their value systems (agents hold an aversion of cognitive dissonance)
  ;A new technology disrupts an agent's practical routines, thus forcing it to reflect on the values (and norms) embedded in those routines (Swierstra, 2015)
  ;The normativity embedded in the current practice only becomes visible because, and to the extent that, it is contrasted with an alternative practice that we can imagine resulting from the introduction of a new technology (Swierstra, 2015)

  ;It is presumed that technological change increases the likelihood of new technologies being introduced that affect an agent's daily routines, consequently inducing an agent's conscious reflection upon its value system.
  ;It is presumed that if an agent consciously reflects upon its own value system, then introspection take place.

  ;Note: introspection is a functional alternative to hot media exposure.
  ;Note: introspection of this sort happens rarely (see e.g. Haidt & Bjorklund, 2007).
  ask n-of (tech_disruption_scope * count energy_consumers) energy_consumers [
    ifelse random-float 1 < technological_change [
      ;During a given tick an agent either engages in antagonistic reasoning OR in mutualistic reasoning (not both simultaneously).
      ifelse random-float 1 < 0.5 [
        ;If activated, certain antagonistic value diverge (i.e. beget dissimilar levels)
        ;When activated, antagonistic-value-dynamics should make an antagonist move in the exact opposite direction of a particular value (VERIFIED)
        if antagonistic_dynamics? [antagonistic-value-dynamics]
      ][
        ;If activated, certain (mutualistic) values converge (i.e. beget similar levels)
        ;When activated on pairs of mutualistic values, mutualistic-value-dynamics should make mutualistic values converge towards an identical frequency distribution (VERIFIED)
        if mutualistic_dynamics? [mutualistic-value-dynamics]
      ]
    ][
      stop
    ]
  ]
end

to execute-attitude-computation
  ;IMPORTANT ABBREVIATIONS:
  ;factBelief = Factual Belief
  ;PV = Photo-Voltaics
  ;EV = Electric Vehicle
  ;HP = Heat Pump
  ;AttFunc = Attitude Function(s)

  ask energy_consumers [
    ;Ask agent to determine its personal attitude function domain scores profile.
    load-attitude-function-scores

    ;Build a list of lists containing all of the agent's attitude function domain scores (this will be used as an input to the COMPUTE-ATTITUDE! reporter procedure).
    let list_AttFuncDom (list utilitarian_scores value_expressive_scores social_adjustive_scores)

    ;Ask the agent to determine its attitude towards each energy technology included in the current model.
    foreach technologies [
      x ->
      if x = "PV" [
        let PV_visible? reduce word [visible?] of energy_technologies with [tech_type = "PV"]
        let PV_differentiated? reduce word [highly_differentiated?] of energy_technologies with [tech_type = "PV"]
        set PV_attitude COMPUTE-ATTITUDE! list_AttFuncDom FactStatement_AttPerf_PV ConfidenceWeight_AttPerf_PV PV_visible? PV_differentiated?
      ]
      if x = "EV" [
        let EV_visible? reduce word [visible?] of energy_technologies with [tech_type = "EV"]
        let EV_differentiated? reduce word [highly_differentiated?] of energy_technologies with [tech_type = "EV"]
        set EV_attitude COMPUTE-ATTITUDE! list_AttFuncDom FactStatement_AttPerf_EV ConfidenceWeight_AttPerf_EV EV_visible? EV_differentiated?
      ]
      if x = "Heat Pump" [
        let HP_visible? reduce word [visible?] of energy_technologies with [tech_type = "Heat Pump"]
        let HP_differentiated? reduce word [highly_differentiated?] of energy_technologies with [tech_type = "Heat Pump"]
        set HP_attitude COMPUTE-ATTITUDE! list_AttFuncDom FactStatement_AttPerf_HP ConfidenceWeight_AttPerf_HP HP_visible? HP_differentiated?
      ]
    ]
  ]
end

to calculate-CET-sentiments
  calculate-PV-sentiment
  calculate-EV-sentiment
  calculate-HP-sentiment
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WITHIN-PROCEDURE PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to link-win-schwartz
  ;Each unique pair of WIN segment & Schwartz value is ranked from 1 (very high) to 5 (very low).
  ;In doing so, each WIN segment is characterized by a unique archetypical Schwartz value profile (i.e. a list of 9x values ranging from 1 to 5).
  ;The win_schwartz list must contain value ONLY between 1 and 5
  ;Schwartz value profiles for each WIN segment are constructed on the basis of qualitative descriptions (e.g. Vringer, 2007) and (quantitative) factor loadings (Aalbers, 2006).

  ;Set Schwartz value profile for Broad Minds.
  set broad_mind n-values (length schwartz_values) [0]
  set broad_mind replace-item HED_index broad_mind 5
  set broad_mind replace-item STM_index broad_mind 3
  set broad_mind replace-item SD_index broad_mind 2
  set broad_mind replace-item UNI_index broad_mind 1
  set broad_mind replace-item BEN_index broad_mind 2
  set broad_mind replace-item CT_index broad_mind 3
  set broad_mind replace-item SEC_index broad_mind 4
  set broad_mind replace-item POW_index broad_mind 5
  set broad_mind replace-item ACH_index broad_mind 3

  ;Set Schwartz value profile for Social Minds.
  set social_mind n-values (length schwartz_values) [0]
  set social_mind replace-item HED_index social_mind 5
  set social_mind replace-item STM_index social_mind 3
  set social_mind replace-item SD_index social_mind 3
  set social_mind replace-item UNI_index social_mind 1
  set social_mind replace-item BEN_index social_mind 1
  set social_mind replace-item CT_index social_mind 3
  set social_mind replace-item SEC_index social_mind 3
  set social_mind replace-item POW_index social_mind 5
  set social_mind replace-item ACH_index social_mind 3

  ;Set Schwartz value profile for Caring Faithfuls.
  set caring_faithful n-values (length schwartz_values) [0]
  set caring_faithful replace-item HED_index caring_faithful 4
  set caring_faithful replace-item STM_index caring_faithful 4
  set caring_faithful replace-item SD_index caring_faithful 4
  set caring_faithful replace-item UNI_index caring_faithful 2
  set caring_faithful replace-item BEN_index caring_faithful 1
  set caring_faithful replace-item CT_index caring_faithful 1
  set caring_faithful replace-item SEC_index caring_faithful 2
  set caring_faithful replace-item POW_index caring_faithful 4
  set caring_faithful replace-item ACH_index caring_faithful 5

  ;Set Schwartz value profile for Conservatives.
  set conservative n-values (length schwartz_values) [0]
  set conservative replace-item HED_index conservative 3
  set conservative replace-item STM_index conservative 4
  set conservative replace-item SD_index conservative 5
  set conservative replace-item UNI_index conservative 3
  set conservative replace-item BEN_index conservative 3
  set conservative replace-item CT_index conservative 1
  set conservative replace-item SEC_index conservative 1
  set conservative replace-item POW_index conservative 3
  set conservative replace-item ACH_index conservative 4

  ;Set Schwartz value profile for Hedonists.
  set hedonist n-values (length schwartz_values) [0]
  set hedonist replace-item HED_index hedonist 1
  set hedonist replace-item STM_index hedonist 2
  set hedonist replace-item SD_index hedonist 3
  set hedonist replace-item UNI_index hedonist 5
  set hedonist replace-item BEN_index hedonist 4
  set hedonist replace-item CT_index hedonist 3
  set hedonist replace-item SEC_index hedonist 2
  set hedonist replace-item POW_index hedonist 2
  set hedonist replace-item ACH_index hedonist 3

  ;Set Schwartz value profile for Materialists.
  set materialist n-values (length schwartz_values) [0]
  set materialist replace-item HED_index materialist 2
  set materialist replace-item STM_index materialist 2
  set materialist replace-item SD_index materialist 3
  set materialist replace-item UNI_index materialist 4
  set materialist replace-item BEN_index materialist 5
  set materialist replace-item CT_index materialist 3
  set materialist replace-item SEC_index materialist 3
  set materialist replace-item POW_index materialist 1
  set materialist replace-item ACH_index materialist 2

  ;Set Schwartz value profile for Professionals.
  set professional n-values (length schwartz_values) [0]
  set professional replace-item HED_index professional 3
  set professional replace-item STM_index professional 2
  set professional replace-item SD_index professional 1
  set professional replace-item UNI_index professional 2
  set professional replace-item BEN_index professional 3
  set professional replace-item CT_index professional 5
  set professional replace-item SEC_index professional 3
  set professional replace-item POW_index professional 2
  set professional replace-item ACH_index professional 1

  ;Set Schwartz value profile for Balanced Minds.
  set balanced_mind n-values (length schwartz_values) [3]

  ;Make list of lists (i.e. a matrix with WIN segments as rows and Schwartz values as columns).
  set win_schwartz_matrix (list
    broad_mind
    social_mind
    caring_faithful
    conservative
    hedonist
    materialist
    professional
    balanced_mind
  )
end

to reset-info-exposure-states
  set communication_state "listen"
  set tech_ownership? false
  set word_of_mouth? false
  set first_hand_experience? false
  set media_exposure? false
  set surprised? false
end

to compute-value-extremities
  set value_system_extremities map [i -> abs (i - 0.5)] schwartz_value_system
end

to determine-hot-media-content

  ;Agents are presumed to generally engage in selective exposure when they intentionally perceive hot media content.
  ;Agents prefer being exposed to congenial media content:
  ;Thus, liberal agents prefer exposure to liberal media, and conservative agents prefer exposure to conservative media.
  ifelse liberalism >= conservatism [
    ;If media content is liberal, agent exposure should lead to a decrease of conservative values and/or an increase of liberal values.
    set media_content "liberal"
  ][
    ;If media content is conservative, agent exposure should lead to an increase of conservative values and/or a decrease of liberal values.
    set media_content "conservative"
  ]
  ;If agent's level of liberalism equates the level of conservatism, then set media content random.
  if liberalism = conservatism [
    set media_content "random"
  ]

  ;If exposure is incidental, then content is random (i.e. a random Schwartz value is targeted for influencing).
  if media_exposure = "incidental" [
    set media_content "random"
  ]

  ;Intentional media exposure represents an agent's selective (i.e. deliberate) exposure to a particular media type and content.
  if media_exposure = "intentional" [
    if media_type = "mass" [
      ;If societal threat drops below a certain threshold, mass media tends to report on subjects that positively affect liberal values and/or negatively affect conservative values.
      ;Activate liberal bias when societal threat drops below a certain threshold:
      if societal_threat_level <= mass_media_bias  [
        set media_content "liberal"
      ]
      ;If societal threat exceeds a certain threshold, mass media tends to report on subjects that positively affect conservative values and/or negatively affect liberal values.
      ;Activate conservative bias when societal threat exceeds a certain threshold:
      if societal_threat_level >= (1 - mass_media_bias) [
        set media_content "conservative"
      ]
      ;An agent can sometimes be exposed to mass media and perceive content that influences its value system in an arbitrary way.
      if random-float 1 <= random_exposure [
        set media_content "random"
      ]
    ]

    if media_type = "niche" [
      ;An agent can at times be exposed to alternative (niche) media and perceive content that influences its value system in an arbitrary way.
      ;However, it is presumed that niche media is generally more biased than mass media (e.g. democratization of journalism, lower accountability for spreading misinformation etc.)
      ;That is, agent exposure to congenial content is presumed to be highest in case of niche media (e.g. filter bubble phenomenon).
      if random-float 1 >= filter_bubble [
        set media_content "random"
      ]
    ]
  ]
end


;The 'activate-hot-information-processing' procedure represents the act of processing the packets of information an agent receives from being exposed to opiniated media reports.
;Being exposed to an opiniated media report changes (to varying degrees) the content of an agent's value system.
;It is presumed that, over time, repeated exposure to certain opiniated media reports may have a notable impact on what an agent believes to be important/valuable in life.
;In the current model, media generally influences an agent by pushing it towards a liberal or a conservative worldview.
;To a lesser degree, media can influence an agent in a random manner (that is, by adressing any of the Schwartz values not linked to liberalism or conservatism)
to activate-hot-information-processing
  ;Initiate local variables to be used throughout current procedure.
  let value_t0 0
  let target_value_index 0

  ;Construct lists of liberal and conservative values.
  let liberal_values (list UNI_index BEN_index)
  let conservative_values (list CT_index SEC_index POW_index)
  ;Combine liberal and conservative value indices into a 'political values' list.
  let political_values se liberal_values conservative_values

  ;Initiate a local variable that holds the valence of the cultural mean of a value.
  let cultural_valence 0

  ifelse media_content = "random" [
    ifelse cultural_bias? [
      ;If media content is random and cultural_bias is activated? Then pick an 'culturally biased' index from the Schwartz values list.
      ;Cultural bias manifests itself as follows: values that are cherished (or despised) within a culture are more often the topic of discussion during opinionated media reports.

      ;Make a list of weights (a weight is represented by the 'extremeness' of a particular value).
      let weights map [i -> abs (i - 0.5)] cultural_value_system
      ;Make a list of indices the same length as an agent's value system.
      let indices n-values (length schwartz_value_system) [i -> i]
      ;Make a list of list containing pairs of indices with respective weights.
      let pairs (map list indices weights)
      ;Set 'target_value_index' as the first item of a pair selected using the second item (i.e. "last i") as the weight.
      ;Values with (relatively) larger weights (higher extremity) are more likely to be selected.
      set target_value_index first rnd:weighted-one-of-list pairs [ [i] -> last i ]
    ][
      ;If media content is random and cultural_bias is not activated? Then pick an index at random from the Schwartz values list.
      set target_value_index random length schwartz_value_system
    ]
  ][
    ;If media content is not random? Then pick a value (at random) from the 'political values' list.
    set target_value_index reduce word n-of 1 political_values
  ]

  ;Determine the cultural valence of the targeted value,
  set cultural_valence item target_value_index cultural_value_system - 0.5

  ;Load the agent's pre-exposure value level into value_t0.
  set value_t0 item target_value_index schwartz_value_system

  ;Initiate a local variable that holds the importance level of a value communicated by the media.
  let media_value 0

  ;Hot media content is presumed to be strongly opiniated (attention grabbing, sensationalism) and constructed to persuade...
  ;Thus, it is presumed that hot media content aims to polarize an agent's value system.

  ;If perceived media content is random and cultural bias is activated, then the importance of a value communicated by the media can be high or low:
  ;The communicated importance level depends on the 'culturla valence' of the targeted value.
  ;If the valence is positive (negative), media will communicate a positive (negative) value level.
  if media_content = "random" [
    ifelse cultural_bias? [
      ifelse cultural_valence <= 0 [
        ;A communicated value is either low (something is considered unimportant)...
        set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.2 0.05) 0.001 0.999
      ][
        ;...Or high (something is considered important).
        set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.8 0.05) 0.001 0.999
      ]
    ][
      ;If perceived media content is random and cultural bias is NOT activated, then the importance of a value communicated by the media is either high or low (50/50).
      if media_content = "random" [
        ifelse random-float 1 <= 0.5 [
          ;A communicated value is either low (something is considered unimportant)...
          set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.2 0.05) 0.001 0.999
        ][
          ;...Or high (something is considered important).
          set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.8 0.05) 0.001 0.999
        ]
      ]
    ]
  ]

  ;If perceived media content is biased in favour of a liberal worldview:
  ;Then liberal values will obtain a (very) important status, while conservative values will obtain a (very) unimportant status.
  if media_content = "liberal" [
    ;Check whether the value communicated is liberal or not and adjust importance accordingly.
    ifelse member? target_value_index liberal_values [
      set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.9 0.05) 0.001 0.999
    ][
      set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.1 0.05) 0.001 0.999
    ]
  ]

  ;If perceived media content is biased in favour of a conservative worldview:
  ;Then conservative values will obtain an important status, while liberal values will obtain an unimportant status.
  if media_content = "conservative" [
    ;Check whether the value communicated is conservative or not and adjust importance accordingly.
    ifelse member? target_value_index conservative_values [
      set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.9 0.05) 0.001 0.999
    ][
      set media_value SPECIFY-FLOOR-CEILING! (random-normal 0.1 0.05) 0.001 0.999
    ]
  ]

  ;If an agent's t0 value level lies close to 1 or 0, it indicates ego involvement. Ego involved values are central to agent's self-concept and are therefore less susceptible to change.
  let ego_involvement abs (value_t0 - 0.5)
  ;Determine difference (delta) between the value communicated by the media (media_value) and an agent's value level before media exposure (value_t0).
  let delta_values media_value - value_t0
  ;Change in value_t0 (convergence) is determined on the basis of the value level communicated by the media, the agent's dependence on the media as an information source and the extremity (ego involvement) of a targeted value.
  let convergence (delta_values * hot_media_dependence) * (1 - ego_involvement)
  ;Calculate the post-exposure value level as value_t1
  let value_t1 value_t0 + (convergence * media_influence)

  ;Change value system of agent using value_t1
  set schwartz_value_system replace-item target_value_index schwartz_value_system value_t1
end

to activate-cold-information-processing
  ;/// SHORT DESCRIPTION OF FIRST HAND EXPERIENCE \\\
  ;energy_consumers may experience / observe the performance of a particular technology on a certain attribute on a first-hand basis (i.e. direct experience)
  ;First-hand experiences are the result of, for example: direct use of a technology, (technical) research into the performance of a certain technology on a particular attribute
  ;When this happens, a energy_consumer may acquire knowledge (i.e. updates its factual belief) with regards to the attribute's performance (AttPerf) of a certain technology

  ;/// SHORT DESCRIPTION OF INDIRECT (WORD-OF-MOUTH) EXPERIENCE \\\
  ;energy_consumers may experience / observe the performance of a particular technology on a certain attribute on an indirect basis (i.e. indirectly through word-of-mouth social interaction)
  ;When this happens, a energy_consumer may acquiree knowledge (i.e. it updates its factual belief) with regards to the attribute's performance (AttPerf) of a certain technology

  ;DEFINITIONS:
  ;Factual belief = a presumption about the performance level of some technology attribute including a subjective probability (certainty) related to the veracity of that presumption.

  ;ABBREVIATIONS:
  ;att = attribute
  ;FHExp = first-hand-experience
  ;MExp = Media Exposure
  ;AttPerf = Attribute Performance

  ;Initiate local variables to be used throughout the current procedure.
  let target_tech 0
  let type_of_tech 0
  let att_index 0
  let AttPerf_actual_level 0
  let AttPerf_perceived_level 0

  ;If an agent does not perceive media, does not experience a first-hand (direct) observation and has not received a message through word-of-mouth?
  ;Then reset info exposure states and stop the current procedure.
  if not first_hand_experience? and not media_exposure? and not word_of_mouth? [
    reset-info-exposure-states
    stop
  ]

  if first_hand_experience? [
    ifelse tech_ownership? [
      error "Technology ownership has not (yet) been integrated into the current simulation model; first-hand experiences are therefore excluded as a source of factual information"
    ][
      stop
    ]
  ]

  ;If an agent is exposed to (expert) media, then it obtains information about the performance level of a random attribute of a random clean energy technology through some expert report.
  if media_exposure? [
    ;Pick one of energy technologies.
    set target_tech one-of energy_technologies
    ;Check the type of energy technology that is chosen.
    set type_of_tech [tech_type] of target_tech
    ;Media channel reports on a tech attribute at RANDOM; I presume no intentionality.
    set att_index random length tech_attributes
    ;Specify the actual performance of a technology on a particular attribute.
    set AttPerf_actual_level item att_index [attribute_performance_list] of target_tech
  ]

  ;If the agent observes AttPerf on a word-of-mouth basis (i.e. through social interaction) the agent receives a message from another agent (i.e. the sending agent).
  ;The technology type, attribute index and AttPerf level that constitute the content of the message are obtained from the sender by the receiving agent.
  if word_of_mouth? [
    set type_of_tech item 0 tech_att_ID
    set att_index item 1 tech_att_ID
  ]

  ;It is presumed that obtaining (accurate) information about the purchasing price of a technology is much easier than obtaining information about any of the other attributes.
  ;Hence, 'information_intake_distortion' is boosted when the agent learns about the performance of a particular attribute that IS NOT the "purchasing price".
  let price position "purchasing cost" tech_attributes
  let increase_distortion 1.5
  ;Compute 'information_intake_distortion' on the basis of the global variable 'information_intake_error'.
  let information_intake_distortion abs (random-normal information_intake_error information_intake_error / 2)
  ;If agent learns about something other than purchasing price? Then boost the information intake error by 'increase_distortion'.
  if att_index != price [set information_intake_distortion information_intake_distortion * increase_distortion]

  ;Determine the AttPerf level an agent observes if it is exposed to a media report.
  if media_exposure? [
    set AttPerf_perceived_level SPECIFY-FLOOR-CEILING! (AttPerf_actual_level + (information_intake_distortion - 2 * random-float information_intake_distortion)) 0.001 0.999
  ]

  ;Determine the AttPerf level an agent preceives from a sending agent.
  if word_of_mouth? [
    set AttPerf_perceived_level SPECIFY-FLOOR-CEILING! (AttPerf_interesting_level + (information_intake_distortion - 2 * random-float information_intake_distortion)) 0.001 0.999
  ]

  ;Initiate local lists to store the agent's factual beliefs (i.e. presumptions and respective certainties) about the attribute performance levels of a certain technology.
  let AttPerf_presumed_levels n-values length tech_attributes [0]
  let AttPerf_certainty_levels n-values length tech_attributes [0]

  ;Update presumed (expected) attribute performance levels (and respective certainties) according to the type of technology under scrutiny.
  if type_of_tech = "PV" [
    set AttPerf_presumed_levels FactStatement_AttPerf_PV
    set AttPerf_certainty_levels ConfidenceWeight_AttPerf_PV
  ]
  if type_of_tech = "EV" [
    set AttPerf_presumed_levels FactStatement_AttPerf_EV
    set AttPerf_certainty_levels ConfidenceWeight_AttPerf_EV
  ]
  if type_of_tech = "Heat Pump" [
    set AttPerf_presumed_levels FactStatement_AttPerf_HP
    set AttPerf_certainty_levels ConfidenceWeight_AttPerf_HP
  ]

  ;Specify the presumed performance level and respective a priori (t0) certainty regarding the technology & attribute being considered by the agent.
  let AttPerf_presumed_level item att_index AttPerf_presumed_levels
  let AttPerf_certainty_t0 item att_index AttPerf_certainty_levels

  ;Determine the difference between the presumed and observed AttPerf levels (used for calculating the convergence of the 'presumed' towards a 'perceived' AttPerf level).
  let difference_AttPerf_levels (AttPerf_perceived_level - AttPerf_presumed_level)

  ;Calculate the level of surprise the agent experiences when it perceives a certain performance level of a particular technology's attribute.
  let level_of_surprise COMPUTE-SURPRISE! AttPerf_perceived_level AttPerf_presumed_level

  ;/// SHORT DESCRIPTION OF A POSTERIORI CERTAINTY [t1] COMPUTATION \\\
  ;If level of surprise EXCEEDS the 'surprise threshold', it means that the presumed AttPerf level is significantly different from the one observed.
  ;This violation of the agent's expectation decreases the agent's certainty with regards to the veracity of its presumed AttPerf level
  ;As a result, the agent's certainty decreases (proportional to the extremity or intensity of the surprise level)
  ;Vice versa, if the level of surprise falls BELOW the critical threshold, an agent becomes more certain of the veracity of its presumed AttPerf level
  ;As a result, the agent's certainty increases (proportional to the extremity or intensity of the surprise level)

  ;It is presumed that an agent finds itself in a 'state of surprise' when the level of surprise surpasses a 'surprise_threshold'
  ;VERIFICATION: the higher the critical surprise threshold, the lower the likelihood agents share factual information with one another (VERIFIED!)
  let surprise_extremity abs (surprise_threshold - level_of_surprise)
  ;Initiate a local variable to determine the a posteriori (t1) certainty level.
  let AttPerf_certainty_t1 0

  ;A posteriori certainty is capped at a lower bound of 0.05 and a higher bound of 0.95 ...
  ;...This is done in order to prevent a convergence of 'zero' from happening (i.e. to prevent complete intertia in agent knowledge accretion): a convergence of absolutely zero is considered unrealistic!
  ifelse level_of_surprise > surprise_threshold [
    ;Certainty is lowered (i.e. uncertainty increases).
    set AttPerf_certainty_t1 SPECIFY-FLOOR-CEILING! (AttPerf_certainty_t0 / (1 + surprise_extremity)) 0.05 0.95
    set surprised? true
    ;Record the attribute and technology an agent is surprised about (this constitutes the content of the message an agent sends to one of its peers!).
    set tech_att_ID list (type_of_tech) (att_index)
  ][
    ;Certainty is increased (i.e. uncertainty decreases).
    set AttPerf_certainty_t1 SPECIFY-FLOOR-CEILING! (AttPerf_certainty_t0 * (1 + surprise_extremity)) 0.05 0.95
    set surprised? false
    ;Set tech_att_ID as an empty list.
    set tech_att_ID []
  ]

  ;Determine the (a posteriori) uncertainty that the agent holds with regards to the presumed AttPerf level.
  ;The higher this uncertainty, the stronger the convergence towards the observed AttPerf level (uncertain agents are presumed to be convinced more easily than those that are certain).
  let uncertainty 1 - AttPerf_certainty_t1

  ;Initiate a local variable for determining AttPerf level convergence.
  let convergence 0

  if first_hand_experience? [
    set convergence uncertainty
  ]

  if media_exposure? [
    ;It is presumed that, in case an agent is exposed to (expert) media, convergence is determined by the agent's uncertainty level and its dependency upon media for obtaining factual information about clean energy technologies.
    ;It is presumed that uncertainty weighs stronger than dependency in determining convergence.
    ;'Converge' is the degree to which an agent updates its factual belief in congruence with the information it receives.
    let uncertainty_weight 2
    let dependency_weight 1
    let sum_of_weights uncertainty_weight + dependency_weight

    set convergence ((uncertainty * uncertainty_weight) + (cold_media_dependence * dependency_weight)) / sum_of_weights
  ]

  if word_of_mouth? [
    ;Determine receiver's trust in and persuasiveness of sending agent.
    let trust [strength] of link sender_ID receiver_ID
    let persuasiveness [social_status] of energy_consumer sender_ID

    ;It is presumed that, in case an agent is exposed to a message from another agent, convergence is determined by the agent's uncertainty level, its trust in the agent that is sending the message, and the social status of the sending agent.
    ;It is presumed that uncertainty weighs strongest in determining convergence, followed by trust and then social status.
    ;'Converge' is the degree to which an agent updates its factual belief in congruence with the information it receives.
    let uncertainty_weight 1
    let trust_weight 0.5
    let social_status_weight 0.25
    let sum_of_weights uncertainty_weight + trust_weight + social_status_weight

    set convergence ((uncertainty * uncertainty_weight) + (trust * trust_weight) + (persuasiveness * social_status_weight)) / sum_of_weights

    if view_mode = 3 [
      visualize-word-of-mouth-interaction
    ]
  ]

  ;Determine the updated performance level with regards to the targeted technology attribute within an agent's factual belief system.
  let AttPerf_updated_level SPECIFY-FLOOR-CEILING! (AttPerf_presumed_level + (convergence * difference_AttPerf_levels)) 0.001 AttPerf_perceived_level

  ;Update the factual belief of the agent (finalize knowledge accretion).
  if type_of_tech = "PV" [
    set FactStatement_AttPerf_PV replace-item att_index FactStatement_AttPerf_PV AttPerf_updated_level
    set ConfidenceWeight_AttPerf_PV replace-item att_index ConfidenceWeight_AttPerf_PV AttPerf_certainty_t1
  ]
  if type_of_tech = "EV" [
    set FactStatement_AttPerf_EV replace-item att_index FactStatement_AttPerf_EV AttPerf_updated_level
    set ConfidenceWeight_AttPerf_EV replace-item att_index ConfidenceWeight_AttPerf_EV AttPerf_certainty_t1
  ]
  if type_of_tech = "Heat Pump" [
    set FactStatement_AttPerf_HP replace-item att_index FactStatement_AttPerf_HP AttPerf_updated_level
    set ConfidenceWeight_AttPerf_HP replace-item att_index ConfidenceWeight_AttPerf_HP AttPerf_certainty_t1
  ]

  ;Prepare a variable that can be used for sharing interesting information with a peer in the network.
  set AttPerf_interesting_level AttPerf_updated_level

  ;Execute share information procedure (becomes active when agent is surprised and when the word_of_mouth model is activated).
  if word_of_mouth_model? [share-factual-information]

  ;Finally, reset the agent's information exposure state for the following round of interaction.
  reset-info-exposure-states
end

;When an agent observes a packet of information that is by some significant degree different from that which the agent expected, the agent enters a state of surprise and feels the urge to share that information with one of its peers (need for sensemaking)
;The 'share-factual-information' procedure serves to represent this information sharing activity.
to share-factual-information
  ;Check whether sender is surprised (surprised? = true) and whether it has recorded what it is surprised about (tech_att_ID)
  ifelse surprised? and not empty? tech_att_ID [

    set communication_state "send"

    ;Pick a listening agent (a potential receiver) from peers in the network to send a message to.
    let receiver one-of link-neighbors with [communication_state = "listen"]

    ;Check whether agent has found a receiver.
    ifelse receiver != nobody [
      ;Identify the receiver from the perspective of the sender.
      ;Identify oneself from the perspective of the sender.
      set sender_ID who
      set receiver_ID [who] of receiver

      ;Create a local variable to feed into the receiver command.
      let sender sender_ID

      ;Ask the receiver to engage in 'cold' information processing.
      ;'Cold' information is factual (dry) information that is not opiniated / is devoid of affective content.
      ask receiver [
        ;Tell receiver to update its information exposure state.
        set first_hand_experience? false
        set word_of_mouth? true
        set communication_state "receive"

        ;Identify the sender from the perspective of the receiver.
        ;Identify oneself from the perspective of the receiver.
        set sender_ID [who] of energy_consumer sender
        set receiver_ID who

        ;Ask receiver to update the relevant variables on the basis of the content of the sender's message.
        set tech_att_ID [tech_att_ID] of energy_consumer sender_ID
        set AttPerf_interesting_level [AttPerf_interesting_level] of energy_consumer sender_ID

        ;Activate the cold information processing procedure:
        activate-cold-information-processing
      ]
    ][;ifelse receiver = nobody
      reset-info-exposure-states
      stop
    ]
  ][;ifelse surprised? and not empty? tech_att_ID
    reset-info-exposure-states
    stop
  ]
  reset-info-exposure-states
end

;The 'update-existential-security' procedure serves to update an agent's interpretation of the state the world is in.
;Specifically, agent's experience a degree of existential security (= a combination of ontological (in)security and existential anxiety).
;Existential security is presumed to be determined by the perceived instability of the social, environmental and/or economic system wherein the agent finds itself (see e.g. Kinvall, 2004).
to update-existential-security
  ;It is presumed that agents weigh various aspects of reality differently:
  ;That is, the importance attributed to the impact of certain real world events on one's feeling of existential security differs across agents.

  ;Environmental instability is considered a stronger threat in the eyes of agents with high levels of universalism.
  let environmental_weight universalism
  ;Economic instability is considered a stronger threat in the eyes of agents that value security.
  let economic_weight security
  ;Social instability is considered a stronger threat in the eyes of agents that value benevolence, security and conformity & tradition.
  let social_weight (benevolence + security + conformity_tradition) / 3
  let sum_of_weights (social_weight + environmental_weight + economic_weight)
  ;System instability is presumed to be the weighted average of social, environmental and economic instability
  let system_instability ((environmental_instability * environmental_weight) + (social_instability * social_weight) + (economic_instability * economic_weight)) / sum_of_weights

  ;Mean world syndrome induces an upward bias (expressed by '0.05') in the perceived system instability.
  let bias mean_world_syndrome * 0.05
  let perceived_instability system_instability * (1 + bias)
  ;Constrain perceived_instability to [0,1]
  set perceived_instability SPECIFY-FLOOR-CEILING! perceived_instability 0.001 0.999

  ;Openness to experience and excitement-seeking are presumed to diminish perceptions of system instability and related feelings of threat and uncertainty.
  ;A factor of '0.5' is used to express the strength these traits have on experienced threat and uncertainty.
  let openness 0.5 * openness_to_experience
  let excitement 0.5 * stimulation

  set experienced_uncertainty perceived_instability - openness
  set perceived_threat perceived_instability - excitement

  ;NOTE: Constraints are not set at levels of absolutely 0 or 1 due to calculation requirements in other parts of the model.
  ;Constrain experienced_uncertainty to [0.001,0.999]
  set experienced_uncertainty SPECIFY-FLOOR-CEILING! experienced_uncertainty 0.001 0.999
  ;Constrain perceived_threat to [0.001,0.999]
  set perceived_threat SPECIFY-FLOOR-CEILING! perceived_threat 0.001 0.999

end

to update-political-partisanship
  ;The linkages between schwartz values and liberalism & conservatism are taken from Piurko et al. (2011).
  set liberalism (universalism + benevolence) / 2
  set conservatism (conformity_tradition + security + (0.5 * power)) / 2.5
end

;Need for cognition represents a trait that reflects the extent to which agents are inclined towards effortful cognitive activities.
;It is presumed that this trait is (highly) prevalent within agent's who value universalism, self-direction and achievement (see e.g. Cacioppo et al., 1996; Lilach & Schwartz, 2004).
to update-need-for-cognition
  let weight_univ 1
  let weight_sd 1
  let weight_ach 0.5
  let sum_of_weights weight_univ + weight_sd + weight_ach
  set need_for_cognition ((universalism * weight_univ) + (self_direction * weight_sd) + (achievement * weight_ach)) / sum_of_weights
end

;Conspiracy thinking represents an agent's propensity to mistrust the information provided by governments, universities, and other forms of (mainstream) expert entities.
;Sensation-seeking individualism can nurture an attitude political cynicism (Heins, 2007), which increases the likelihood of engaging in conspiracy thinking.
;Sensation-seeking individualism is presumed to be indicated by high levels of stimulation (excitement and sensation seeking) and power & achievement (individualism).
to update-conspiracy-thinking
  let weight_stimulation 3
  let weight_power 2
  let weight_achievement 1
  let sum_of_weights weight_stimulation + weight_power + weight_achievement
  let weighted_sum ((stimulation * weight_stimulation) + (power * weight_power) + (achievement * weight_achievement)) / sum_of_weights

  ;In order to be able to represent the presumed polarity with regards to this phenomenon, a sigmoid function is used to compute conspiracy thinking.
  ;It is presumed that alienated agents (agents with a low degree of social connection) hold an increased likelihood of engaging in conspiracy thinking (see e.g. Heins, 2007).
  let x weighted_sum / (1 + (0.01 * n_social_links))
  ;SP5 = Shape Parameter 5
  ;SP5 shifts the sigmoid curve down (to the left on) or up (to the right on) the x-axis (on a 2D plot)
  let SP5 0.50
  ;SP6 = Shape Parameter 6
  ;SP6 modulates the steepness (slope) of the sigmoid curve
  let SP6 15
  let z (SP5 * SP6) - (x * SP6)
  set conspiracy_thinking SPECIFY-FLOOR-CEILING! (1 / (1 + e ^ z)) 0.001 0.999
end

;Personality traits are derived from the composition of an agent's value system (see e.g. Roccas et al., 2002).
to update-personality-traits
  ;Openness to experience relates to tolerance of divergent perspectives.
  set openness_to_experience (universalism + self_direction + stimulation) / 3
  ;Narrow mindedness relates to intolerance of divergent perspectives (higher hostility).
  set narrow_mindedness (security + conformity_tradition + (1 - benevolence)) / 3
  ;Extroversion relates to tendency to approach / interact with people.
  set extroversion (stimulation + achievement + (0.5 * hedonism)) / 2.5
  ;Introversion relates to tendency to avoid / not interact with people.
  set introversion (conformity_tradition + (0.5 * security)) / 1.5
end

to update-non-conformism
  ;Values classified as PROGRESSIVE and SELF-REGARDING are presumed to induce NON-CONFORMISM (see value quadrant presented in Schwartz, 2012).
  ;Independence is motivated by self-direction and achievement values and inhibited by conformity and tradition values (see e.g. Bardi & Schwartz, 2003).
  let weight_sd 3
  let weight_stim 2
  let weight_ach 1
  let sum_of_weights (weight_sd + weight_stim + weight_ach)
  ;Set the level of non-conformism as weighted average of self-direction, stimulation and hedonism.
  set non_conformism ((weight_sd * self_direction) + (weight_stim * stimulation) + (weight_ach * achievement)) / sum_of_weights
end

to update-interaction-outcome
  ;Update the state of interaction outcome variables
  if value_dissimilarity <= tolerance_threshold [
    set interaction_outcome "assimilate"
    if value_dissimilarity <= individuality and social_influence_model = 4 [
      ;The term "individualize" refers to agents who diverge slightly from agents who are very similar to them in order to ensure individuality and 'uniqueness' in the eyes of their peers.
      set interaction_outcome "individualize"
    ]
  ]
  if value_dissimilarity >= polarity_threshold and social_influence_model != 1 [
    set interaction_outcome "repulse"
  ]
end

;The 'update-interaction-thresholds' is used during each round of 'hot' agent interaction for determining the heterogeneity in agents' interaction styles.
to update-interaction-thresholds
  ;Agents act in different ways with regards to interacting with other agents and processing the information they receive from an interaction partner (see e.g. Social Judgment Theory).
  ;A set of interaction thresholds determines:
  ;(1) Whether an agent chooses to interact or not with a given interaction partner
  ;(2) Whether an agent subsequently chooses to reject (repulsion) or accept (convergence) the opinion of a given interaction partner

  ;On the basis of these thresholds, 4 interaction zones can be distinguished whose interval ranges depend on the degree of value (dis)similarity between a given set of interaction partners and their respective threshold levels:
  ;(1) The Similarity Zone = This is also referred to as the acceptance zone. Agents hold very similar opinions/worldviews; this may lead to the need to slightly move away from each other (repulse) as to ensure individuality and 'uniqueness' in the eyes of peers.
  ;(2) The Goldilocks Zone = This is also referred to as the non-commitment zone. Agents are similar, but not too similar; agents converge when they find themselves in this interaction zone.
  ;(3) The Disregard Zone = agents are dissimilar in the values they hold; they ignore one another.
  ;(4) The Polarity Zone = agents are very dissimilar; agents find it too hard to ignore one another and consequently fight/defend their own worldviews resulting in a repulsive force between them.

  ;Zone 1 falls below the individualism threshold
  ;Zone 2 exceeds invididualism threshold but falls beneath an agent's tolerance threshold
  ;Zone 3 exceeds an agent's tolerance threshold but falls below the polarity threshold (hostility)
  ;Zone 4 exceeds an agent's polarity threshold (hostility)

  ;Agents hold heterogeneous thresholds, most of which are determined by personality traits:
  ;The level of introversion vs extroversion is presumed to determine an agent's propensity to ignore or interact with a potential interaction partner
  ;The level of openness to experience vs narrow-mindedness is presumed to determine an agent's propensity to reject or accept the opinion of a given interaction partner
  ask energy_consumers [
    ;Set base-level of confidence treshold using the global variable 'tolerance'.
    set tolerance_threshold SPECIFY-FLOOR-CEILING! tolerance 0.001 0.499
    ;Set base-level of polarity treshold using the global variable 'hostility'.
    set polarity_threshold SPECIFY-FLOOR-CEILING! (1 - hostility) 0.5 1

    ;The global variable 'interaction_threshold_heterogeneity' modulates the strength of the effect that certain traits have on the level of the interaction thresholds.
    ;tolerance threshold cannot be higher than 0.5; otherwise it conflicts with proper functioning of influence weight.
    set tolerance_threshold SPECIFY-FLOOR-CEILING! (tolerance_threshold + ((extroversion - introversion) * interaction_threshold_heterogeneity)) 0.001 0.499
    ;Polarity threshold cannot be lower than 0.5; otherwise it conflicts with proper functioning of influence weight.
    set polarity_threshold SPECIFY-FLOOR-CEILING! (polarity_threshold + ((openness_to_experience - narrow_mindedness) * interaction_threshold_heterogeneity)) 0.5 1
  ]
end

to assimilation
  ;In ASSIMILATION mode:
  ;Agents will ALWAYS interact as their value dissimilarity always exceeds the polarity threshold and never surpasses the tolerance threshold
  ;The influence weight has NO EFFECT on interaction in assimilation mode (i.e. all agents converge homogeneously)
  ;Value dissimilarity always falls BELOW the tolerance threshold
  ;Value dissimilarity always falls ABOVE the polarity threshold

  set influence_weight 1
  set tolerance_threshold 1
  set polarity_threshold 0
end

to biased-assimilation
  ;In BIASED ASSIMILATION mode:
  ;Agents with a value dissimilarity that surpasses the tolerance threshold will inevitably fall below the polarity threshold
  ;Thus, agents stop interacting with one another if their value dissimilarity exceeds their averaged tolerance thresholds
  ;The influence weight weakens as value dissimilarity increases (i.e. more similar agents converge stronger)
  ;There are HETEROGENEOUS tolerance thresholds
  ;Value dissimilarity always falls BELOW the polarity threshold

  set influence_weight (1 - 2 * value_dissimilarity)
  set tolerance_threshold mean (list (tolerance_threshold) ([tolerance_threshold] of partner))
  set polarity_threshold 1
end

to biased-assimilation-repulsion
  ;In BIASED ASSIMILATION & REPULSION mode:
  ;Agents with a value dissimilarity that surpasses the tolerance threshold AND that falls below the polarity threshold will NOT interact
  ;The influence weight turns NEGATIVE as value dissimilarity increases past a critical threshold of 0.5
  ;A negative influence weight leads to a REPULSIVE force between any pair of interacting agents; that is, they move AWAY from one another in terms of value levels (their value systems become more dissimilar)
  ;There are HETEROGENEOUS tolerance thresholds
  ;There are HETEROGENEOUS polarity thresholds

  set influence_weight (1 - 2 * value_dissimilarity)
  set tolerance_threshold mean (list (tolerance_threshold) ([tolerance_threshold] of partner))
  set polarity_threshold mean (list (polarity_threshold) ([polarity_threshold] of partner))
end

to biased-assimilation-repulsion-optimal-distinctiveness
  ;In BIASED ASSIMILATION, REPULSION & OPTIMAL DISTINCTIVENESS mode:
  ;The influence weight makes agents with high value similarity repel one another.
  ;There are HETEROGENEOUS tolerance thresholds.
  ;There are HETEROGENEOUS polarity thresholds.

  set influence_weight (1 - 2 * value_dissimilarity)

  ;The Optimal Distinctiveness (OD) weight induces a high repelling force when value are very similar.
  ;The repelling force of the OD weight weakens rapidly as value levels become more dissimilar.
  ;SP2 = Shape Parameter 2
  ;SP2 modulates the shape of the exponential function that determines the effect that value dissimilarity has on the influence weight under the condition of optimal distinctiveness.
  ;In other words, SP2 determines change in the strength of the repelling force for different levels of value dissimilarity.
  let SP2 25
  let OD_weight SP2 ^ (-1 * SP2 * value_dissimilarity)

  ;The 'optimal_distinctiveness' global variable modulates the strength of the repelling force.
  set OD_weight OD_weight * optimal_distinctiveness

  ;It is presumed that agents with high levels of self-direction tend to be more individualistic.
  set individuality individualism + (self_direction * random-float 0.1)

  ;If agents' value levels exhibit very low value dissimilarity (i.e. when value levels are highly similar), then the OD influence weight is activated
  ifelse value_dissimilarity <= individuality [
    ;Activate OD influence weight, which is ALWAYS negative since it is a repelling force (i.e. it makes agents move AWAY from one another in terms of value levels)
    set influence_weight (influence_weight * OD_weight) * -1
  ][
    ;Activate unaltered influence weight
    set influence_weight influence_weight
  ]

  set tolerance_threshold mean (list (tolerance_threshold) ([tolerance_threshold] of partner))
  set polarity_threshold mean (list (polarity_threshold) ([polarity_threshold] of partner))
end

;The 'execute-value-system-disruption' procedure serves to pick a random subset of values from an agent value system and slighty alter their levels.
;This procedure represents the consequence of moments of conscious reflection(s) agents may have with regards to questioning what they find important in life and why.
;This deliberate questioning of one's values is presumed to shake-up the value system in unpredictable ways resulting in an altered value system composition.
;This procedure is used in 'antagonistic-value-dynamics', which is in turn called by the procedure 'activate-introspection'.
;The procedure 'activate-introspection' is called whe agents are disrupted in their daily routines by technological change (see description of 'activate-introspection' for more details).
to execute-value-system-disruption
  ;Pick random value(s) from schwartz value system that are to be disrupted:
  let indices n-values length schwartz_value_system [ i -> i ]
  ;It is presumed that any number of values can be disrupted at a time.
  let subset_size random length indices
  ;Load disrupted (or affected) value indices into a list:
  let disrupted_value_indices n-of subset_size indices
  ;Specify the max magnitude of potential value disruption (set by global variable 'value_disruption_intensity'):
  let delta value_disruption_intensity
  ;Load schwartz_value_system into a variable that serves as a representation of an agent's value system before being disrupted:
  set schwartz_memory schwartz_value_system

  ;Have any values been affected? If no, stop procedure. If yes, continue.
  ifelse empty? disrupted_value_indices [
    stop
  ][
    ;Initiate local lists and variables to be used in 'foreach' procedures below
    ;t0 = pre-disruption
    ;t1 = post-disruption
    let value_levels_t0 []
    let value_levels_t1 []
    let value_system_t0 schwartz_value_system
    let value_system_t1 value_system_t0

    ;Obtain the relevant value levels from an agent's value system:
    ;For every item in disrupted_value_indices, use that item (as an index) to obtain the value levels corresponding to those Schwartz values that are to be affected by technology-induced disruption.
    foreach disrupted_value_indices [
      x -> set value_levels_t0 lput (FILTER-LIST! x indices value_system_t0) value_levels_t0
    ]
    ;Apply changes to t0 value levels resulting from disruption of routines:
    ;Modulating bias affects how value change (increase vs decrease) in response to technology-induced disruption.
    let bias 0
    ;For every item in value_levels_t0, add or subtract a random float and append it to a new list (value_levels_t1).
    foreach value_levels_t0 [
      x -> set value_levels_t1 lput SPECIFY-FLOOR-CEILING! (x + random-float delta - (delta / (2 + bias))) 0.001 0.999 value_levels_t1
    ]
    ;Determine the composition of the updated value system:
    ;For every item in index, use it to walk through the items in disrupted_value_indices and value_levels_t1 in order to update the relevant value levels within an agent's value system.
    let index n-values length disrupted_value_indices [i -> i]
    foreach index [
      x -> set value_system_t1 replace-item (item x disrupted_value_indices) value_system_t1 (item x value_levels_t1)
    ]
    ;Finally, update the agent's value system by replacing it with value_system_t1.
    set schwartz_value_system value_system_t1
  ]
end

;The 'antagonistic-value-dynamics' makes competing (antagonist) values beget dissimilar levels.
to antagonistic-value-dynamics

  ;Agents reflect upon their value systems, the 'execute-value-system-disruption' procedure must therefore be called as this reflects the consequences of such introspection.
  execute-value-system-disruption

  ;Check whether, and if so, what values have been disrupted (changed).
  let value_changed? (map != schwartz_memory schwartz_value_system)
  let changed_value_indices RETURN-POSITIONS! true value_changed?

  ;If no values have been disrupted (changed) then stop procedure, otherwise continue.
  ifelse empty? changed_value_indices [
    stop
  ][
    ;Progression and individualism (stimulation, self-direction) conflicts with conservation and collectivism  (security, conformity & tradition).
    ;Self-transcendence and broad mindedness (benevolence, universalism) conflicts with self-enhancement and narrow mindedness (power, hedonism).

    ;Agent checks whether certain value(s) is (are) affected by technological change, it then calibrates its value system accordingly.
    ;Specifically, an increase (decrease) in a particular value will decrease (increase) the level of its competitor/antagonist.
    if (member? STM_index changed_value_indices or member? SEC_index changed_value_indices) [
      ;STIMULATION (STM) versus SECURITY (SEC):
      let new_value_levels (EXECUTE-VALUE-ANTAGONISM! STM_index SEC_index schwartz_value_system schwartz_memory)
      ;Update STM within agent value system.
      set schwartz_value_system replace-item STM_index schwartz_value_system item 0 new_value_levels
      ;Update SEC within agent value system.
      set schwartz_value_system replace-item SEC_index schwartz_value_system item 1 new_value_levels
    ]
    if (member? SD_index changed_value_indices or member? CT_index changed_value_indices) [
      ;SELF-DIRECTION (SD) versus CONFORMITY & TRADITION (CT):
      let new_value_levels (EXECUTE-VALUE-ANTAGONISM! SD_index CT_index schwartz_value_system schwartz_memory)
      ;Update SD within agent value system.
      set schwartz_value_system replace-item SD_index schwartz_value_system item 0 new_value_levels
      ;Update CT within agent value system.
      set schwartz_value_system replace-item CT_index schwartz_value_system item 1 new_value_levels
    ]
    if (member? HED_index changed_value_indices or member? UNI_index changed_value_indices) [
      ;HEDONISM (HED) versus UNIVERSALISM (UNI):
      let new_value_levels (EXECUTE-VALUE-ANTAGONISM! HED_index UNI_index schwartz_value_system schwartz_memory)
      ;Change HED within agent value system.
      set schwartz_value_system replace-item HED_index schwartz_value_system item 0 new_value_levels
      ;Change UNI within agent value system.
      set schwartz_value_system replace-item UNI_index schwartz_value_system item 1 new_value_levels
    ]
    if (member? BEN_index changed_value_indices or member? POW_index changed_value_indices) [
      ;BENEVOLENCE (BEN) versus POWER (POW):
      let new_value_levels (EXECUTE-VALUE-ANTAGONISM! BEN_index POW_index schwartz_value_system schwartz_memory)
      ;Change BEN within agent value system.
      set schwartz_value_system replace-item BEN_index schwartz_value_system item 0 new_value_levels
      ;Change POW within agent value system.
      set schwartz_value_system replace-item POW_index schwartz_value_system item 1 new_value_levels
    ]
  ]
end

;The 'mutualistic-value-dynamics' makes mutualistic values beget similar levels.
to mutualistic-value-dynamics
  ;Randomize selection of mutualistic value dynamics
  let indices [1 2 3 4 5 6 7 8 9]
  let index reduce word n-of 1 indices

  ;Execute dynamism procedures of one of the follow mutualistic value pairs based on the index value pulled from the local 'indices' list
  if index = 1 [power-achievement-dynamism]
  if index = 2 [achievement-hedonism-dynamism]
  if index = 3 [hedonism-stimulation-dynamism]
  if index = 4 [stimulation-self_direction-dynamism]
  if index = 5 [self_direction-universalism-dynamism]
  if index = 6 [universalism-benevolence-dynamism]
  if index = 7 [benevolence-conformity_tradition-dynamism]
  if index = 8 [conformity_tradition-security-dynamism]
  if index = 9 [security-power-dynamism]
end

to power-achievement-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! POW_index ACH_index schwartz_value_system)
  let POW_changed SPECIFY-FLOOR-CEILING! (power + item 0 delta_value_levels) 0.001 0.999
  let ACH_changed SPECIFY-FLOOR-CEILING! (achievement + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item POW_index schwartz_value_system POW_changed
  set schwartz_value_system replace-item ACH_index schwartz_value_system ACH_changed
end

to achievement-hedonism-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! ACH_index HED_index schwartz_value_system)
  let ACH_changed SPECIFY-FLOOR-CEILING! (achievement + item 0 delta_value_levels) 0.001 0.999
  let HED_changed SPECIFY-FLOOR-CEILING! (hedonism + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item ACH_index schwartz_value_system ACH_changed
  set schwartz_value_system replace-item HED_index schwartz_value_system HED_changed
end

to hedonism-stimulation-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! HED_index STM_index schwartz_value_system)
  let HED_changed SPECIFY-FLOOR-CEILING! (hedonism + item 0 delta_value_levels) 0.001 0.999
  let STM_changed SPECIFY-FLOOR-CEILING! (stimulation + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item HED_index schwartz_value_system HED_changed
  set schwartz_value_system replace-item STM_index schwartz_value_system STM_changed
end

to stimulation-self_direction-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! STM_index SD_index schwartz_value_system)
  let STM_changed SPECIFY-FLOOR-CEILING! (stimulation + item 0 delta_value_levels) 0.001 0.999
  let SD_changed SPECIFY-FLOOR-CEILING! (self_direction + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item STM_index schwartz_value_system STM_changed
  set schwartz_value_system replace-item SD_index schwartz_value_system SD_changed
end

to self_direction-universalism-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! SD_index UNI_index schwartz_value_system)
  let SD_changed SPECIFY-FLOOR-CEILING! (self_direction + item 0 delta_value_levels) 0.001 0.999
  let UNI_changed SPECIFY-FLOOR-CEILING! (universalism + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item SD_index schwartz_value_system SD_changed
  set schwartz_value_system replace-item UNI_index schwartz_value_system UNI_changed
end

to universalism-benevolence-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! UNI_index BEN_index schwartz_value_system)
  let UNI_changed SPECIFY-FLOOR-CEILING! (universalism + item 0 delta_value_levels) 0.001 0.999
  let BEN_changed SPECIFY-FLOOR-CEILING! (benevolence + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item UNI_index schwartz_value_system UNI_changed
  set schwartz_value_system replace-item BEN_index schwartz_value_system BEN_changed
end

to benevolence-conformity_tradition-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! BEN_index CT_index schwartz_value_system)
  let BEN_changed SPECIFY-FLOOR-CEILING! (benevolence + item 0 delta_value_levels) 0.001 0.999
  let CT_changed SPECIFY-FLOOR-CEILING! (conformity_tradition + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item BEN_index schwartz_value_system BEN_changed
  set schwartz_value_system replace-item CT_index schwartz_value_system CT_changed
end

to conformity_tradition-security-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! CT_index SEC_index schwartz_value_system)
  let CT_changed SPECIFY-FLOOR-CEILING! (conformity_tradition + item 0 delta_value_levels) 0.001 0.999
  let SEC_changed SPECIFY-FLOOR-CEILING! (security + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item CT_index schwartz_value_system CT_changed
  set schwartz_value_system replace-item SEC_index schwartz_value_system SEC_changed
end

to security-power-dynamism
  let delta_value_levels (EXECUTE-VALUE-MUTUALISM! SEC_index POW_index schwartz_value_system)
  let SEC_changed SPECIFY-FLOOR-CEILING! (security + item 0 delta_value_levels) 0.001 0.999
  let POW_changed SPECIFY-FLOOR-CEILING! (power + item 1 delta_value_levels) 0.001 0.999
  set schwartz_value_system replace-item SEC_index schwartz_value_system SEC_changed
  set schwartz_value_system replace-item POW_index schwartz_value_system POW_changed
end

;The 'load-attitude-function-scores' procedure is vital for computing the attitudes that agents hold towards particular energy technologies.
;Specifically, it computes the scores for each of three attitude function domains that are used in determining the (affective) evaluation(s) of agents with regards to all of the 7 tech attributes.
to load-attitude-function-scores

  ;Attitudes are a function of the subjective probability (certainty) that the attitude object (an energy technology) leads to good or bad consequences (instrumentality / utility) and the subjective/affective evaluation of these consequences (affective beliefs) (see e.g. Nordlund, 2009).
  ;Attitudes generally serve three broad functions (see e.g. Tesser & Shaffer, 1990):
  ;(1) A utilitarian (or instrumental) function = enables an agent to (rationally) assess whether to approach or avoid a particular object.
  ;(2) A value expresseive (or symbolic) function = enables an agent to express values that are important to the self-concept (link to ontological security).
  ;(3) A social adjustive (or social) function = enables an agent to express itself in relation to other agents.

  ;Initiate a local lists of attitude function domain scores:
  set utilitarian_scores n-values length tech_attributes [0]
  set value_expressive_scores n-values length tech_attributes [0]
  set social_adjustive_scores n-values length tech_attributes [0]

  ;A utilitarian score of -1 means the higher the performance level, the more negative the evaluation in a utilitarian (instrumental) sense.
  ;A utilitarian score of 1 means the higher the performance level, the more positive the evaluation in a utilitarian (instrumental) sense.
  ;A utilitarian score of 0 (not applicable) means performance level does not affect the evaluation in a utilitarian (instrumental) sense.
  set utilitarian_scores replace-item (position "purchasing cost" tech_attributes) utilitarian_scores -1
  set utilitarian_scores replace-item (position "operating cost" tech_attributes) utilitarian_scores -1
  set utilitarian_scores replace-item (position "comfort" tech_attributes) utilitarian_scores 1
  set utilitarian_scores replace-item (position "safety" tech_attributes) utilitarian_scores 1
  set utilitarian_scores replace-item (position "environment" tech_attributes) utilitarian_scores 0
  set utilitarian_scores replace-item (position "autonomy" tech_attributes) utilitarian_scores 0
  set utilitarian_scores replace-item (position "privacy" tech_attributes) utilitarian_scores 0

  ;The value expression and social adjustive domains are characterized by being dependent upon agent's value systems.
  ;Specifically, whether an agent perceives a particular tech attribute to be relevant/functional with regards to value expression and/or social adjustment depends upon what it considers important or valuable.
  ;In order to represent the emotional valence of values; their levels are transformed to a scale that ranges from -0.5 to 0.5
  ;In doing so, values that score low (approach zero) will be negatively laden and values that score high (approach 1) will be positively laden.

  ;Make a list of value expression score (dependent upon relevant value levels)
  set value_expressive_scores replace-item (position "purchasing cost" tech_attributes) value_expressive_scores 0
  set value_expressive_scores replace-item (position "operating cost" tech_attributes) value_expressive_scores 0
  set value_expressive_scores replace-item (position "comfort" tech_attributes) value_expressive_scores (hedonism - 0.5)
  set value_expressive_scores replace-item (position "safety" tech_attributes) value_expressive_scores (security  - 0.5)
  set value_expressive_scores replace-item (position "environment" tech_attributes) value_expressive_scores (universalism - 0.5)
  set value_expressive_scores replace-item (position "autonomy" tech_attributes) value_expressive_scores (self_direction - 0.5)
  set value_expressive_scores replace-item (position "privacy" tech_attributes) value_expressive_scores (self_direction - 0.5)

  ;Make a list of social adjustive scores (dependent upon relevant value levels)
  set social_adjustive_scores replace-item (position "purchasing cost" tech_attributes) social_adjustive_scores (((power + achievement) / 2) - 0.5)
  set social_adjustive_scores replace-item (position "operating cost" tech_attributes) social_adjustive_scores 0
  set social_adjustive_scores replace-item (position "comfort" tech_attributes) social_adjustive_scores 0
  set social_adjustive_scores replace-item (position "safety" tech_attributes) social_adjustive_scores 0
  set social_adjustive_scores replace-item (position "environment" tech_attributes) social_adjustive_scores (achievement - 0.5)
  set social_adjustive_scores replace-item (position "autonomy" tech_attributes) social_adjustive_scores 0
  set social_adjustive_scores replace-item (position "privacy" tech_attributes) social_adjustive_scores 0
end

;Awareness is considered to be indicative of the 'quality' of an agent's factual belief:
;The higher the quality of an agent's factual belief, the closer it resembles the actual state of a particular aspect of reality.
;The closeness to which a factual belief resembles the actual state of the world is represented by the euclidian distance between 'factBelief_AttPerf_TECH' and 'TECH_AttPerf_list'.
to compute-awareness
  ask energy_consumers [
    set PV_awareness CALCULATE-EUCLIDIAN-DISTANCE! FactStatement_AttPerf_PV PV_AttPerf_list
    set EV_awareness CALCULATE-EUCLIDIAN-DISTANCE! FactStatement_AttPerf_EV EV_AttPerf_list
    set HP_awareness CALCULATE-EUCLIDIAN-DISTANCE! FactStatement_AttPerf_HP HP_AttPerf_list
  ]
end

;Calculating sentiments in the agent population regarding the various CETs present within the model is done by...
;...counting how many agents hold a positive attitude, and how many hold a negative attitude towards a particular CET.
;The sentiment level is subsequently determined by determining the ratio of positive to negative evaluators.
to calculate-PV-sentiment
  let PV_positive filter [ i -> i > 0.5 ] [PV_attitude] of energy_consumers
  let PV_negative filter [ i -> i < 0.5 ] [PV_attitude] of energy_consumers

  let PV_positives length PV_positive
  let PV_negatives length PV_negative

  print PV_positives
  print PV_negatives

  ifelse PV_positives != 0 and PV_negatives != 0 [
    set PV_sentiment PV_positives / PV_negatives
  ][
    stop
  ]
end

to calculate-EV-sentiment
  let EV_positive filter [ i -> i > 0.5 ] [EV_attitude] of energy_consumers
  let EV_negative filter [ i -> i < 0.5 ] [EV_attitude] of energy_consumers

  let EV_positives length EV_positive
  let EV_negatives length EV_negative

  ifelse EV_positives != 0 and EV_negatives != 0 [
    set EV_sentiment EV_positives / EV_negatives
  ][
    stop
  ]
end

to calculate-HP-sentiment
  let HP_positive filter [ i -> i > 0.5 ] [HP_attitude] of energy_consumers
  let HP_negative filter [ i -> i < 0.5 ] [HP_attitude] of energy_consumers

  let HP_positives length HP_positive
  let HP_negatives length HP_negative

  ifelse HP_positives != 0 and HP_negatives != 0 [
    set HP_sentiment HP_positives / HP_negatives
  ][
    stop
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; VISUALIZATION PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to visualize-trust
  ask links [
    if strength = 1 [
      set color white
    ]
    if strength > 1 [
      set color SPECIFY-FLOOR-CEILING! (69 - strength ^ 5) 63 69
    ]
    if strength < 1 [
      set color 15
      set thickness 0.75
    ]
  ]
end

to visualize-word-of-mouth-interaction
  ask turtle sender_ID [set color red]
  ask turtle receiver_ID [set color yellow]
  ask link sender_ID receiver_ID [
    set color yellow
    set thickness 2
  ]

  wait 1 / 25

  ask link sender_ID receiver_ID [
    set color white
    set thickness 0
  ]

  ask turtle sender_ID [set color default_color]
  ask turtle receiver_ID [set color default_color]
end

to plot-timer
  set-current-plot "timer"
  create-temporary-plot-pen "pen"
  set-current-plot-pen "pen"
  set-plot-pen-color black
  plot timer
end

to do-time-series-plots
  set-current-plot "hedonism timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 44
    plot hedonism
  ]

  set-current-plot "stimulation timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 43
    plot stimulation
  ]

  set-current-plot "self-direction timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 42
    plot self_direction
  ]

  set-current-plot "universalism timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 65
    plot universalism
  ]

  set-current-plot "benevolence timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 53
    plot benevolence
  ]

  set-current-plot "conformity and tradition timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 95
    plot conformity_tradition
  ]

  set-current-plot "security timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 105
    plot security
  ]

  set-current-plot "power timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 15
    plot power
  ]

  set-current-plot "achievement timeseries"
  ask energy_consumers [
    let agent (word who)
    create-temporary-plot-pen agent
    set-current-plot-pen agent
    set-plot-pen-color 25
    plot achievement
  ]
end

to plot-ideological-engagement
  set-current-plot "ideological engagement"
  create-temporary-plot-pen "ideology"
  set-current-plot-pen "ideology"
  set-plot-x-range 0 ceiling (max [ideological_engagement] of energy_consumers)
  set-plot-pen-interval (max [ideological_engagement] of energy_consumers) / 20
  set-plot-pen-mode 1
  histogram [ideological_engagement] of energy_consumers
end

to plot-social-links
  set-current-plot "social links"
  create-temporary-plot-pen "social links"
  set-current-plot-pen "social links"
  set-plot-x-range 0 ceiling (max [n_social_links] of energy_consumers)
  set-plot-pen-interval (max [n_social_links] of energy_consumers) / 20
  set-plot-pen-mode 1
  histogram [n_social_links] of energy_consumers
end


to do-histogram-plots
  let n_bars 20
  let penmode 1

  set-current-plot "hedonism histogram"
  create-temporary-plot-pen "hedonism"
  set-current-plot-pen "hedonism"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [hedonism] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [hedonism] of energy_consumers

  set-current-plot "stimulation histogram"
  create-temporary-plot-pen "stimulation"
  set-current-plot-pen "stimulation"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [stimulation] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [stimulation] of energy_consumers

  set-current-plot "self-direction histogram"
  create-temporary-plot-pen "self-direction"
  set-current-plot-pen "self-direction"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [self_direction] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [self_direction] of energy_consumers

  set-current-plot "universalism histogram"
  create-temporary-plot-pen "universalism"
  set-current-plot-pen "universalism"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [universalism] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [universalism] of energy_consumers

  set-current-plot "benevolence histogram"
  create-temporary-plot-pen "benevolence"
  set-current-plot-pen "benevolence"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [benevolence] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [benevolence] of energy_consumers

  set-current-plot "conformity and tradition histogram"
  create-temporary-plot-pen "conformity and tradition"
  set-current-plot-pen "conformity and tradition"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [conformity_tradition] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [conformity_tradition] of energy_consumers

  set-current-plot "security histogram"
  create-temporary-plot-pen "security"
  set-current-plot-pen "security"

  set-plot-x-range 0 1
  set-plot-pen-interval (max [security] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [security] of energy_consumers

  set-current-plot "power histogram"
  create-temporary-plot-pen "power"
  set-current-plot-pen "power"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [power] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [power] of energy_consumers

  set-current-plot "achievement histogram"
  create-temporary-plot-pen "achievement"
  set-current-plot-pen "achievement"
  set-plot-x-range 0 1
  set-plot-pen-interval (max [achievement] of energy_consumers) / n_bars
  set-plot-pen-mode penmode
  histogram [achievement] of energy_consumers

  if calculate_attitudes? [
    set-current-plot "pv_attitude"
    create-temporary-plot-pen "pv_attitude"
    set-current-plot-pen "pv_attitude"
    set-plot-x-range 0 1
    set-plot-pen-interval (max [pv_attitude] of energy_consumers) / n_bars
    set-plot-pen-mode penmode
    histogram [pv_attitude] of energy_consumers

    set-current-plot "ev_attitude"
    create-temporary-plot-pen "ev_attitude"
    set-current-plot-pen "ev_attitude"
    set-plot-x-range 0 1
    set-plot-pen-interval (max [ev_attitude] of energy_consumers) / n_bars
    set-plot-pen-mode penmode
    histogram [ev_attitude] of energy_consumers

    set-current-plot "HP_attitude"
    create-temporary-plot-pen "HP_attitude"
    set-current-plot-pen "HP_attitude"
    set-plot-x-range 0 1
    set-plot-pen-interval (max [HP_attitude] of energy_consumers) / n_bars
    set-plot-pen-mode penmode
    histogram [HP_attitude] of energy_consumers
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO-REPORTER PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report RETURN-MAX-ITEM! [#list]
  report position (max #list) #list
end

;This to-report procedure takes a list and transforms it into a string of values separated by '#sep'
to-report TRANSFORM-LIST! [#list #sep]
  report reduce [[x y] -> (word x #sep y)] #list
end

to-report COMPUTE-SURPRISE! [x y]
  ;Create easy to interpret local variables
  let observed x
  let presumed y

  ;SP3 = Shape Parameter 3
  ;SP3 is the y-value the function gives for x = 1
  ;SP4 = shape parameter 4
  ;SP4 modulates the shape (slope) of the exponential function
  let SP3 5
  let SP4 3

  let difference_AttPerf_levels abs (observed - presumed)
  let surprise SP3 * difference_AttPerf_levels ^ SP4
  report surprise
end

to-report SPECIFY-FLOOR-CEILING! [x #min #max]
  if x < #min [report #min]
  if x > #max [report #max]
  report x
end

to-report AGGREGATE-LISTS! [#list-of-lists]
  report reduce [[i j] -> (map + i j)] #list-of-lists
end

to-report CALCULATE-EUCLIDIAN-DISTANCE! [#list1 #list2]
  report sum (map [ [i j] -> (i - j) ^ 2 ] #list1 #list2)
end

to-report RETURN-POSITIONS! [x #list]
  let indices n-values length #list [ i -> i ]
  let result filter [ i -> item i #list = x ] indices
  report result
end

;This procedure takes a list of DISCRETE values (rankings) ranging from 1 to 5 and transforms it into a list of normally distributed CONTINUOUS values ranging from 0 to 1.
;This procedure is used to build the (initial) Schwartz value systems that agents hold
;The (initial) Schwartz value systems are either calibrated randomly or according to a qualitative description of Waarden-In-Nederland (WIN) segments (see global variable 'init_value_distribution')
to-report BUILD-SCHWARTZ-VALUE-SYSTEM! [#list]

  ;M = Mean
  let M_very_high 0.90
  let M_high 0.75
  let M_medium 0.50
  let M_low 0.25
  let M_very_low 0.10

  let spread 0.1

  ;Value '1' is ranked highest, value '5' is ranked lowest
  ;The following code checks what rank it finds in the list provided as input to the current reporter procedure
  ;It then transforms that rank into a normally distributed float lying in the range of 0.001 and 0.999
  let #newlist map [
    i -> ifelse-value (i = 1) [
      SPECIFY-FLOOR-CEILING! (random-normal M_very_high spread) 0.001 0.999
    ][
      ifelse-value (i = 2) [
        SPECIFY-FLOOR-CEILING! (random-normal M_high spread) 0.001 0.999
      ][
        ifelse-value (i = 3) [
          SPECIFY-FLOOR-CEILING! (random-normal M_medium spread) 0.001 0.999
        ][
          ifelse-value (i = 4) [
            SPECIFY-FLOOR-CEILING! (random-normal M_low spread) 0.001 0.999
          ][
            ifelse-value (i = 5) [
              SPECIFY-FLOOR-CEILING! (random-normal M_very_low spread) 0.001 0.999
            ] [i]
          ]
        ]
      ]
    ]
  ] #list
  report #newlist
end

;This procedure takes a list of DISCRETE values/rankings (0, 0.5 or 1) and transforms it into a list of normally distributed CONTINUOUS values ranging from 0 to 1.
;This procedure is used to transform the attribute performances (AttPerf) of a particular energy technology
;The attribute performances are scored from 0 = lower, 0.5 = similar, 1 = higher ... these ranks are assigned based on performance relative to a modal counterpart
;An example of a modal counterpart to an Electric Vehicle (EV) is an Internal Combustion Engine Vehicle (ICEV)
to-report BUILD-AttPerf-LIST! [#list]
  let M_lower 0.1
  let M_similar 0.5
  let M_higher 0.9
  let spread 0.025

  let #newlist map [
    i -> ifelse-value (i = 0) [
      SPECIFY-FLOOR-CEILING! (random-normal M_lower spread) 0.001 0.999
    ][
      ifelse-value (i = 0.5) [
        SPECIFY-FLOOR-CEILING! (random-normal M_similar spread) 0.001 0.999
      ][
        ifelse-value (i = 1) [
          SPECIFY-FLOOR-CEILING! (random-normal M_higher spread) 0.001 0.999
        ] [i]
      ]
    ]
  ] #list
  report #newlist
end

;This procedure counts the number of instances a particular item 'x' appears within a list.
to-report COUNT-ITEMS! [x #list]
  let instances length filter [i -> i = x] #list
  report instances
end

;This reporter procedure reports values ranging from 0 to 7 (representing indices for WIN segments) according to an underlying probability distribution ('proportions') (representing the distribution of WIN segments in Dutch society).
to-report PICK-WIN-SEGMENT!
  let win_indices [0 1 2 3 4 5 6 7]
  ;proportion of WIN segments taken from Aalbers (2006)
  let proportions [0.09 0.13 0.14 0.15 0.10 0.10 0.08 0.22]
  let pairs (map list win_indices proportions)
  ;report the first item of the pair selected using the second item (i.e., `last p`) as the weight
  report first rnd:weighted-one-of-list pairs [ [p] -> last p ]
end

;This reporter takes as input 2 value indices (a pair of competing values) and 2 lists of value levels (2x value systems).
;On the basis of these four inputs, it outputs 2 updated value levels.
;Specifically, the EXECUTE-VALUE-ANTAGONISM! procedure takes as inputs two competing values and determines how they influence one another as a result of one (or both) having changed in response to some value system disruption.
to-report EXECUTE-VALUE-ANTAGONISM! [#index1 #index2 #values_t1 #values_t0]
  ;Delta values will range from -0.2 to 0.2 (see 'execute-value-system-disruption' procedure)
  ;Determine change in value with index = #index1
  let delta_value1 (item #index1 #values_t1) - (item #index1 #values_t0)
  ;Determine change in value with index = #index2
  let delta_value2 (item #index2 #values_t1) - (item #index2 #values_t0)

  ;Initiate local variables
  let effect_dv1_v2 0
  let effect_dv2_v1 0
  let value1_changed 0
  let value2_changed 0

  ;Introduce a switch between executing this procedure in a multiplicative vs additive manner:
  let X "multiplicative"
  let Y "additive"
  ;VERIFIED: value systems seem to calibrate nicely using the additive calculation procedure (as checked via correlation matrices)
  let calculation_procedure Y

  ;delta_value is positive when new value > old value ... delta_value negative when new value < old value
  ;NOTE: 'value_antagonism' modulates the strength of the effect of a change in a particular value on its respective antagonist
  if calculation_procedure = X [
    ;MULTIPLICATIVE:

    ;When delta_value is positive, the antagonist's level will decrease
    ;When delta_value is negative, the antagonist's level will increase

    ;Determine the effect of a change in value 1 (dv1) on value 2 (v2)
    set effect_dv1_v2 1 - (delta_value1 * (1 + value_antagonism))
    ;Determine the effect of a change in value 2 (dv2) on value 1 (v1)
    set effect_dv2_v1 1 - (delta_value2 * (1 + value_antagonism))

    ;When value levels approach 0 or 1, their movement (the magnitude of change) towards extremity diminishes...
    ;...When this happens, antagonist values are not affected anymore...
    ;...In order to correct for this phenomenon, value levels that exceed 0.99 or fall below 0.01 exert a fixed influence on their antagonist.
    let fixed_effect 0.25

    if (item #index1 #values_t1) >= 0.99 [set effect_dv1_v2 1 - fixed_effect]
    if (item #index1 #values_t1) <= 0.01 [set effect_dv1_v2 1 + fixed_effect]

    if (item #index2 #values_t1) >= 0.99 [set effect_dv2_v1 1 - fixed_effect]
    if (item #index2 #values_t1) <= 0.01 [set effect_dv2_v1 1 + fixed_effect]

    ;determine changed level of value with index 1 as a result of a change in index 2
    set value1_changed (SPECIFY-FLOOR-CEILING! ((item #index1 #values_t1) * effect_dv2_v1) 0.001 0.999)
    ;determine changed level of value with index 2 as a result of a change in index 1
    set value2_changed (SPECIFY-FLOOR-CEILING! ((item #index2 #values_t1) * effect_dv1_v2) 0.001 0.999)
  ]
  if calculation_procedure = Y [
    ;ADDITIVE:

    ;When delta_value is positive, the antagonist's level will decrease
    ;When delta_value is negative, the antagonist's level will increase

    ;Determine the effect of a change in value 1 (dv1) on value 2 (v2)
    set effect_dv1_v2 delta_value1 * value_antagonism
    ;Determine the effect of a change in value 2 (dv2) on value 1 (v1)
    set effect_dv2_v1 delta_value2 * value_antagonism

    ;When value levels approach 0 or 1, their movement (the magnitude of change) towards extremity diminishes...
    ;...When this happens, antagonist values are not affected anymore...
    ;...In order to correct for this phenomenon, value levels that exceed 0.99 or fall below 0.01 exert a fixed influence on their antagonist.
    let fixed_effect 0.3

    if (item #index1 #values_t1) >= 0.99 [set effect_dv1_v2 fixed_effect]
    if (item #index1 #values_t1) <= 0.01 [set effect_dv1_v2 -1 * fixed_effect]

    if (item #index2 #values_t1) >= 0.99 [set effect_dv2_v1 fixed_effect]
    if (item #index2 #values_t1) <= 0.01 [set effect_dv2_v1 -1 * fixed_effect]

    set value1_changed (SPECIFY-FLOOR-CEILING! ((item #index1 #values_t1) - effect_dv2_v1) 0.001 0.999)
    set value2_changed (SPECIFY-FLOOR-CEILING! ((item #index2 #values_t1) - effect_dv1_v2) 0.001 0.999)
  ]
  report list value1_changed value2_changed
end

;This reporter procedure takes two (mutualistic) values as inputs and outputs their updated value levels
;Specifically, the EXECUTE-VALUE-MUTUALISM! computes the updated levels of a pair of mutualistic values that become more similar
to-report EXECUTE-VALUE-MUTUALISM! [#index1 #index2 #values]
  ;Load value levels into local variable
  let value1 (item #index1 #values)
  let value2 (item #index2 #values)

  ;Determine 'extremeness' of value 1 (used to determine direction of convergence)
  let value1_extremity (value1 - 0.5)
  ;Determine 'extremeness' of value 2 (used to determine direction of convergence)
  let value2_extremity (value2 - 0.5)

  ;Determine the difference between levels of value 1 and value 2 (used to determine strength of convergence)
  let value1_value2_diff abs (value1 - value2)

  ;Initiate (local) delta variables
  let delta_value1 0
  let delta_value2 0

  ;If balance of forces? Then values do not move towards one another
  if value1_extremity = value2_extremity [
    set delta_value1 0
    set delta_value2 0
  ]
  ;The global variable 'value_mutualism' modulates the strength of convergence between two mutualistic values.
  ;If value 1 is more extreme than value 2? Then value 2 will move towards value 1
  if abs value1_extremity > abs value2_extremity [
    set delta_value2 (value1_value2_diff * value_mutualism)
    if value1_extremity < 0 [set delta_value2 (delta_value2 * -1)]
  ]
  ;If value 1 is less extreme than value 2? Then value 1 will move towards value 2
  if abs value1_extremity < abs value2_extremity [
    set delta_value1 (value1_value2_diff * value_mutualism)
    if value2_extremity < 0 [set delta_value1 (delta_value1 * -1)]
  ]
  report list delta_value1 delta_value2
end

to-report FILTER-LIST! [#index #list1 #list2]
  ;First combine #list1 and #list2 into a new list
  let result (map list #list1 #list2)
  ;Then filter items from the combined list using the #index provided as input
  ;Specifically, apply a filter to 'result' by matching items in #list1 with #index
  set result filter [ i -> first i = #index ] result
  ;Map the last items of each sublist onto 'result'
  set result map last result
  ;Transform 'result' into lower order (unnested) list using reduce sentence
  set result reduce sentence result
  ;Report result
  report result
end

;The COMPUTE-ATTITUDE! reporter procedure takes 5 inputs:
;(1) a list of attitude function domain scores (see procedure 'load-attitude-function-scores')
;(2) a list of factual beliefs about attribute performance levels
;(3) a list of certainty levels tied to the factual beliefs about attribute performance levels
;(4) a boolean regarding the visibility of a particular energy technology
;(5) a boolean regarding the differentiatedness of a particular energy technology
;The COMPUTE-ATTITUDE! reporter procedure provides 1 output:
;(1) the level of overall attitude of a particular energy technology
to-report COMPUTE-ATTITUDE! [#list_AttFuncDom_scores #AttPerf_levels #certainty_levels #visible? #differentiated?]

  ;IMPORTANT ABBREVIATIONS:
  ;factBelief = Factual Belief
  ;AttPerf = Attribute Performance
  ;AttFuncDom = Attitude Function Domain
  ;UTIL = Utilitarian
  ;VEX = Value Expression
  ;SADJ = Social Adjustive

  ;IMPORTANT DEFINITIONS:
  ;Attribute Attitude = Evaluation of a particular technology attribute based on factual & affective beliefs.
  ;Attitude Function Domains = the three function domains are "Utilitarian", "Value Expression" and "Social Adjustive" (for a more detailed description of these domains, see below).

  ;CONCEPTUAL MODEL OF ATTRIBUTE ATTITUDE COMPUTATION:
  ;Factual Belief of AttPerf affects Attribute Attitude (LINK 1).
  ;Evaluation (Affective Belief) of AttPerf moderates link 1 (LINK 2).
  ;Certainty of AttPerf moderates link 2 (LINK 3).

  ;Transform AttPerf levels so that they fall on a scale ranging from -1 to 1.
  ;After transformation, the value 0 should be -1, value 0.5 should be 0 and the value 1 should stay 1.
  let AttPerf_transform map [i -> (i * 2) - 1] #AttPerf_levels

  ;CERTAINTY TIED TO EACH PRESUMPTION OF LEVEL OF ATTRIBUTE PERFORMANCE:
  ;The moderating effect of 'certainty' on LINK 2 has a log-shape.
  ;Thus, it is presumed that as 'certainty' increases, its effect on the strength of LINK 2 diminishes.
  ;Theoretically, it is presumed that agent's are more sensitive to changes in lower levels of certainty vs changes in higher levels of certainty (e.g. overconfidence).
  ;SP7 = Shape Parameter 7
  ;SP7 modulates the moderating (interaction) effect that certainty has on LINK 2 for each attribute.
  let SP7 0.3
  let certainty_transform map [i -> i ^ SP7] #certainty_levels

  ;(AFFECTIVE) EVALUATION OF EACH TECH ATTRIBUTE:
  ;For a detailed description of the three attidue function domains see procedure 'load-attitude-function-scores'.
  ;It is presumed that for each tech attribute, a different set of attitude function domains is relevant.
  ;Moreover, it is presumed that for each agent, the functions are weighed differently according to their personal preferences, traits and beliefs (values).

  let UTIL_scores item 0 #list_AttFuncDom_scores
  let VEX_scores item 1 #list_AttFuncDom_scores
  let SADJ_scores item 2 #list_AttFuncDom_scores

  ;Initiate attitude function sub-weights:
  let utilitarian_weight 1
  let value_expressive_weight 1
  let social_adjustive_weight 0

  ;Determine whether the technology is visible and differentiated (this has implications for the weight of the social adjustive function).
  let tech_visible? #visible?
  let tech_differentiated? #differentiated?

  ;If a technology is visible? It serves a social adjustive function
  ;If the technology is also highly differentiated? It serves a stronger social adjustive function
  if tech_visible? [set social_adjustive_weight social_adjustive_weight + 0.5]
  if tech_differentiated? [set social_adjustive_weight social_adjustive_weight + 0.5]

  ;Make lists of weights related to the three attitude function domains.
  ;NOTE: when a 'zero' is registered, this means that a particular attribute is NOT characterized by that attitude function: the respective weight must therefore be put to zero as well.
  let UTIL_weights []
  foreach UTIL_scores [
    x -> ifelse x != 0 [
      set UTIL_weights lput utilitarian_weight UTIL_weights
    ][
      set UTIL_weights lput 0 UTIL_weights
    ]
  ]

  let VEX_weights []
  foreach VEX_scores [
    x -> ifelse x != 0 [
      set VEX_weights lput value_expressive_weight VEX_weights
    ][
      set VEX_weights lput 0 VEX_weights
    ]
  ]

  let SADJ_weights []
  foreach SADJ_scores [
    x -> ifelse x != 0 [
      set SADJ_weights lput social_adjustive_weight SADJ_weights
    ][
      set SADJ_weights lput 0 SADJ_weights
    ]
  ]

  ;Compute weighted scores by multiplying the attitude function domain scores with their respective weights
  let weighted_UTIL_scores (map * UTIL_scores UTIL_weights)
  let weighted_VEX_scores (map * VEX_scores VEX_weights)
  let weighted_SADJ_scores (map * SADJ_scores SADJ_weights)

  ;Sum the weighted scores:
  let SUM_attitude_domains (map [ [x y z] -> x + y + z ] weighted_UTIL_scores weighted_VEX_scores weighted_SADJ_scores)
  ;Sum the weights:
  let SUM_weights (map [ [x y z] -> x + y + z ] UTIL_weights VEX_weights SADJ_weights)
  ;Divide the weighted scores by the weights to compute attribute evaluations
  ;Thus, attribute evaluations are the weighted average scores of utilitarian, value expressive, social adjustive functions of tech attributes
  let attr_evaluations (map / SUM_attitude_domains SUM_weights)

  ;ATTRIBUTE ATTITUDES
  ;In order to compute attribute attitudes, the agent's presumption about AttPerf, the certainty linked to that presumption and the consequent (affective) evaluation of AttPerf are combined in an 'attribute attitude' score.
  let attr_attitudes (map [ [x y z] -> x * y * z ] AttPerf_transform certainty_transform attr_evaluations)

  ;EMOTIONAL CONTENT & SALIENCE:
  ;It is presumed that attribute attitudes form part of a larger mental structure (an associative network) that links many different kinds of beliefs and cognitions (see e.g. Tesser & Shaffer, 1990).
  ;It is presumed that the availability of a particular attribute attitude varies within this mental structure.
  ;That is, an agent is not consciously aware of every attribute attitude at any given time; even if it tried to be this would not be possible due to cognitive constraints.
  ;Hence, the concept of 'salience' is introduced within the current model to represent the differing degrees of ease to which any attitude comes to mind when an agent is primed to do so.
  ;Salience is formalized as the sum of VEX and SADJ scores, as this is presumed to indicate the 'emotional or affective content' of an attribute attitude
  ;It is presumed that the higher the emotional content, the more swift an attribue attitude is retrieved from an agent's associative belief network and the stronger its effect on overall evaluation of an energy technology will be.
  let emo_content (map + weighted_VEX_scores weighted_SADJ_scores)
  set emo_content map abs emo_content

  ;It is presumed that the salience of an attitude concerning one specific attribute is related to its emotional content by means of a log-shape function (the output of the function is capped at a floor of 0.5 and ceiling of 1).
  ;This implies that the effect of emotional content on salience is strong at first, but diminishes as emotional content increases further.
  ;The emotional intensity follows a logarithmic law in conformity with Weber-Fechner’s law of being exposed to a given stimuli (see e.g. Brousmische et al., 2016).
  ;SP8 = Shape Parameter 8
  ;SP8 modulates the shape of the function that specifies the effect of emotional content on the salience of a particular attribute within an agents attitude formation process
  let SP8 0.25
  let salience map [i -> SPECIFY-FLOOR-CEILING! (i ^ SP8) 0.5 1] emo_content

  ;Salience is multiplied with attribute attitudes in order to compute the overall technology attitude.
  ;In doing so, highly salient attribute attitudes are more dominant in the formation of an overall attitude towards a particular energy technology.
  let salience_X_att (map * salience attr_attitudes)

  ;OVERALL ATTITUDE OF ENERGY TECHNOLOGY:
  ;To compute the raw tech attitude score, the sum of weighted attribute attitudes is divided by the sum of salience weights.
  let tech_attitude_RAW (reduce + salience_X_att / reduce + salience)

  ;The raw attitude score is consequently transformed so that it falls between 0 and 1 using a sigmoid function.
  ;SP9 = Shape Parameter 9
  ;SP9 modulates the slope (steepness) of the sigmoid curve.
  let SP9 10
  let tech_attitude 1 / (1 + e ^ (-1 * tech_attitude_RAW * SP9))

  ;Finally, the overall attitude towards a given energy technology is reported.
  report tech_attitude
end

;;;;;;;;;;;;;;;;;;;;;;;; SENSITIVITY ANALYSIS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup-lhs-parameter-settings
  load-experiments
  setup-parameters
end

to load-experiments
  ;Check to make sure the lhs data file exists in the same directory as the .nlogo model file:
  ifelse(file-exists? "lhs_parameter_samples.data" )
  [
    ;Save the data into a matrix (a list of lists), so it only needs to be loaded once.
    set lhs_matrix []
    file-open "lhs_parameter_samples.data"
    ;Read in all the data in the file:
    while [ not file-at-end? ]
    [
      ;File-read gives you variables.  In this case numbers and booleans
      ;Using file-read scans each individual number (or boolean) in the data file and loads it into the lhs matrix
      ;Each iteration appends 61 items into a list, this is done until the file is at an end...
      ;...since there are 61 items (variables, or columns) for each row in the data file...
      ;...there will be a total of N lists (rows) within the lhs list (i.e. lists within list = a matrix representation in netlogo)
      ;In order to see how many rows (experiments) the lhs_matrix variable contains, use the command 'length lhs_matrix' within an observer context
      set lhs_matrix sentence lhs_matrix (list (list
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;10
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;20
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;30
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;40
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;50
        file-read file-read file-read file-read file-read file-read file-read file-read file-read file-read ;60
        file-read ;total = 61 items
      ))
    ]
    ;; Done reading in patch information.  Close the file.
    file-close
  ][
    user-message "There is no appropriate .data file in current directory!"
  ]
end

to setup-parameters
  ;BehaviorSpace must modify the lhs_experiment_number variable (from 1 to N), where N is the number of experiments (i.e. the length of 'lhs_matrix' global variable)
  let currentExperiment item lhs_experiment_number lhs_matrix

  set experiment_ID item 0 currentExperiment
  set init_factStatement_AttPerf_levels item 1 currentExperiment
  set init_confidenceWeight_AttPerf_levels item 2 currentExperiment
  set init_value_distribution item 3 currentExperiment
  set social_influence_model item 4 currentExperiment
  set view_mode item 5 currentExperiment
  set antagonistic_dynamics? item 6 currentExperiment
  set calculate_attitudes? item 7 currentExperiment
  set calculate_awareness_confidence? item 8 currentExperiment
  set culturalization? item 9 currentExperiment

  set first_hand_exp? item 10 currentExperiment
  set histogram_plots? item 11 currentExperiment
  set introspection? item 12 currentExperiment
  set media_exp_model? item 13 currentExperiment
  set multilateral_influence? item 14 currentExperiment
  set mutualistic_dynamics? item 15 currentExperiment
  set plot_awareness? item 16 currentExperiment
  set plot_confidence? item 17 currentExperiment
  set social_influence_model? item 18 currentExperiment
  set social_media? item 19 currentExperiment

  set time_series_plots? item 20 currentExperiment
  set timer? item 21 currentExperiment
  set value_assessment_error? item 22 currentExperiment
  set value_proselytizing? item 23 currentExperiment
  set word_of_mouth_model? item 24 currentExperiment
  set n_ticks item 25 currentExperiment
  set economic_instability item 26 currentExperiment
  set social_instability item 27 currentExperiment
  set environmental_instability item 28 currentExperiment
  set technological_change item 29 currentExperiment

  set number_of_energy_consumers item 30 currentExperiment
  set peer_group_links item 31 currentExperiment
  set random_links item 32 currentExperiment
  set FHE_occurence_rate item 33 currentExperiment
  set media_exposure_rate item 34 currentExperiment
  set information_intake_error item 35 currentExperiment
  set media_influence item 36 currentExperiment
  set random_exposure item 37 currentExperiment
  set surprise_threshold item 38 currentExperiment
  set intentional_vs_incidental_exposure item 39 currentExperiment

  set mass_media_bias item 40 currentExperiment
  set filter_bubble item 41 currentExperiment
  set social_media_users item 42 currentExperiment
  set social_media_activity item 43 currentExperiment
  set hot_interaction_intensity item 44 currentExperiment
  set value_convergence item 45 currentExperiment
  set social_status_persuasiveness item 46 currentExperiment
  set interaction_threshold_heterogeneity item 47 currentExperiment
  set tolerance item 48 currentExperiment
  set hostility item 49 currentExperiment

  set individualism item 50 currentExperiment
  set optimal_distinctiveness item 51 currentExperiment
  set value_assessment_error item 52 currentExperiment
  set culturalization_strength item 53 currentExperiment
  set non_conformism_strength item 54 currentExperiment
  set cultural_expectation_error item 55 currentExperiment
  set peer_pressure item 56 currentExperiment
  set value_antagonism item 57 currentExperiment
  set value_mutualism item 58 currentExperiment
  set tech_disruption_scope item 59 currentExperiment

  set value_disruption_intensity item 60 currentExperiment
end

;Hedonism metrics
to-report meanHED
  report mean [hedonism] of energy_consumers
end

to-report medHED
  report median [hedonism] of energy_consumers
end

to-report sdHED
  report standard-deviation [hedonism] of energy_consumers
end

;Stimulation metrics
to-report meanSTM
  report mean [stimulation] of energy_consumers
end

to-report medSTM
  report median [stimulation] of energy_consumers
end

to-report sdSTM
  report standard-deviation [stimulation] of energy_consumers
end

;Self-direction metrics
to-report meanSD
  report mean [self_direction] of energy_consumers
end

to-report medSD
  report median [self_direction] of energy_consumers
end

to-report sdSD
  report standard-deviation [self_direction] of energy_consumers
end

;Universalism metrics
to-report meanUNI
  report mean [universalism] of energy_consumers
end

to-report medUNI
  report median [universalism] of energy_consumers
end

to-report sdUNI
  report standard-deviation [universalism] of energy_consumers
end

;Benevolence metrics
to-report meanBEN
  report mean [benevolence] of energy_consumers
end

to-report medBEN
  report median [benevolence] of energy_consumers
end

to-report sdBEN
  report standard-deviation [benevolence] of energy_consumers
end

;Conformity & tradition metrics
to-report meanCT
  report mean [conformity_tradition] of energy_consumers
end

to-report medCT
  report median [conformity_tradition] of energy_consumers
end

to-report sdCT
  report standard-deviation [conformity_tradition] of energy_consumers
end

;Security metrics
to-report meanSEC
  report mean [security] of energy_consumers
end

to-report medSEC
  report median [security] of energy_consumers
end

to-report sdSEC
  report standard-deviation [security] of energy_consumers
end

;Power metrics
to-report meanPOW
  report mean [power] of energy_consumers
end

to-report medPOW
  report median [power] of energy_consumers
end

to-report sdPOW
  report standard-deviation [power] of energy_consumers
end

;Achievement metrics
to-report meanACH
  report mean [achievement] of energy_consumers
end

to-report medACH
  report median [achievement] of energy_consumers
end

to-report sdACH
  report standard-deviation [achievement] of energy_consumers
end

;PV attitude metrics
to-report meanPVatt
  report mean [PV_attitude] of energy_consumers
end

to-report medPVatt
  report median [PV_attitude] of energy_consumers
end

to-report sdPVatt
  report standard-deviation [PV_attitude] of energy_consumers
end

;EV attitude metrics
to-report meanEVatt
  report mean [EV_attitude] of energy_consumers
end

to-report medEVatt
  report median [EV_attitude] of energy_consumers
end

to-report sdEVatt
  report standard-deviation [EV_attitude] of energy_consumers
end

;HP attitude metrics
to-report meanHPatt
  report mean [HP_attitude] of energy_consumers
end

to-report medHPatt
  report median [HP_attitude] of energy_consumers
end

to-report sdHPatt
  report standard-deviation [HP_attitude] of energy_consumers
end

;Coefficients of Variation (CV) for metrics (for determining metric variability over replication runs)
to-report cvHED
  report standard-deviation [hedonism] of energy_consumers / mean [hedonism] of energy_consumers
end

to-report cvSTM
  report standard-deviation [stimulation] of energy_consumers / mean [stimulation] of energy_consumers
end

to-report cvSD
  report standard-deviation [self_direction] of energy_consumers / mean [self_direction] of energy_consumers
end

to-report cvUNI
  report standard-deviation [universalism] of energy_consumers / mean [universalism] of energy_consumers
end

to-report cvBEN
  report standard-deviation [benevolence] of energy_consumers / mean [benevolence] of energy_consumers
end

to-report cvCT
  report standard-deviation [conformity_tradition] of energy_consumers / mean [conformity_tradition] of energy_consumers
end

to-report cvSEC
  report standard-deviation [security] of energy_consumers / mean [security] of energy_consumers
end

to-report cvPOW
  report standard-deviation [power] of energy_consumers / mean [power] of energy_consumers
end

to-report cvACH
  report standard-deviation [achievement] of energy_consumers / mean [achievement] of energy_consumers
end

to-report cvPVatt
  report standard-deviation [PV_attitude] of energy_consumers / mean [PV_attitude] of energy_consumers
end

to-report cvEVatt
  report standard-deviation [EV_attitude] of energy_consumers / mean [EV_attitude] of energy_consumers
end

to-report cvHPatt
  report standard-deviation [HP_attitude] of energy_consumers / mean [HP_attitude] of energy_consumers
end
@#$#@#$#@
GRAPHICS-WINDOW
656
143
1134
622
-1
-1
3.113
1
10
1
1
1
0
0
0
1
-75
75
-75
75
0
0
1
ticks
30.0

SLIDER
326
655
498
688
peer_group_links
peer_group_links
0
20
5.0
1
1
NIL
HORIZONTAL

SLIDER
326
695
498
728
random_links
random_links
0
0.25
0.1
0.01
1
NIL
HORIZONTAL

BUTTON
209
129
286
162
go once
go
NIL
1
T
OBSERVER
NIL
O
NIL
NIL
1

BUTTON
23
129
130
162
setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

SLIDER
28
698
281
732
number_of_energy_consumers
number_of_energy_consumers
0
1000
500.0
1
1
NIL
HORIZONTAL

BUTTON
136
129
199
162
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

SLIDER
20
1382
220
1415
value_convergence
value_convergence
0
0.5
0.25
0.01
1
NIL
HORIZONTAL

MONITOR
1132
906
1221
951
total links
count links
17
1
11

PLOT
519
1152
719
1297
hedonism timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

CHOOSER
28
648
233
693
init_value_distribution
init_value_distribution
1 2
0

SLIDER
20
1506
145
1539
tolerance
tolerance
0
0.5
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
20
1546
145
1579
hostility
hostility
0
0.5
0.25
0.01
1
NIL
HORIZONTAL

PLOT
729
1152
929
1297
stimulation timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
729
1809
929
1959
power timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
519
1809
719
1959
security timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
939
1482
1139
1627
conformity and tradition timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
939
1152
1139
1297
self-direction timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
729
1482
929
1627
benevolence timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
939
1809
1139
1959
achievement timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

PLOT
519
1482
719
1627
universalism timeseries
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS

BUTTON
659
98
747
133
spring
layout-spring energy_consumers links 1 20 80
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
290
1915
470
1948
value_antagonism
value_antagonism
0
1
0.5
0.01
1
NIL
HORIZONTAL

CHOOSER
22
1288
224
1334
social_influence_model
social_influence_model
1 2 3 4
3

SLIDER
20
1422
225
1455
social_status_persuasiveness
social_status_persuasiveness
0
0.2
0.075
0.01
1
NIL
HORIZONTAL

SLIDER
155
1505
351
1538
individualism
individualism
0
0.05
0.025
0.005
1
NIL
HORIZONTAL

SLIDER
15
1752
240
1785
culturalization_strength
culturalization_strength
0.1
2
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
155
1545
352
1578
optimal_distinctiveness
optimal_distinctiveness
0
2
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
290
1955
470
1988
value_mutualism
value_mutualism
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
20
1462
272
1495
interaction_threshold_heterogeneity
interaction_threshold_heterogeneity
0
1
0.5
0.1
1
NIL
HORIZONTAL

SWITCH
20
1589
232
1622
value_assessment_error?
value_assessment_error?
0
1
-1000

SWITCH
35
1913
282
1946
introspection?
introspection?
0
1
-1000

OUTPUT
1149
143
1824
622
12

TEXTBOX
50
623
218
655
Agent Spawn Settings
13
0.0
1

TEXTBOX
36
1222
264
1251
Social Interaction Model Settings
13
0.0
1

TEXTBOX
202
1886
374
1919
Introspection Settings
13
0.0
1

SWITCH
15
1712
240
1745
culturalization?
culturalization?
0
1
-1000

TEXTBOX
40
1692
238
1724
Culturalization Settings
13
0.0
1

TEXTBOX
296
628
535
660
Social Network Topology Settings
13
0.0
1

SLIDER
239
1588
446
1621
value_assessment_error
value_assessment_error
0
0.2
0.05
0.01
1
NIL
HORIZONTAL

SWITCH
269
1716
461
1749
multilateral_influence?
multilateral_influence?
0
1
-1000

SLIDER
269
1756
464
1789
peer_pressure
peer_pressure
0
1
0.25
0.01
1
NIL
HORIZONTAL

TEXTBOX
265
1696
494
1728
Multilateral Influence Settings
13
0.0
1

SLIDER
76
522
246
555
economic_instability
economic_instability
0.01
0.99
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
253
522
440
555
technological_change
technological_change
0.01
0.99
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
76
562
245
595
social_instability
social_instability
0.01
0.99
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
272
1143
442
1176
FHE_occurence_rate
FHE_occurence_rate
0
1
0.0
0.01
1
NIL
HORIZONTAL

BUTTON
290
129
415
164
default settings
default-settings-all-vars\ndefault-settings-experimental-settings
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

SLIDER
15
1792
240
1825
non_conformism_strength
non_conformism_strength
0
2
1.0
0.01
1
NIL
HORIZONTAL

PLOT
1129
772
1332
895
social links
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

SLIDER
253
562
443
595
environmental_instability
environmental_instability
0.01
0.99
0.5
0.01
1
NIL
HORIZONTAL

TEXTBOX
150
499
404
526
Exogenous Variable Settings
13
0.0
1

TEXTBOX
31
748
291
780
Media Exposure Settings
13
0.0
1

SLIDER
20
1342
220
1375
hot_interaction_intensity
hot_interaction_intensity
0
1
0.8
0.01
1
NIL
HORIZONTAL

TEXTBOX
302
765
514
784
Factual Belief Settings
13
0.0
1

SLIDER
25
888
215
921
media_exposure_rate
media_exposure_rate
0
1
0.82
0.01
1
NIL
HORIZONTAL

CHOOSER
270
792
495
838
init_factStatement_AttPerf_levels
init_factStatement_AttPerf_levels
1 2 3
1

SLIDER
25
928
215
961
information_intake_error
information_intake_error
0
0.1
0.05
0.01
1
NIL
HORIZONTAL

CHOOSER
270
848
516
894
init_confidenceWeight_AttPerf_levels
init_confidenceWeight_AttPerf_levels
1 2
0

SLIDER
25
968
215
1001
surprise_threshold
surprise_threshold
0.01
5
1.0
0.1
1
NIL
HORIZONTAL

CHOOSER
25
169
285
214
view_mode
view_mode
1 2 3
0

SLIDER
25
1008
275
1041
intentional_vs_incidental_exposure
intentional_vs_incidental_exposure
0
1
0.8
0.01
1
NIL
HORIZONTAL

SLIDER
25
1048
197
1081
filter_bubble
filter_bubble
0
1
0.9
0.01
1
NIL
HORIZONTAL

SLIDER
25
1088
197
1121
mass_media_bias
mass_media_bias
0
0.5
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
25
1128
197
1161
random_exposure
random_exposure
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
25
1168
197
1201
media_influence
media_influence
0
0.5
0.1
0.01
1
NIL
HORIZONTAL

SWITCH
25
769
228
802
media_exp_model?
media_exp_model?
0
1
-1000

SWITCH
25
809
227
842
word_of_mouth_model?
word_of_mouth_model?
0
1
-1000

SWITCH
22
1248
224
1281
social_influence_model?
social_influence_model?
0
1
-1000

PLOT
939
999
1139
1149
self-direction histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
729
999
929
1149
stimulation histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
519
999
719
1149
hedonism histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
519
1329
719
1479
universalism histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
729
1329
929
1479
benevolence histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
939
1329
1139
1479
conformity and tradition histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
519
1652
719
1802
security histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
729
1652
929
1802
power histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
939
1652
1139
1802
achievement histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

SLIDER
289
1399
449
1432
social_media_activity
social_media_activity
0
1
0.67
0.01
1
NIL
HORIZONTAL

SLIDER
289
1359
449
1392
social_media_users
social_media_users
0
1
0.73
0.01
1
NIL
HORIZONTAL

SWITCH
289
1319
449
1352
social_media?
social_media?
0
1
-1000

MONITOR
1599
799
1731
844
societal threat
societal_threat_level
3
1
11

MONITOR
1596
858
1728
903
societal uncertainty
societal_uncertainty_level
3
1
11

MONITOR
1739
799
1827
844
MWS
mean [mean_world_syndrome] of energy_consumers
3
1
11

SLIDER
115
2120
334
2153
tech_disruption_scope
tech_disruption_scope
0
1
0.05
0.01
1
NIL
HORIZONTAL

SWITCH
35
1953
283
1986
antagonistic_dynamics?
antagonistic_dynamics?
0
1
-1000

SWITCH
35
1993
284
2026
mutualistic_dynamics?
mutualistic_dynamics?
0
1
-1000

TEXTBOX
39
2056
434
2087
Technology Mediated Value System Disruption Settings
13
0.0
1

SLIDER
115
2080
332
2113
value_disruption_intensity
value_disruption_intensity
0
0.5
0.1
0.01
1
NIL
HORIZONTAL

PLOT
1176
1448
1376
1598
pv_attitude
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

MONITOR
1180
1662
1383
1707
mean PV
mean [PV_attitude] of energy_consumers
4
1
11

PLOT
1393
1448
1593
1598
hp_attitude
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

PLOT
1603
1448
1803
1598
ev_attitude
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

MONITOR
1603
1665
1807
1710
mean EV
mean [EV_attitude] of energy_consumers
4
1
11

MONITOR
1393
1662
1591
1707
mean HP
mean [hp_attitude] of energy_consumers
4
1
11

SWITCH
272
1105
440
1138
first_hand_exp?
first_hand_exp?
1
1
-1000

BUTTON
1149
103
1256
136
NIL
clear-output
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
579
678
686
711
profiler?
profiler?
1
1
-1000

PLOT
693
678
973
798
timer
NIL
NIL
0.0
10.0
0.0
0.5
true
false
"" ""
PENS

TEXTBOX
653
648
803
666
Model Diagnostics
14
0.0
1

TEXTBOX
136
100
324
123
General Model Settings
14
0.0
1

TEXTBOX
782
886
927
904
Metrics: Values
14
0.0
1

SWITCH
749
915
916
948
time_series_plots?
time_series_plots?
1
1
-1000

SWITCH
749
955
919
988
histogram_plots?
histogram_plots?
1
1
-1000

SWITCH
579
718
687
751
timer?
timer?
1
1
-1000

PLOT
1476
1133
1676
1283
Awareness
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

SWITCH
1502
1093
1661
1126
plot_awareness?
plot_awareness?
1
1
-1000

PLOT
1266
1133
1466
1283
Confidence
NIL
NIL
0.0
10.0
0.0
6.0
true
false
"" ""
PENS

SWITCH
1292
1093
1451
1126
plot_confidence?
plot_confidence?
1
1
-1000

SWITCH
31
269
204
302
fix_seed?
fix_seed?
1
1
-1000

TEXTBOX
259
1075
479
1106
Direct Info Exposure Settings
13
0.0
1

SLIDER
295
175
424
208
n_ticks
n_ticks
0
2500
2500.0
1
1
NIL
HORIZONTAL

TEXTBOX
190
233
460
266
BehaviorSpace Experiment Settings
14
0.0
1

MONITOR
1176
1608
1379
1653
NIL
PV_sentiment
4
1
11

MONITOR
1603
1612
1805
1657
NIL
EV_sentiment
4
1
11

MONITOR
1393
1608
1592
1653
HP_sentiment
hp_sentiment
17
1
11

SLIDER
15
1832
243
1865
cultural_expectation_error
cultural_expectation_error
0
0.1
0.05
0.01
1
NIL
HORIZONTAL

SWITCH
1403
1398
1571
1431
calculate_attitudes?
calculate_attitudes?
1
1
-1000

SWITCH
1355
1043
1608
1076
calculate_awareness_confidence?
calculate_awareness_confidence?
1
1
-1000

TEXTBOX
1416
1368
1631
1394
Metrics: Attitudes\n
13
0.0
1

TEXTBOX
1373
1015
1675
1053
Metrics: Awareness & Confidence
13
0.0
1

SWITCH
20
1629
232
1662
value_proselytizing?
value_proselytizing?
0
1
-1000

MONITOR
1266
1293
1466
1338
confidence
population_confidence_level
4
1
11

MONITOR
1480
1293
1678
1338
awareness
population_awareness_level
4
1
11

SLIDER
31
443
243
476
output_tick_discretization
output_tick_discretization
0
2000
50.0
1
1
NIL
HORIZONTAL

SWITCH
31
312
206
345
sensitivity_analysis?
sensitivity_analysis?
1
1
-1000

MONITOR
1849
188
1952
233
broad mind
count energy_consumers with [win_segment = 0]
2
1
11

MONITOR
1849
243
1955
288
social mind
count energy_consumers with [win_segment = 1]
17
1
11

MONITOR
1849
300
1955
345
caring faithful
count energy_consumers with [win_segment = 2]
17
1
11

MONITOR
1849
356
1955
401
conservative
count energy_consumers with [win_segment = 3]
17
1
11

MONITOR
1849
413
1955
458
hedonist
count energy_consumers with [win_segment = 4]
17
1
11

MONITOR
1849
468
1955
513
materialist
count energy_consumers with [win_segment = 5]
17
1
11

MONITOR
1851
523
1954
568
professional
count energy_consumers with [win_segment = 6]
17
1
11

MONITOR
1851
589
1954
634
balanced mind
count energy_consumers with [win_segment = 7]
17
1
11

TEXTBOX
1858
158
2073
184
WIN Segments
13
0.0
1

SWITCH
31
352
206
385
default_settings?
default_settings?
0
1
-1000

SWITCH
31
400
243
433
output_tick_discretization?
output_tick_discretization?
0
1
-1000

PLOT
1376
766
1576
892
ideological engagement
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

MONITOR
1378
902
1577
947
ideological engagement
mean [ideological_engagement] of energy_consumers
4
1
11

SWITCH
1372
725
1598
758
plot_ideological_engagement?
plot_ideological_engagement?
1
1
-1000

MONITOR
1226
906
1338
951
mean social links
mean [n_social_links] of energy_consumers
3
1
11

SWITCH
218
269
403
302
hypothesis_testing?
hypothesis_testing?
1
1
-1000

SWITCH
419
269
614
302
sim_testing?
sim_testing?
1
1
-1000

SWITCH
420
310
615
343
sim_variable_testing?
sim_variable_testing?
1
1
-1000

SWITCH
1129
729
1341
762
plot_social_links?
plot_social_links?
1
1
-1000

BUTTON
1270
105
1417
139
NIL
show-correlations
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1428
105
1575
139
NIL
show-descriptives
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
216
313
413
346
culturalization_testing?
culturalization_testing?
1
1
-1000

SWITCH
216
358
408
391
introspection_testing?
introspection_testing?
1
1
-1000

SWITCH
419
355
611
388
activate_only_sim?
activate_only_sim?
1
1
-1000

SWITCH
23
849
227
882
cultural_bias?
cultural_bias?
0
1
-1000

MONITOR
1739
858
1829
903
sd MWS
standard-deviation [mean_world_syndrome] of energy_consumers
3
1
11

TEXTBOX
1408
688
1623
714
Monitors
14
0.0
1

TEXTBOX
290
1279
505
1305
Social Media Settings
13
0.0
1

TEXTBOX
35
23
1114
73
Energy Consumer Belief Change Simulator (ECBCS)
25
13.0
1

@#$#@#$#@
# Energy Consumer Belief Change Simulator (ECBCS)

Author: Kurt Kreulen
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

exclamation
false
0
Circle -7500403 true true 103 198 95
Polygon -7500403 true true 135 180 165 180 210 30 180 0 120 0 90 30

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="HYPOTHESIS_TESTING" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="1"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>Plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [ideological_engagement] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="environmental_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="technological_change">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="media_influence">
      <value value="0.01"/>
      <value value="0.51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mass_media_bias">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="filter_bubble">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="intentional_vs_incidental_exposure">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SIM_VARIABLES_2LEVELS" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>Plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [ideological_engagement] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interaction_threshold_heterogeneity">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tolerance">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hostility">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism">
      <value value="0.005"/>
      <value value="0.045"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="optimal_distinctiveness">
      <value value="0.05"/>
      <value value="1.95"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SIM_SETTINGS" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_value_distribution">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social_influence_model">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="CULTURALIZATION" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_strength">
      <value value="0.05"/>
      <value value="1.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer_pressure">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTROSPECTION" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_value_distribution">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value_antagonism">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value_mutualism">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tech_disruption_scope">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value_disruption_intensity">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="PRE-TEST" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <metric>cvHED</metric>
    <metric>cvSTM</metric>
    <metric>cvSD</metric>
    <metric>cvUNI</metric>
    <metric>cvBEN</metric>
    <metric>cvCT</metric>
    <metric>cvSEC</metric>
    <metric>cvPOW</metric>
    <metric>cvACH</metric>
    <metric>cvPVatt</metric>
    <metric>cvEVatt</metric>
    <metric>cvHPatt</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SIM_VARIABLES_2LEVELS_NEW" repetitions="3" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interaction_threshold_heterogeneity">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tolerance">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hostility">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism">
      <value value="0.005"/>
      <value value="0.045"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MEDIA_EXPOSURE" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="1"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="media_influence">
      <value value="0.01"/>
      <value value="0.51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mass_media_bias">
      <value value="0.05"/>
      <value value="0.45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="filter_bubble">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="intentional_vs_incidental_exposure">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic_instability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social_instability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="environmental_instability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="technological_change">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SYSTEM_INSTABILITY" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="1"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>sim_model_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_model_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim_model?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="media_influence">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mass_media_bias">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="filter_bubble">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="intentional_vs_incidental_exposure">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="environmental_instability">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="technological_change">
      <value value="0.05"/>
      <value value="0.95"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="DEFAULT_MODEL" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat output_tick_discretization + 1 [go]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="40"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>fix_seed?</metric>
    <metric>sensitivity_analysis?</metric>
    <metric>default_settings?</metric>
    <metric>hypothesis_testing?</metric>
    <metric>culturalization_testing?</metric>
    <metric>introspection_testing?</metric>
    <metric>sim_testing?</metric>
    <metric>sim_variable_testing?</metric>
    <metric>activate_only_sim?</metric>
    <metric>output_tick_discretization?</metric>
    <metric>output_tick_discretization</metric>
    <metric>profiler?</metric>
    <metric>timer?</metric>
    <metric>time_series_plots?</metric>
    <metric>histogram_plots?</metric>
    <metric>plot_awareness?</metric>
    <metric>plot_confidence?</metric>
    <metric>plot_ideological_engagement?</metric>
    <metric>first_hand_exp?</metric>
    <metric>media_exp_model?</metric>
    <metric>word_of_mouth_model?</metric>
    <metric>social_influence_model?</metric>
    <metric>social_media?</metric>
    <metric>value_proselytizing?</metric>
    <metric>value_assessment_error?</metric>
    <metric>culturalization?</metric>
    <metric>multilateral_influence?</metric>
    <metric>intra_value_system_dynamics?</metric>
    <metric>antagonistic_dynamics?</metric>
    <metric>mutualistic_dynamics?</metric>
    <metric>calculate_attitudes?</metric>
    <metric>calculate_awareness_confidence?</metric>
    <metric>plot_social_links?</metric>
    <metric>economic_instability</metric>
    <metric>social_instability</metric>
    <metric>environmental_instability</metric>
    <metric>technological_change</metric>
    <metric>media_influence</metric>
    <metric>mass_media_bias</metric>
    <metric>filter_bubble</metric>
    <metric>intentional_vs_incidental_exposure</metric>
    <metric>culturalization_strength</metric>
    <metric>peer_pressure</metric>
    <metric>social_influence_model</metric>
    <metric>interaction_threshold_heterogeneity</metric>
    <metric>tolerance</metric>
    <metric>hostility</metric>
    <metric>individualism</metric>
    <metric>optimal_distinctiveness</metric>
    <metric>init_value_distribution</metric>
    <metric>view_mode</metric>
    <metric>n_ticks</metric>
    <metric>number_of_households</metric>
    <metric>peer_group_links</metric>
    <metric>random_links</metric>
    <metric>factBelief_AttPerf_levels</metric>
    <metric>factBelief_certainty_levels</metric>
    <metric>FHE_occurence_rate</metric>
    <metric>media_exposure_rate</metric>
    <metric>information_intake_error</metric>
    <metric>random_exposure</metric>
    <metric>surprise_threshold</metric>
    <metric>social_media_users</metric>
    <metric>social_media_activity</metric>
    <metric>hot_interaction_intensity</metric>
    <metric>value_convergence</metric>
    <metric>value_assessment_error</metric>
    <metric>social_status_persuasiveness</metric>
    <metric>non_conformism_strength</metric>
    <metric>cultural_expectation_error</metric>
    <metric>value_antagonism</metric>
    <metric>value_mutualism</metric>
    <metric>tech_disruption_scope</metric>
    <metric>value_disruption_intensity</metric>
    <metric>TRANSFORM-LIST! [hedonism] of households ","</metric>
    <metric>TRANSFORM-LIST! [stimulation] of households ","</metric>
    <metric>TRANSFORM-LIST! [self_direction] of households ","</metric>
    <metric>TRANSFORM-LIST! [universalism] of households ","</metric>
    <metric>TRANSFORM-LIST! [benevolence] of households ","</metric>
    <metric>TRANSFORM-LIST! [conformity_tradition] of households ","</metric>
    <metric>TRANSFORM-LIST! [security] of households ","</metric>
    <metric>TRANSFORM-LIST! [power] of households ","</metric>
    <metric>TRANSFORM-LIST! [achievement] of households ","</metric>
    <metric>TRANSFORM-LIST! [PV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [EV_attitude] of households ","</metric>
    <metric>TRANSFORM-LIST! [HP_attitude] of households ","</metric>
    <metric>PV_sentiment</metric>
    <metric>EV_sentiment</metric>
    <metric>HP_sentiment</metric>
    <metric>population_awareness_level</metric>
    <metric>population_confidence_level</metric>
    <metric>societal_threat_level</metric>
    <metric>societal_uncertainty_level</metric>
    <enumeratedValueSet variable="fix_seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity_analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="default_settings?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hypothesis_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="culturalization_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="introspection_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sim_variable_testing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="activate_only_sim?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="output_tick_discretization">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
