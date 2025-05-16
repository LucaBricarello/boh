(define (problem problem_test)
    (:domain warehouse)
    (:objects
        mover1 mover2 - mover
        loader1 - loader
        loader2 - cheapLoader
        loc1 loc2 loading-bay - location
        crate1 crate2 crate3 crate4 crate5 crate6 - crate
        g1 g2 - group
    )
    
    (:init
        (at-robby mover1 loading-bay)
        (at-robby mover2 loading-bay)
        (at-robby loader1 loading-bay)
        (at-robby loader2 loading-bay)

        (= (battery-status mover1) 20)
        (= (battery-status mover2) 20)
        
        (at-crate crate1 loc1)
        (at-crate crate2 loc2)
        (at-crate crate3 loc1)
        (at-crate crate4 loc2)
        (at-crate crate5 loc1)
        (at-crate crate6 loc1)

        (has-no-group crate6)

        (is-of-group crate1 g1)
        (is-of-group crate2 g1)
        (is-of-group crate3 g1)
        (is-of-group crate4 g2)
        (is-of-group crate5 g2)
        
        (free mover1)
        (free mover2)
        (free loader1)
        (free loader2)
        
        (is-bay loading-bay)
        ;(empty-bay)
        (no-active-group)
        
        (= (crates-to-load g1) 3)
        (= (crates-to-load g2) 2)

        (= (distance loc1 loading-bay) 10)
        (= (distance loading-bay loc1) 10)
        (= (distance loc2 loading-bay) 20)
        (= (distance loading-bay loc2) 20)
        
        (= (weight crate1) 20)
        (= (weight crate2) 20)
        (= (weight crate3) 20)
        (= (weight crate4) 20)
        (= (weight crate5) 20)
        (= (weight crate6) 20)

        (= (is-fragile crate1) 0)
        (= (is-fragile crate2) 0)
        (= (is-fragile crate3) 1)
        (= (is-fragile crate4) 1)
        (= (is-fragile crate5) 0)
        (= (is-fragile crate6) 0)
    )
    
    (:goal
        (and (loaded crate1) (loaded crate2) (loaded crate3) (loaded crate4) (loaded crate5) (loaded crate6))
    )
    
    (:metric minimize (total-time))
)