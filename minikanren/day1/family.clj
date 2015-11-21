(use 'clojure.core.logic)
(use 'clojure.core.logic.pldb)

(db-rel childo p c)
(db-rel spouseo p s)
(db-rel parento p r)
(db-rel persono p)
(def family
   (db
     [persono :fred-flintstone]
     [persono :wilma-flintstone]
     [persono :barney-rubble]
     [persono :betty-rubble]
     [persono :bamm-bamm-rubble]
     [persono :pebbles-flintstone]
     [persono :roxy-rubble]
     [persono :chip-rubble]

     [spouseo :fred-flintstone :wilma-flintstone]
     [spouseo :barney-rubble :betty-rubble]
     [spouseo :pebbles-flintstone :bamm-bamm-rubble]

     [parento :chip-rubble :pebbles-flintstone]
     [parento :chip-rubble :bamm-bamm-rubble]
     [childo :pebbles-flintstone :chip-rubble]
     [childo :bamm-bamm-rubble :chip-rubble]

     [parento :roxy-rubble :pebbles-flintstone]
     [parento :roxy-rubble :bamm-bamm-rubble]
     [childo :bamm-bamm-rubble :roxy-rubble]
     [childo :pebbles-flintstone :roxy-rubble]

     [parento :bamm-bamm-rubble :barney-rubble]
     [parento :bamm-bamm-rubble :betty-rubble]
     [childo :betty-rubble :bamm-bamm-rubble]
     [childo :barney-rubble :bamm-bamm-rubble]

     [parento :pebbles-flintstone :fred-flintstone]
     [parento :pebbles-flintstone :wilma-flintstone]
     [childo :fred-flintstone :pebbles-flintstone]
     [childo :wilma-flintstone :pebbles-flintstone]))

