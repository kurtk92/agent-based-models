globals [ ]

breed [ households household ]
breed [ municipalities municipality ]
breed [ companies company ]

turtles-own [ ]
households-own [ ]
municipalities-own [ ]
companies-own [ ]

;;;SETUP & GO;;;

to setup
  clear-all
  setup-households
  setup-municipalities
  setup-companies
  reset-ticks
end

to setup-households
  create-households 10000 [
    set color yellow
    set size 0.5
    set shape "house"
    setxy -15 random-ycor
    set perception random-float 0.1
    set knowledge random-float 0.1
    set types one-of [ "Single" "Couple" "Family" "Old" ] ;; set the population distribution according to the text (single: 18, old: 13 etc)
  ]
end

to setup-municipalities
  create-municipalities 10 [
    set color green
    set size 2
    set shape "circle"
    setxy random-float -29 + 14.5 random-float -29 + 14.5 ;;; Must be random between -14 and +14 on x and y axabita =yself]
    set infrastructure 0 ]
  ask households  [ create-link-to one-of municipalities ]
  ask links [ hide-link ]
end

to setup-companies
  create-companies 4 [
    set color red
    set size 1.5
    set shape "truck"
    setxy random-float -29 + 14.5 random-float -29 + 14.5
    set technologyrecperc random-float 0.1 + 0.8
    set volume/month 100
    set opex (random-float -0.2 + 1.1) * average_operational_costs ]
end

to go
  if ticks >= 240 [ stop ] ;; stop after 30 years
  ask companies [ collect-waste create-offers sell-plastic finance-operations give-subcontract]
  ask households [ make-waste ]
  ask municipalities [ create-totalbasewaste sign-contract spend-budget ]
  ifelse sum [totalbasewaste] of municipalities > 0 [ set reporterGraph ((sum [recoveredplastic] of companies * 100 )/ sum [totalbasewaste] of municipalities)][set reporterGraph 0] ;; Verification
  tick
end

;;;HOUSEHOLDS;;;

to make-waste
  if types = "Old"
  [set basewaste 30 - 0.04 * ticks - (exp (-0.01 * ticks) * sin (0.3 * ticks))]
  if types = "Family"
  [set basewaste 45 - 0.04 * ticks - (exp (-0.01 * ticks) * sin (0.3 * ticks))]
  if types = "Couple"
  [set basewaste 40 - 0.04 * ticks - (exp (-0.01 * ticks) * sin (0.3 * ticks))]
  if types = "Single"
  [set basewaste 35 - 0.04 * ticks - (exp (-0.01 * ticks) * sin (0.3 * ticks))]

  set plasticfraction 0.25 + (perception / 10)
  set recyclablefraction 0.8 + (knowledge / 10)

  set plasticwaste plasticfraction * basewaste
  set recyclableplastic recyclablefraction * plasticwaste
end

;;;MUNICIPALITIES;;;

to create-totalbasewaste
  set totalbasewaste sum [ basewaste ] of in-link-neighbors
  set totalplasticwaste sum [ plasticwaste ] of in-link-neighbors
  set totalrecyclableplastic sum [ recyclableplastic ] of in-link-neighbors

  set population (1 * count in-link-neighbors with [ types = "Single" ]  + 2 * count in-link-neighbors with [ types = "Couple" ] + 4 * count in-link-neighbors with [ types = "Family" ] + 2 * count in-link-neighbors with [ types = "Old" ])

  set totalbasewaste totalbasewaste / 1000
  set totalplasticwaste totalplasticwaste / 1000
  set totalrecyclableplastic totalrecyclableplastic / 1000

  if infrastructure = 1 [
    set totalbasewaste totalbasewaste * 0.8
    set totalplasticwaste totalplasticwaste * 0.9
    set totalrecyclableplastic totalrecyclableplastic * 0.9 ]

  set budget budget + (govtfund * population )
  set initial-budget budget
end

to sign-contract
  if contractlength != 0 [ stop ]

  ask my-out-links [ die ] ;; makes sure we delete links when the contract expires
  set list-of-offers1 [wasteprice1] of companies in-radius 12
  if list-of-offers1 =[]
    [set list-of-offers1 [wasteprice1] of companies]
  set list-of-offers2 [wasteprice2] of companies in-radius 12
  if list-of-offers2 =[]
    [set list-of-offers2 [wasteprice2] of companies]

  ifelse infrastructure = 1 [
    set contractprice min list-of-offers1
    create-link-to one-of companies with [ wasteprice1 = [ contractprice ] of myself ]
    set cost-of-collection contractprice * 0.8
    set collection-income cost-of-collection * totalbasewaste ]

  [ set contractprice min list-of-offers2
     create-link-to one-of companies with [ wasteprice2 = [ contractprice ] of myself ]
     set cost-of-collection contractprice * 0.8
     set collection-income cost-of-collection * totalbasewaste ]

  set contractlength 36
  set wastesupply totalplasticwaste - 0.2
end

to spend-budget
  ifelse wastesupply > totalplasticwaste [
    set fine sellingprice
    set totalfine ((wastesupply - totalplasticwaste) * fine) ]
  [set totalfine 0]

  set collectionexpense (contractprice * totalbasewaste)
  set budget budget - (collectionexpense + totalfine)
  if totalbasewaste != 0 and [recoveredplastic] of out-link-neighbors != 0 [
  set recyclingfraction (totalrecyclableplastic * [technologyrecperc] of one-of out-link-neighbors) / totalbasewaste ]
   ;;; set the recycling percentage for a municipality

  ifelse (govttarget / 100) <= recyclingfraction [

  ifelse infrastructure = 0 [
    ifelse budget > (0.3 * govtfund * population) [
      set awareness-effort (0.15 * govtfund * population)
      ask in-link-neighbors [ set perception perception + 0.004 ] ]
    [ set awareness-effort 0 ]

  ifelse budget > (0.5 * govtfund * population) [
    set educate-effort (govtfund * 0.15 * population)
    ask in-link-neighbors [ set knowledge knowledge + 0.003 ] ]
  [ set educate-effort 0 ]

   ifelse budget > (govtfund * 0.9 * population) [
     set invest-infra govtfund * 0.5 * population ]
   [ set invest-infra 0 ]

   set budget budget - (awareness-effort + educate-effort + invest-infra)
   set invest-fund invest-fund + invest-infra

   if (invest-fund > 10000) [ set infrastructure 1 ] ]

 [ ifelse budget > (0.3 * govtfund * population) [
     set awareness-effort (0.2 * govtfund * population)
     ask in-link-neighbors [ set perception perception + 0.007 ] ]
  [ set awareness-effort 0 ]

  ifelse budget > (0.5 * govtfund * population) [
    set educate-effort (govtfund * 0.2 * population)
    ask in-link-neighbors [ set knowledge knowledge + 0.004 ] ]
  [ set educate-effort 0 ]

  set budget budget - (awareness-effort + educate-effort ) ]

 ]

  [

  ifelse infrastructure = 0 [
    ifelse budget > (0.3 * govtfund * population) [
      set awareness-effort (0.3 * govtfund * population)
      ask in-link-neighbors [ set perception perception + 0.01 ] ]
    [ set awareness-effort 0 ]

  ifelse budget > (0.5 * govtfund * population) [
    set educate-effort (govtfund * population * 0.2)
    ask in-link-neighbors [ set knowledge knowledge + 0.006 ] ]
  [ set educate-effort 0 ]

   ifelse budget > (govtfund * 0.9 * population) [
     set invest-infra govtfund * 0.5 * population ]
   [ set invest-infra 0 ]

   set budget budget - (awareness-effort + educate-effort + invest-infra)
   set invest-fund invest-fund + invest-infra

   if (invest-fund > 10000) [ set infrastructure 1 ] ]

 [ ifelse budget > (0.4 * govtfund * population) [
     set awareness-effort (0.4 * govtfund * population)
     ask in-link-neighbors [ set perception perception + 0.014 ] ]
  [ set awareness-effort 0 ]

  ifelse budget > (0.6 * govtfund * population) [
    set educate-effort (govtfund * 0.5 * population)
    ask in-link-neighbors [ set knowledge knowledge + 0.008 ] ]
  [ set educate-effort 0 ]

  set budget budget - (awareness-effort + educate-effort ) ] ]
end

;;;COMPANIES;;;

to collect-waste
  set comptotalbasewaste sum [ totalbasewaste ] of in-link-neighbors
  set comptotalplasticwaste sum [ totalplasticwaste ] of in-link-neighbors
  set comptotalrecyclableplastic sum [ totalrecyclableplastic ] of in-link-neighbors

  ask in-link-neighbors [ set contractlength contractlength - 1 ]
end

to create-offers
  set wasteprice1 random-float 1 + 1    ;; in 1000 euros per ton
  set wasteprice2 random-float 2 + 2    ;; in 1000 euros per ton
end

to give-subcontract
  ifelse comptotalbasewaste <= volume/month [ stop ]

  [ set subcontract 1
    set leftovertbw comptotalbasewaste - volume/month
    set comptotalbasewaste comptotalbasewaste - leftovertbw
    set leftovertpw (comptotalplasticwaste / comptotalbasewaste) * leftovertbw ;;same ratio of plasticwaste to basewaste
    set comptotalplasticwaste comptotalplasticwaste - leftovertpw
    set leftovertrp (comptotalrecyclableplastic / comptotalbasewaste) * leftovertbw ;; same ratio of recyclableplastic to basewaste
    set comptotalrecyclableplastic comptotalrecyclableplastic - leftovertrp
    set subcontractor one-of companies with-min [comptotalbasewaste]

    ask subcontractor [
      set subcontract 2
      set comptotalbasewaste comptotalbasewaste + [ leftovertbw ] of myself
      set comptotalplasticwaste comptotalplasticwaste + [ leftovertpw ] of myself
      set comptotalrecyclableplastic comptotalrecyclableplastic + [ leftovertrp ] of myself
      set extraincome [ leftovertrp ] of myself * technologyrecperc * sellingprice
      ;set extraincome extraincome - (opex * [ leftovertpw ] of myself)
      set margin 0.5 * extraincome ] ]
end

to sell-plastic
  set recoveredplastic comptotalrecyclableplastic * technologyrecperc
  set turnover sellingprice * recoveredplastic    ;; Selling price is given as user input in 1000 euros per ton
end

to finance-operations
  if subcontract = 0 [
    set collection-cost sum [ collection-income ] of in-link-neighbors
    set cost-of-processing opex * comptotalplasticwaste
    set fine sum [ totalfine ] of in-link-neighbors
    set bankaccount bankaccount + (turnover + fine + (sum [collectionexpense] of in-link-neighbors) - collection-cost - cost-of-processing) ]

  if subcontract = 1 [
    set collection-cost sum [collection-income] of in-link-neighbors
    set cost-of-processing opex * comptotalplasticwaste
    set fine sum [totalfine] of in-link-neighbors
    set bankaccount bankaccount + (turnover + fine + (sum [collectionexpense] of in-link-neighbors) - collection-cost - cost-of-processing + [ margin ] of subcontractor)

  ifelse investing = 0 [

  ifelse invest-process = 0 [

  if comptotalbasewaste != 0 [


   ifelse leftovertbw > 50 [
      set newvolume 40
      set gains sellingprice * newvolume * (comptotalplasticwaste / comptotalbasewaste) * (technologyrecperc * 1.05) * 60
      set investment-cost 3000
      set ROI (gains - investment-cost) / investment-cost
      if (bankaccount * 0.9) > investment-cost and ROI > 0.4 [
      set invest-process 1]

      ]

    [ set newvolume 20
      set gains sellingprice * newvolume * (comptotalplasticwaste / comptotalbasewaste) * (technologyrecperc * 1.05) * 60
      set investment-cost 2500
      set ROI (gains - investment-cost) / investment-cost
      if (bankaccount * 0.9) > investment-cost and ROI > 0.4 [
      set invest-process 1] ]
    ]                                 ;if statement of comptotalbasewaste ends

    ]

    [set invest-process invest-process + 1
      if invest-process = 12 [set investing 1 set invest-process 0]         ;else part of invest-process condition
      ]
  ]

     [ set volume/month volume/month + newvolume        ;;else statement of investing condition
       if technologyrecperc <= 0.95 [
      set technologyrecperc technologyrecperc * 1.05 ]
       if invest-nr < 4 [
      set opex opex * 0.8 ]
      set investing 0
      set invest-nr invest-nr + 1
  ] ]

  if subcontract = 2 [
      set collection-cost sum [collection-income] of in-link-neighbors
      set fine sum [totalfine] of in-link-neighbors
      set cost-of-processing opex * comptotalplasticwaste
      set bankaccount bankaccount + (turnover + fine + (sum [collectionexpense] of in-link-neighbors) - collection-cost - cost-of-processing + extraincome - margin)
      set margin 0
      set extraincome 0]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
0
@#$#@#$#@
