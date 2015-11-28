(use 'clojure.core.logic.pldb)

(db-rel mano x)
(db-rel womano x)
(db-rel transo x)
(db-rel intersexo x)
(db-rel genderqueero x)
(db-rel vitalo p s)
(db-rel turingo p y)
(db-rel languageo p l)
(db-rel systemo p m)
(def facts
  (db
    [mano :alan-turing]
    [womano :grace-hopper]
    [transo :laverne-cox]
    [mano :leslie-lamport]
    [mano :alonzo-church]
    [womano :ada-lovelace]
    [womano :barbara-liskov]
    [womano :frances-allen]
    [mano :john-mccarthy]))
(def facts
  (-> facts
    (db-fact vitalo :alan-turing :dead)
    (db-fact vitalo :grace-hopper :dead)
    (db-fact vitalo :laverne-cox :alive)
    (db-fact vitalo :leslie-lamport :alive)
    (db-fact vitalo :alonzo-church :dead)
    (db-fact vitalo :ada-lovelace :dead)
    (db-fact vitalo :barbara-liskov :alive)
    (db-fact vitalo :frances-allen :alive)
    (db-fact vitalo :john-mccarthy :dead)
    (db-fact turingo :leslie-lamport :2013)
    (db-fact turingo :barbara-liskov :2008)
    (db-fact turingo :john-mccarthy :1971)
    (db-fact turingo :frances-allen :2006)))
(def facts
  (-> facts
    (db-fact languageo :alan-turing :turing)
    (db-fact languageo :grace-hopper :cobol)
    (db-fact languageo :grace-hopper :fortran)
    (db-fact languageo :leslie-lamport :tla)
    (db-fact languageo :alonzo-church :lambda-calculus)
    (db-fact languageo :ada-lovalace :note-g)
    (db-fact languageo :barbara-liskov :clu)
    (db-fact languageo :frances-allen :fortran)
    (db-fact languageo :frances-allen :autocoder)
    (db-fact languageo :john-mccarthy :lisp)
    (db-fact systemo :alan-turing :pilot-ace)
    (db-fact systemo :alan-turing :bombe)
    (db-fact systemo :alan-turing :turing-machine)
    (db-fact systemo :grace-hopper :univac)
    (db-fact systemo :ada-lovelace :analytical-engine)))
